const { Op } = require("sequelize");
const { sequelize } = require("../../db.config");
const { Reservation } = require("../models/reservation_model");
const { User } = require("../models/user_model");
const {
  getChat,
  getSubDiscussions,
  getDiscussionIdByChatId,
  getNotSeenMessages,
} = require("../sql/sql_request");
const { Booking } = require("../models/booking_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");

exports.getUserDiscussions = async (req, res) => {
  const searchText = req.query.searchText;
  const connected = req.decoded.id;

  try {
    let queryDiscussion = `
      SELECT
        discussion.*,
        chat.message,
        chat.seen,
        chat.createdAt,
        chat.sender_id,
        chat.reciever_id,
        chat.discussion_id
      FROM discussion
      LEFT JOIN(
          SELECT c1.*
          FROM chat c1
          INNER JOIN(
              SELECT discussion_id, MAX(createdAt) AS latestMessage
              FROM chat
              GROUP BY discussion_id
          ) c2
      ON c1.discussion_id = c2.discussion_id AND c1.createdAt = c2.latestMessage) chat
      ON discussion.id = chat.discussion_id
      WHERE discussion.owner_id = :connectedUserId OR discussion.user_id = :connectedUserId
      ${searchText ? "AND chat.message LIKE :searchText" : ""}
      GROUP BY discussion.id
      ORDER BY chat.createdAt ASC;
    `;

    let discussionList = await sequelize.query(queryDiscussion, {
      replacements: {
        connectedUserId: connected,
        searchText: `%${searchText}%`,
      },
      type: sequelize.QueryTypes.SELECT,
    });
    let userId, ownerId;
    const result = await Promise.all(
      discussionList.map(async (discussion) => {
        const ownerFound = await User.findOne({
          where: { id: discussion.owner_id },
        });
        const userFound = await User.findOne({
          where: { id: discussion.user_id },
        });
        userId = discussion.user_id;
        ownerId = discussion.owner_id;
        const notSeen = await getNotSeenMessages(discussion.id, connected);
        return {
          id: discussion.id,
          last_message_date: discussion.createdAt,
          last_message: discussion.message,
          owner_id: discussion.owner_id,
          owner_name: ownerFound.name,
          user_id: discussion.user_id,
          user_name: userFound.name,
          sender_id: discussion.sender_id,
          notSeen: notSeen ? notSeen : 0,
        };
      })
    );

    const conditions = [
      { [Op.or]: [{ status: "pending" }, { status: "confirmed" }] },
    ];
    // Add userId & ownerId condition if defined
    if (userId !== undefined && ownerId !== undefined)
      conditions.push({ [Op.or]: [{ user_id: userId }, { user_id: ownerId }] });
    const existActiveReservation = await Reservation.findAll({
      where: { [Op.and]: conditions },
      include: [
        { model: User, as: "user" },
        { model: Task, as: "task", include: [{ model: User, as: "user" }] },
      ],
    });
    const existActiveBooking = await Booking.findAll({
      where: { [Op.and]: conditions },
      include: [
        { model: User, as: "user" },
        { model: Service, as: "service" },
      ],
    });

    return res.status(200).json({
      result: result,
      reservations: existActiveReservation,
      bookings: existActiveBooking,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getNotSeenChat = async (req, res) => {
  const connected = req.decoded.id;
  let notSeen;
  try {
    let queryNotSeenDiscussion = `
    SELECT COUNT(*) as notSeen FROM chat WHERE reciever_id = :connected AND seen = false
    `;
    notSeen = await sequelize.query(queryNotSeenDiscussion, {
      replacements: {
        connected: connected,
      },
      type: sequelize.QueryTypes.SELECT,
    });

    return res.status(200).json({ result: notSeen[0]["notSeen"] });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.searchChat = async (req, res) => {
  try {
    const connected = req.decoded.id;
    const searchText = req.query.searchText;
    const discussionId = req.query.disc;
    if (!discussionId) {
      return res.status(400).json({ message: "missing_discussion" });
    }
    let queryNotSeenDiscussion = `
      select chat.*
      from chat
      join sub_discussion on chat.sub_discussion_id = sub_discussion.id
      where (sender_id = :connected or reciever_id = :connected)
      and sub_discussion.discussion_id = :discussionId
      ${searchText ? "and message like :searchText" : ""}
    `;
    const chatList = await sequelize.query(queryNotSeenDiscussion, {
      replacements: {
        connected: connected,
        discussionId: discussionId,
        searchText: `%${searchText}%`,
      },
      type: sequelize.QueryTypes.SELECT,
    });

    return res.status(200).json({ chatList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getChatsById = async (req, res) => {
  try {
    const connected = req.decoded.id;
    const idChat = req.query.idChat;

    let chatList = await getChat(null, idChat, connected);
    const olderChats = await getBeforeAfterChat(connected, idChat, true, 3);
    chatList = [...chatList, ...olderChats];
    return res.status(200).json({ chatList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getChatsBeforeAfter = async (req, res) => {
  try {
    const connected = req.decoded.id;
    const idChat = parseInt(req.query.idChat);
    const isBefore = req.query.isBefore == "true";

    const chatList = await getBeforeAfterChat(connected, idChat, isBefore);
    return res.status(200).json({ chatList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getMoreMessagesByDiscussionId = async (req, res) => {
  try {
    const { pageQuery, limitQuery, discussionId } = req.query;
    const page = pageQuery ?? 1;
    const limit = limitQuery ?? 11;
    const connected = req.decoded.id;

    let subDiscussionList = await getSubDiscussions(discussionId);
    const chatList = await getChat(
      subDiscussionList,
      null,
      connected,
      limit,
      page
    );

    return res.status(200).json({ chatList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

async function getBeforeAfterChat(connected, idChat, isBefore, limit) {
  const discussionId = await getDiscussionIdByChatId(idChat);
  let query = `
      SELECT chat.* FROM chat
      JOIN sub_discussion ON sub_discussion.id = chat.sub_discussion_id
      JOIN discussion ON discussion.id = sub_discussion.discussion_id
      WHERE (chat.sender_id = :connected OR chat.reciever_id = :connected) 
      AND sub_discussion.discussion_id = :discussionId
      AND ${isBefore ? "chat.id < :idChat" : "chat.id > :idChat"} 
      ORDER BY chat.createdAt DESC
      LIMIT :limit
        `;
  let chatList = await sequelize.query(query, {
    replacements: {
      discussionId: discussionId,
      idChat: idChat,
      isBefore: isBefore,
      connected: connected,
      limit: limit ?? 5,
    },
    type: sequelize.QueryTypes.SELECT,
  });
  chatList = chatList;
  return chatList;
}
