const { sequelize } = require("../../db.config");
const {
  getChat,
  getSubDiscussions,
  getDiscussionIdByChatId,
} = require("../sql/sql_request");

exports.getChat = async (req, res) => {
  const propertyId = req.query.id;
  const searchText = req.query.searchText;
  const connected = req.decoded.id;
  const clientId = req.decoded.role.includes("client") ? connected : null;
  const hostId = req.decoded.role.includes("owner") ? connected : null;

  let result;
  let discussionList;
  let newDiscussion;
  try {
    let queryDiscussion = `
    SELECT
    discussion.id,
    property.id AS property_id,
    property.name,
    property.owner_id,
    (SELECT NAME
     FROM client
     WHERE id = property.owner_id) AS owner_name,
    (SELECT NAME
     FROM client
     WHERE id = discussion.client_id) AS client_name,
    MIN(property_image.thumbnail) AS images,
    discussion.client_id,
    (SELECT COUNT(*)
     FROM chat
     JOIN sub_discussion ON sub_discussion.id = chat.sub_discussion_id
     LEFT JOIN discussion AS des ON discussion.id = sub_discussion.discussion_id
     WHERE reciever_id = :connectedUserId
       AND seen = FALSE
       AND discussion.id = des.id) AS notSeen,
    (SELECT message
     FROM chat
     WHERE chat.sub_discussion_id = (
             SELECT MAX(sub_discussion.id)
             FROM sub_discussion
             WHERE sub_discussion.discussion_id = discussion.id)
       AND chat.sender_id = :connectedUserId
     ORDER BY chat.createdAt DESC
     LIMIT 1) AS last_message,
    (SELECT chat.createdAt
     FROM chat
     WHERE chat.sub_discussion_id = (
             SELECT MAX(sub_discussion.id)
             FROM sub_discussion
             WHERE sub_discussion.discussion_id = discussion.id)
       AND chat.sender_id = :connectedUserId 
     ORDER BY chat.createdAt DESC
     LIMIT 1) AS last_message_date
FROM discussion
LEFT JOIN property ON discussion.property_id = property.id
LEFT JOIN property_image ON discussion.property_id = property_image.property_id
    ${
      hostId
        ? "WHERE discussion.owner_id = :hostId"
        : clientId
        ? "WHERE discussion.client_id = :clientId"
        : " where false"
    }
    ${
      searchText
        ? "AND (property.id LIKE :searchText OR (SELECT NAME FROM client WHERE id = discussion.client_id) LIKE :searchText OR property.name LIKE :searchText)"
        : ""
    }
    ${!hostId && !clientId ? "where false" : ""}
    GROUP BY discussion.client_id,
            discussion.owner_id,
            discussion.property_id
            ORDER BY last_message_date DESC
    `;

    discussionList = await sequelize.query(queryDiscussion, {
      replacements: {
        clientId: clientId,
        hostId: hostId,
        connectedUserId: connected,
        searchText: `%${searchText}%`,
      },
      type: sequelize.QueryTypes.SELECT,
    });
    const mappedDiscussion = discussionList.map((discussion) => {
      return {
        id: discussion.id,
        last_message_date: discussion.last_message_date,
        last_message: discussion.last_message,
        property_id: discussion.property_id,
        name: discussion.name,
        owner_id: discussion.owner_id,
        owner_name: discussion.owner_name,
        client_id: discussion.client_id,
        client_name: discussion.client_name,
        images: discussion.images,
        sender_id: discussion.sender_id,
        notSeen: discussion.notSeen ? discussion.notSeen : 0,
      };
    });

    // If propertyId is provided, add conditions to fetch data related to it
    if (propertyId) {
      let queryNewDiscussion = `
      SELECT
        property.id as property_id,
        property.name,
        property.owner_id,
        MIN(property_image.thumbnail) AS images
      FROM property
      LEFT JOIN property_image ON property.id = property_image.property_id
      WHERE property.id = :propertyId
      GROUP BY property.id
      `;
      newDiscussion = await sequelize.query(queryNewDiscussion, {
        replacements: { propertyId: propertyId },
        type: sequelize.QueryTypes.SELECT,
      });
      const mappedNewDiscussion = newDiscussion.map((discussion) => {
        return {
          id: -1,
          property_id: discussion.property_id,
          name: discussion.name,
          owner_id: discussion.owner_id,
          images: discussion.images,
          sender_id: clientId ? clientId : hostId,
        };
      });
      result = [...mappedNewDiscussion, ...mappedDiscussion];
    } else {
      result = mappedDiscussion;
    }

    return res.status(200).json({ result: result });
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
