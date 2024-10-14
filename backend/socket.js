// socket.js
const { Op } = require("sequelize");
const { Chat } = require("./src/models/chat_model");
const { User } = require("./src/models/user_model");
const { Discussion } = require("./src/models/discussion_model");
const { getChat, populateContract } = require("./src/sql/sql_request");
const { sendMail } = require("./src/helper/email_service");
const { NotificationType } = require("./src/helper/notification_service");
const { Contract } = require("./src/models/contract_model");
const { isUUID } = require("./src/helper/helpers");
const { Task } = require("./src/models/task_model");
const { Service } = require("./src/models/service_model");
const { createContract } = require("./src/helper/pdfHelper");

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
        // Check if there is a chat with a contract id and fetch the contract if so
        const formattedList = await Promise.all(
          chatHistoryList.map(async (row) => {
            if (isUUID(row.message)) {
              const contract = await populateContract(row.message);
              return contract;
            } else {
              return row;
            }
          })
        );
        socket.join(`${discussionId}`);
        socket.emit("chatHistory", { chatHistoryList: formattedList });
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
          title: "You Got a New Message",
          body: `${sender.name}: ${msg.message}`,
          type: NotificationType.CHAT,
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
    // Create a contract
    socket.on("createContract", async (data) => {
      try {
        let reciever = await User.findByPk(data.reciever);
        let sender = await User.findByPk(data.sender);
        let discussion =
          data.discussionId && data.discussionId != -1
            ? await Discussion.findByPk(data.discussionId)
            : await Discussion.findOne({
                where: {
                  [Op.or]: [
                    { user_id: sender.id, owner_id: reciever.id },
                    { owner_id: sender.id, user_id: reciever.id },
                  ],
                },
              });
        if (!discussion) throw new Error("discussion not found");

        // Create a new chat message entry in the database
        let contract = await Contract.create({
          finalPrice: data.contract.finalPrice,
          dueDate: data.contract.dueDate.split("T")[0],
          service_id: data.contract.service?.id,
          task_id: data.contract.task?.id,
          reservation_id: data.reservationId,
          seeker_id: data.sender,
          provider_id: data.reciever,
        });

        // Create the pdf contract with the given data
        await createContract({
          contractId: contract.id,
          date: new Date().toLocaleDateString(),
          seekerName: sender.name,
          providerName: reciever.name,
          taskDescription: data.contract.task.description,
          deliverables: data.contract.task.delivrables,
          deliveryDate: contract.dueDate,
          price: contract.finalPrice,
          language: "fr",
        });

        // Create a new chat message for contract tracking (history in discussion)
        await Chat.create({
          message: contract.id,
          sender_id: data.sender,
          reciever_id: data.reciever,
          discussion_id: discussion.id,
        });

        // Emit to reciever if not joined a room
        io.to(`${data.reciever}`).emit("notification", {
          title: "You Got a New Contract",
          body: `${sender.name}: ${data.contract}`,
          type: NotificationType.CHAT,
        });
        // Populate contract's task/service
        contract = await populateContract(contract.id);
        // Emit the message to all users in the room
        io.to(`${data.discussionId}`).emit("newContract", {
          contract: contract,
        });
        // TODO send an email to both parties with the new created contract
        // const template = notificationMessage(sender, msg.message, property);
        // sendMail(
        //   reciever.id == 1 ? process.env.AUTH_USER_EMAIL : reciever.email,
        //   `"Nouveau message" de ${sender.name}`,
        //   template,
        //   false //true for localhost, false for cloud
        // );
      } catch (error) {
        console.error("Error creating contract to database:", error);
      }
    });
    // Sign a contract
    socket.on("signContract", async (data) => {
      try {
        const ID = data.contractId;

        let contract = await populateContract(ID);
        contract.isSigned = true;
        contract.save();
        
        // Emit the message to all users in the room
        io.to(`${data.discussionId}`).emit("updateContract", {
          contract: contract,
        });
        // Emit to reciever if not joined a room
        io.to(`${contract.seeker_id}`).emit("notification", {
          title: "Your contract has been signed",
          body: `${contract}`,
          type: NotificationType.CHAT,
        });
      } catch (error) {
        console.error("Error signing contract:", error);
      }
    });
    // Pay a contract
    socket.on("payContract", async (data) => {
      try {
        const ID = data.contractId;

        let contract = await populateContract(ID);
        contract.isPayed = true;
        contract.save();

        // Emit the message to all users in the room
        io.to(`${data.discussionId}`).emit("updateContract", {
          contract: contract,
        });
        // Emit to reciever if not joined a room
        io.to(`${contract.provider_id}`).emit("notification", {
          title: "Your contract has been payed",
          body: `${contract}`,
          type: NotificationType.CHAT,
        });
      } catch (error) {
        console.error("Error paying contract:", error);
      }
    });
  });

  return io;
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
