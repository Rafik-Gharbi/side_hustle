// socket.js
const { Op } = require("sequelize");
const { Chat } = require("./src/models/chat_model");
const { User } = require("./src/models/user_model");
const { Discussion } = require("./src/models/discussion_model");
const { getChat } = require("./src/sql/sql_request");
const { sendMail } = require("./src/helper/email_service");

function initializeSocket(io) {
  // const io = socketIo(server);

  io.on("connection", async (socket) => {
    // console.log(`${socket.id} has connected`);

    socket.on("disconnect", () => {
      // console.log("User disconnected");
    });

    //mark as seen
    socket.on("markAsSeen", async ({ connected, sender, discussionId }) => {
      await markAsSeen(sender, connected, discussionId);
    });

    // When a user connects, fetch chat history or create a new room
    socket.on("join", async ({ connected, sender, discussionId }) => {
      try {
        let chatHistoryList = [];
        if (discussionId && discussionId != -1) {
          chatHistoryList = await getChat(discussionId, null, connected);
        }
        socket.join(`${discussionId}`);
        socket.emit("chatHistory", { chatHistoryList });
      } catch (error) {
        console.error("Error fetching chat history:", error);
      }
    });

    // Connect user to standby room based on his ID for notifying him when outside messages screen
    socket.on("standBy", async ({ userId }) => {
      try {
        // Join room based on user IDs
        socket.join(`${userId}`);
      } catch (error) {
        console.error("Error joining user to standby: ", error);
      }
    });

    socket.on("chatMessage", async (msg) => {
      let isNewBubble = false;
      try {
        let reciever = await User.findByPk(msg.reciever);
        let sender = await User.findByPk(msg.sender);
        let discussion = msg.discussionId
          ? await Discussion.findByPk(msg.discussionId)
          : await Discussion.findOne({
              where: {
                [Op.or]: [
                  { user_id: sender.id, owner_id: reciever.id },
                  { owner_id: sender.id, user_id: reciever.id },
                ],
              },
            });
        if (!discussion || msg.discussionId == -1) {
          // TODO check if connected is owner to reverse this below if so
          discussion = await Discussion.create({
            user_id: reciever.id,
            owner_id: sender.id,
          });
          isNewBubble = true;
        }

        // Create a new chat message entry in the database
        const createMsg = await Chat.create({
          message: msg.message,
          sender_id: msg.sender,
          reciever_id: msg.reciever,
          discussion_id: isNewBubble ? discussion.id : msg.discussionId,
        });

        if (isNewBubble) {
          io.to(`${reciever.id}`).emit("newBubble", createMsg);
        }
        // Emit to reciever if not joined a room
        io.to(`${msg.reciever}`).emit("notification", {
          msg: msg.message,
          recieverName: reciever.name,
          senderName: sender.name,
        });

        // Emit the message to all users in the room
        io.to(`${msg.discussionId}`).emit("chatMessage", {
          createMsg,
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

async function markAsSeen(sender, connected, discussionId) {
  // Fetch chat history between the sender and the user
  const chatHistory = await Chat.findAll({
    where: {
      [Op.or]: [{ sender_id: sender }, { reciever_id: sender }],
      discussion_id: discussionId,
      seen: false,
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
