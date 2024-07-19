// socket.js
const { Op } = require("sequelize");
const { sequelize } = require("./db.config");
const { Chat } = require("./src/models/chat_model");
const { Task } = require("./src/models/task_model");
const { User } = require("./src/models/user_model");
const { Discussion } = require("./src/models/discussion_model");
const { getSubDiscussions, getChat } = require("./src/sql/sql_request");
const { sendMail } = require("./src/helper/email_service");

function initializeSocket(io) {
  // const io = socketIo(server);

  io.on("connection", async (socket) => {
    // console.log(`${socket.id} has connected`);

    socket.on("disconnect", () => {
      // console.log("User disconnected");
    });

    //mark as seen
    socket.on("markAsSeen", async ({ connected, sender, subDiscussionId }) => {
      if (subDiscussionId) {
        let queryDiscussion = `
        select owner_id
        from discussion 
        left join sub_discussion on discussion.id = sub_discussion.discussion_id 
        WHERE sub_discussion.discussion_id = :sub_discussion_id
        `;

        const owner_id = await sequelize.query(queryDiscussion, {
          replacements: {
            sub_discussion_id: subDiscussionId,
          },
          type: sequelize.QueryTypes.SELECT,
        });

        await markAsSeen(
          subDiscussionId,
          sender,
          owner_id[0].owner_id,
          connected
        );
      }
    });

    // When a user connects, fetch chat history or create a new room
    socket.on(
      "join",
      async ({ connected, sender, propertyId, discussionId }) => {
        try {
          let subDiscussionList = [];
          let chatHistoryBySubDiscussion = [];

          if (discussionId && discussionId != -1) {
            subDiscussionList = await getSubDiscussions(discussionId);
            chatHistoryBySubDiscussion = await getChat(subDiscussionList, null);
            chatHistoryBySubDiscussion = await markAsSeenByList(
              chatHistoryBySubDiscussion,
              connected
            );
          }
          // Join room based on the property, sender, and owner IDs
          socket.join(`${sender}-${propertyId}`);
          const chatHistory = subDiscussionList.map((subDiscussion) => {
            const chats = chatHistoryBySubDiscussion
              .filter((chat) => chat.sub_discussion_id === subDiscussion.id)
              .map((chat) => ({ ...chat }));

            return { ...subDiscussion, chats };
          });
          // Send chat history to the user
          socket.emit("chatHistory", { chatHistory });
        } catch (error) {
          console.error("Error fetching chat history:", error);
        }
      }
    );

    // Connect user to standby room based on his ID for notifying him when outside messages screen
    socket.on("standBy", async ({ userId }) => {
      try {
        // Join room based on owner IDs
        socket.join(`${userId}`);
      } catch (error) {
        console.error("Error joining user to standby: ", error);
      }
    });

    socket.on("chatMessage", async (msg) => {
      let discussion;
      let subDiscussion;
      let isNewBubble = false;
      try {
        const owner = await Task.findByPk(msg.propertyId, {
          attributes: ["owner_id"],
        });
        const client = owner.owner_id == msg.sender ? msg.reciever : msg.sender;
        if (msg.subDiscussionId == null || msg.subDiscussionId == -1) {
          discussion = await Discussion.findOne({
            where: {
              property_id: msg.propertyId,
              client_id: client,
              owner_id: owner.owner_id,
            },
          });

          if (!discussion) {
            discussion = await Discussion.create({
              owner_id: owner.owner_id,
              client_id: client,
              property_id: msg.propertyId,
            });
            isNewBubble = true;
          }
          // subDiscussion = await SubDiscussion.create({
          //   date_from: msg.dateFrom,
          //   date_to: msg.dateTo,
          //   price: msg.price,
          //   discussion_id: discussion.id,
          // });
        } else {
          subDiscussion = await SubDiscussion.findByPk(msg.subDiscussionId);
        }

        // Create a new chat message entry in the database
        const createMsg = await Chat.create({
          message: msg.message,
          sender_id: msg.sender,
          reciever_id: msg.reciever,
          sub_discussion_id: subDiscussion
            ? subDiscussion.id
            : msg.subDiscussionId,
        });

        if (isNewBubble) {
          io.to(`${owner.owner_id}`).emit("newBubble", createMsg);
        }
        let reciever = await User.findByPk(msg.reciever);
        let sender = await User.findByPk(msg.sender);
        // let property = await TaskImage.findOne({
        //   where: {
        //     property_id: msg.propertyId,
        //     type: 1,
        //   },
        // });
        // Emit to reciever if not joined a room
        io.to(`${msg.reciever}`).emit("notification", {
          msg: msg.message,
          recieverName: reciever.name,
          propertyId: msg.propertyId,
        });

        // Emit the message to all users in the room
        io.to(`${client}-${msg.propertyId}`).emit("chatMessage", {
          createMsg,
          subDiscussion,
        });
        // const template = notificationMessage(sender, msg.message, property);
        // sendMail(
        //   reciever.id == 1 ? process.env.AUTH_USER_EMAIL : reciever.email,
        //   `"Nouveau message" de ${sender.name}`,
        //   template,
        //   false //true for localhost, false for cloud
        // );
      } catch (error) {
        console.error("Error saving message to database:", error);
      }
    });
  });
}

async function markAsSeenByList(chatHistory, connected) {
  chatHistory.forEach(async (message) => {
    if (message.reciever_id == connected && message.seen == false) {
      message.seen = true;
      await Chat.update(message, {
        where: {
          id: message.id,
        },
      });
    }
  });

  return chatHistory;
}

async function markAsSeen(sub_discussion_id, sender, owner_id, connected) {
  // Fetch chat history between the sender and the owner
  const chatHistory = await Chat.findAll({
    where: {
      sub_discussion_id: sub_discussion_id,
      [Op.or]: [
        { sender_id: sender, reciever_id: owner_id },
        { sender_id: owner_id, reciever_id: sender },
      ],
    },
    order: [["createdAt", "ASC"]],
  });

  chatHistory.forEach(async (message) => {
    if (message.reciever_id == connected && message.seen == false) {
      message.seen = true;
      await message.save();
    }
  });

  return chatHistory;
}

module.exports = initializeSocket;
