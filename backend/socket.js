// socket.js
const { Op } = require("sequelize");
const { Chat } = require("./src/models/chat_model");
const { User } = require("./src/models/user_model");
const { Discussion } = require("./src/models/discussion_model");
const { getChat, populateContract } = require("./src/sql/sql_request");
const { NotificationType } = require("./src/helper/notification_service");
const { Contract } = require("./src/models/contract_model");
const { isUUID, verifyToken } = require("./src/helper/helpers");
const { createContract } = require("./src/helper/pdfHelper");
const {
  getAdminData,
  getAllReports,
  getBalanceTransactions,
  updateStatus,
  usersForApproving,
  getUsersFeedbacks,
  getBalanceStatsData,
  getCategoriesStatsData,
  getChatStatsData,
  getCoinPackStatsData,
  getContractStatsData,
  getFavoriteStatsData,
  getFeedbackStatsData,
  getGovernorateStatsData,
  getReferralStatsData,
  getReportStatsData,
  getTaskStatsData,
  getUserStatsData,
  getStoreStatsData,
  getReviewStatsData,
  approveUser,
  userNotApprovable,
  getUsersSupport,
} = require("./src/controllers/admin_controller");
const {
  BalanceTransaction,
} = require("./src/models/balance_transaction_model");

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
            reservation_id: msg.reservationId,
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
          io.to(`${sender.id}`).emit("updateDiscussionId", createMsg);
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
        if (!data.contract.task && !data.contract.service)
          throw new Error("a task or service is required");

        // Create a new chat message entry in the database
        let contract = await Contract.create({
          finalPrice: data.contract.finalPrice,
          dueDate: data.contract.dueDate.split("T")[0],
          description: data.contract.description,
          delivrables: data.contract.delivrables,
          reservation_id: data.reservationId,
          seeker_id: data.contract.task ? data.sender : data.reciever,
          provider_id: data.contract.task ? data.reciever : data.sender,
        });

        // Create the pdf contract with the given data
        await createContract({
          contractId: contract.id,
          date: new Date().toLocaleDateString(),
          seekerName: sender.name,
          providerName: reciever.name,
          taskDescription: data.contract.description,
          deliverables: data.contract.delivrables,
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
    // Pay a contract from balance
    socket.on("payContract", async (data) => {
      try {
        const ID = data.contractId;

        let contract = await populateContract(ID);
        contract.isPayed = true;
        contract.save();

        const seeker = await User.findByPk(contract.seeker_id);
        seeker.balance -= contract.finalPrice + contract.finalPrice * 0.1;
        await seeker.save();

        BalanceTransaction.create({
          userId: seeker.id,
          amount: contract.finalPrice + contract.finalPrice * 0.1,
          type: "taskPayment",
          status: "completed",
          description: `Payment for contract ${contract.id}`,
        });

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
    // **************************** Admin Stats ****************************
    // Get admin dashboard data
    socket.on("getDashboardData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        socket.join(`${adminUser.id}-adminDashboard`);

        const adminDashboard = await getAdminData();
        io.emit("updateAdminDashboard", {
          adminDashboard: adminDashboard,
        });
      } catch (error) {
        console.error("Error getting admin data:", error);
      }
    });
    socket.on("getAdminReport", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const reports = await getAllReports();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminReport", {
          reports: reports,
        });
      } catch (error) {
        console.error("Error getting admin reports:", error);
      }
    });
    socket.on("getAdminFeedbacks", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const feedbacks = await getUsersFeedbacks();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminFeedbacks", {
          feedbacks: feedbacks,
        });
      } catch (error) {
        console.error("Error getting admin feedbacks:", error);
      }
    });
    socket.on("getAdminSupport", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const tickets = await getUsersSupport();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminSupport", {
          tickets: tickets,
        });
      } catch (error) {
        console.error("Error getting admin support tickets:", error);
      }
    });
    socket.on("getAdminBalance", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const transactions = await getBalanceTransactions();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminBalance", {
          transactions: transactions,
        });
      } catch (error) {
        console.error("Error getting admin feedbacks:", error);
      }
    });
    socket.on("rejectBalanceRequest", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const done = await updateStatus(data.id, data.status);
        if (done) {
          const transactions = await getBalanceTransactions();
          io.to(`${adminUser.id}-adminDashboard`).emit("adminBalance", {
            transactions: transactions,
          });
        }
        io.to(`${adminUser.id}-adminDashboard`).emit("adminBalanceStatus", {
          done: done,
        });
      } catch (error) {
        console.error("Error getting admin feedbacks:", error);
      }
    });
    socket.on("acceptBalanceRequest", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const done = await updateStatus(data.id, data.status);
        await new Promise((resolve) => setTimeout(resolve, 400));
        if (done) {
          const transactions = await getBalanceTransactions();
          io.to(`${adminUser.id}-adminDashboard`).emit("adminBalance", {
            transactions: transactions,
          });
        }
        io.to(`${adminUser.id}-adminDashboard`).emit("adminBalanceStatus", {
          done: done,
        });
      } catch (error) {
        console.error("Error getting admin feedbacks:", error);
      }
    });
    socket.on("getAdminApproveUsers", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const users = await usersForApproving();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminApproveUsers", {
          users: users,
        });
      } catch (error) {
        console.error("Error getting admin approve users:", error);
      }
    });
    socket.on("rejectApproveUser", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const done = await userNotApprovable(data.id, data.status);
        if (typeof done !== "string") {
          const users = await usersForApproving();
          io.to(`${adminUser.id}-adminDashboard`).emit("adminApproveUsers", {
            users: users,
          });
          io.to(`${adminUser.id}-adminDashboard`).emit("adminApproveStatus", {
            done: done,
          });
        } else {
          throw new Error(done);
        }
      } catch (error) {
        console.error("Error rejecting approve user:", error);
      }
    });
    socket.on("acceptApproveUser", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const done = await approveUser(data.id, data.status);
        if (typeof done !== "string") {
          const users = await usersForApproving();
          io.to(`${adminUser.id}-adminDashboard`).emit("adminApproveUsers", {
            users: users,
          });
          io.to(`${adminUser.id}-adminDashboard`).emit("adminApproveStatus", {
            done: done,
          });
        } else {
          throw new Error(done);
        }
      } catch (error) {
        console.error("Error accepting approve user:", error);
      }
    });
    socket.on("getAdminBalanceStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const balanceStats = await getBalanceStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminBalanceStatsData", {
          balanceStats: balanceStats,
        });
      } catch (error) {
        console.error("Error getting admin balance stats data:", error);
      }
    });
    socket.on("getAdminCategoryStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const categoryStats = await getCategoriesStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminCategoryStatsData", {
          categoryStats: categoryStats,
        });
      } catch (error) {
        console.error("Error getting admin categories stats data:", error);
      }
    });
    socket.on("getAdminChatStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const chatStats = await getChatStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminChatStatsData", {
          chatStats: chatStats,
        });
      } catch (error) {
        console.error("Error getting admin chat stats data:", error);
      }
    });
    socket.on("getAdminCoinStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const coinStats = await getCoinPackStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminCoinStatsData", {
          coinStats: coinStats,
        });
      } catch (error) {
        console.error("Error getting admin coin stats data:", error);
      }
    });
    socket.on("getAdminContractStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const contractStats = await getContractStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminContractStatsData", {
          contractStats: contractStats,
        });
      } catch (error) {
        console.error("Error getting admin contract stats data:", error);
      }
    });
    socket.on("getAdminFavoriteStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const favoriteStats = await getFavoriteStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminFavoriteStatsData", {
          favoriteStats: favoriteStats,
        });
      } catch (error) {
        console.error("Error getting admin favorite stats data:", error);
      }
    });
    socket.on("getAdminFeedbackStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const feedbackStats = await getFeedbackStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminFeedbackStatsData", {
          feedbackStats: feedbackStats,
        });
      } catch (error) {
        console.error("Error getting admin feedback stats data:", error);
      }
    });
    socket.on("getAdminGovernorateStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const governorateStats = await getGovernorateStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit(
          "adminGovernorateStatsData",
          {
            governorateStats: governorateStats,
          }
        );
      } catch (error) {
        console.error("Error getting admin governorate stats data:", error);
      }
    });
    socket.on("getAdminReferralStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const referralStats = await getReferralStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminReferralStatsData", {
          referralStats: referralStats,
        });
      } catch (error) {
        console.error("Error getting admin referral stats data:", error);
      }
    });
    socket.on("getAdminReportStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const reportStats = await getReportStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminReportStatsData", {
          reportStats: reportStats,
        });
      } catch (error) {
        console.error("Error getting admin report stats data:", error);
      }
    });
    socket.on("getAdminReviewStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const reviewStats = await getReviewStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminReviewStatsData", {
          reviewStats: reviewStats,
        });
      } catch (error) {
        console.error("Error getting admin review stats data:", error);
      }
    });
    socket.on("getAdminStoreStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const storeStats = await getStoreStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminStoreStatsData", {
          storeStats: storeStats,
        });
      } catch (error) {
        console.error("Error getting admin store stats data:", error);
      }
    });
    socket.on("getAdminTaskStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const taskStats = await getTaskStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminTaskStatsData", {
          taskStats: taskStats,
        });
      } catch (error) {
        console.error("Error getting admin task stats data:", error);
      }
    });
    socket.on("getAdminUserStatsData", async (data) => {
      try {
        const adminUser = await validateAdmin(data.jwt);
        if (!adminUser) return;
        const userStats = await getUserStatsData();
        io.to(`${adminUser.id}-adminDashboard`).emit("adminUserStatsData", {
          userStats: userStats,
        });
      } catch (error) {
        console.error("Error getting admin user stats data:", error);
      }
    });

    return io;
  });

  return io;
}

// Helper function to validate admin
async function validateAdmin(jwt) {
  try {
    const adminUser = await verifyToken(jwt);
    return adminUser?.role === "admin" ? adminUser : null;
  } catch (error) {
    logger.error("Admin validation failed:", error);
    return null;
  }
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
