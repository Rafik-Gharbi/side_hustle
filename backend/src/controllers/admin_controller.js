const { User } = require("../models/user_model");
const { UserDocumentModel } = require("../models/user_document_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const { Transaction } = require("../models/transaction_model");
const { Referral } = require("../models/referral_model");
const { CoinPackPurchase } = require("../models/coin_pack_purchase_model");
const { CoinPack } = require("../models/coin_pack_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");
const { Report } = require("../models/report_model");
const { Feedback } = require("../models/feedback_model");
const {
  getApproveUsersRequiredActionsCount,
  getBalanceTransactionsRequiredActionsCount,
  getUserReportsRequiredActionsCount,
  getUserFeedbacksRequiredActionsCount,
  populateServices,
  populateStores,
} = require("../sql/sql_request");
const { Sequelize, sequelize } = require("../../db.config");
const { Op } = require("sequelize");
const { Contract } = require("../models/contract_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { Reservation } = require("../models/reservation_model");
const { Store } = require("../models/store_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const { Category } = require("../models/category_model");
const { Discussion } = require("../models/discussion_model");
const { PurchasedCoins } = require("../models/purchased_coins_model");
const { FavoriteStore } = require("../models/favorite_store_model");
const { FavoriteTask } = require("../models/favorite_task_model");
const { Review } = require("../models/review_model");

exports.usersForApproving = async (req, res) => {
  try {
    const connectedUserId = req.decoded.id;

    const connectedUser = await User.findByPk(connectedUserId);
    if (!connectedUser) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const approveUsers = await User.findAll({
      where: { isVerified: "pending" },
    });

    const users = await Promise.all(
      approveUsers.map(async (user) => {
        const userDocument = await UserDocumentModel.findOne({
          where: { user_id: user.id },
        });
        return { user, userDocument };
      })
    );

    return res.status(200).json({ users });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.approveUser = async (req, res) => {
  try {
    const userForApproveId = req.query.userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return res.status(404).json({ message: "user_not_found" });
    }

    userApprove.isVerified = "verified";
    await userApprove.save();

    const referral = await Referral.findOne({
      where: { referred_user_id: userApprove.id },
      include: [{ model: User, as: "referred_user" }],
    });
    let coinPurchase;
    let coinPack;
    let referrer;
    let isReferrerRewarded = false;
    if (referral) {
      await referral.update({
        status: "registered",
        reward_coins: 5,
        registration_date: new Date(),
      });

      coinPack = await CoinPack.findOne({ where: { totalCoins: 5 } });

      coinPurchase = await CoinPackPurchase.create({
        user_id: userApprove.id,
        coin_pack_id: coinPack.id,
        available: coinPack.totalCoins,
      });
      await Transaction.create({
        coins: coinPack.totalCoins,
        coin_pack_id: coinPurchase.id,
        user_id: userApprove.id,
        status: "completed",
        type: "purchase",
      });

      referrer = await User.findByPk(referral.referrer_id);
      if (referrer.coins + 5 < 100) {
        isReferrerRewarded = true;
        referrer.coins += 5;
        referrer.availableCoins += 5;
        referrer.save();
      }
    }

    notificationService.sendNotification(
      userApprove.id,
      "Successfully Approved",
      "Your profile has been approved.",
      NotificationType.VERIFICATION,
      { userId: userApprove.id, Approved: true }
    );
    if (coinPurchase) {
      // For referrer
      if (isReferrerRewarded)
        notificationService.sendNotification(
          referral.referrer_id,
          "🎉 You Earned a Referral Reward!",
          "Your friend joined Ekhdemli! You've earned more base coins. Thanks for helping grow our community!",
          NotificationType.REWARDS,
          { baseCoins: referrer.coins }
        );
      // For referee
      notificationService.sendNotification(
        userApprove.id,
        "🎉 You Earned a Referral Reward!",
        "Your referral reward has been credited to your account. Keep referring and keep earning!",
        NotificationType.REWARDS,
        { coinPack: coinPack.title }
      );
    }

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.userNotApprovable = async (req, res) => {
  try {
    const userForApproveId = req.query.userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const userDocument = await UserDocumentModel.findOne({
      where: { user_id: userForApproveId },
    });
    if (!userDocument) {
      return res.status(404).json({ message: "user_document_not_found" });
    }

    userDocument.destroy();
    userApprove.isVerified = "none";
    await userApprove.save();

    notificationService.sendNotification(
      userApprove.id,
      "Failed to Approve",
      "Your profile hasn't been approved. Probably your profile is missing some needed data or your provided documents weren't acceptable.",
      NotificationType.VERIFICATION,
      { userId: userApprove.id, Approved: false }
    );
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getBalanceTransactions = async (req, res) => {
  try {
    const pendingTransactions = await BalanceTransaction.findAll({
      where: { status: "pending" },
      include: [{ model: User, as: "user" }],
    });
    return res.status(200).json({ tansactions: pendingTransactions });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getAllReports = async (req, res) => {
  try {
    // TODO group reports by user
    const allReports = await Report.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reportedUser" },
      ],
    });
    return res.status(200).json({ reports: allReports });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getUsersFeedbacks = async (req, res) => {
  try {
    // TODO group feedback by user
    const allFeedbacks = await Feedback.findAll({
      include: [{ model: User, as: "user" }],
    });
    return res.status(200).json({ feedbacks: allFeedbacks });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getAdminData = async (req, res) => {
  try {
    const approveUsersActionRequired =
      await getApproveUsersRequiredActionsCount();
    const balanceTransactionsActionRequired =
      await getBalanceTransactionsRequiredActionsCount();
    const userReportsActionRequired =
      await getUserReportsRequiredActionsCount();
    const userFeedbacksActionRequired =
      await getUserFeedbacksRequiredActionsCount();
    return res.status(200).json({
      approveCount: approveUsersActionRequired,
      balanceCount: balanceTransactionsActionRequired,
      reportsCount: userReportsActionRequired,
      feedbackCount: userFeedbacksActionRequired,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

/// userList, activeCount
exports.getUserStatsData = async (req, res) => {
  try {
    const users = await User.findAll();
    const transactionUsers = await sequelize.query(
      `
      SELECT DISTINCT user_id FROM transaction 
      WHERE createdAt >= NOW() - INTERVAL 30 DAY
    `,
      { type: Sequelize.QueryTypes.SELECT }
    );

    const reservationUsers = await sequelize.query(
      `
      SELECT DISTINCT user_id FROM reservation 
      WHERE createdAt >= NOW() - INTERVAL 30 DAY
    `,
      { type: Sequelize.QueryTypes.SELECT }
    );

    // Combine results and get unique user IDs
    const activeUserIds = [
      ...new Set([
        ...transactionUsers.map((user) => user.user_id),
        ...reservationUsers.map((user) => user.user_id),
      ]),
    ];

    return res.status(200).json({
      users: users,
      activeCount: activeUserIds.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

/// depositList, withdrawalList, maxBalance, totalUsers
exports.getBalanceStatsData = async (req, res) => {
  try {
    const usersHasBalance = await User.findAll({
      where: { balance: { [Op.gt]: 0 } },
    });
    const withdrawals = await BalanceTransaction.findAll({
      where: { type: "withdrawal", status: { [Op.not]: "failed" } },
    });
    const deposits = await BalanceTransaction.findAll({
      where: { type: "deposit", status: { [Op.not]: "failed" } },
    });
    const maxBalance = await User.max("balance");

    return res.status(200).json({
      depositList: deposits,
      withdrawalList: withdrawals,
      maxBalance: maxBalance,
      totalUsers: usersHasBalance.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

/// storeList, userList, taskList, contractList
exports.getGovernorateStatsData = async (req, res) => {
  try {
    let stores = await Store.findAll();
    stores = await populateStores(stores);
    const users = await User.findAll();
    const tasks = await Task.findAll({
      include: [{ model: User, as: "user" }],
    });
    const contracts = await Contract.findAll();

    return res.status(200).json({
      tasks: tasks,
      users: users,
      contracts: contracts,
      stores: stores,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

/// referralsList, referralSuccessCount
exports.getReferralStatsData = async (req, res) => {
  try {
    const referrals = await Referral.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "referred_user" },
      ],
    });
    const successful = await Referral.findAll({
      where: { status: "activated" },
    });

    return res.status(200).json({
      referrals: referrals,
      successCount: successful.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getContractStatsData = async (req, res) => {
  try {
    const contracts = await Contract.findAll({
      include: [
        { model: Task, as: "task" },
        { model: Service, as: "service" },
      ],
    });

    return res.status(200).json({
      contracts: contracts,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// stores, ServiceUsage
exports.getStoreStatsData = async (req, res) => {
  try {
    let stores = await Store.findAll({
      include: [{ model: User, as: "user" }],
    });

    stores = await populateStores(stores);

    const usage = await Reservation.findAll({
      where: { service_id: { [Op.not]: null } },
      include: [{ model: Service, as: "service" }],
    });
    return res.status(200).json({
      stores: stores,
      usage: usage,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getReviewStatsData = async (req, res) => {
  try {
    const reviews = await Review.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reviewee" },
      ],
    });

    return res.status(200).json({
      reviews: reviews,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getFavoriteStatsData = async (req, res) => {
  try {
    const stores = await FavoriteStore.findAll({
      include: [{ model: User, as: "user" }],
    });
    const tasks = await FavoriteTask.findAll({
      include: [{ model: User, as: "user" }],
    });

    return res.status(200).json({
      stores: stores,
      tasks: tasks,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getFeedbackStatsData = async (req, res) => {
  try {
    const feedbacks = await Feedback.findAll({
      include: [{ model: User, as: "user" }],
    });

    return res.status(200).json({
      feedbacks: feedbacks,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getReportStatsData = async (req, res) => {
  try {
    const reports = await Report.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reportedUser" },
        { model: Task, as: "task" },
        { model: Service, as: "service" },
      ],
    });

    return res.status(200).json({
      reports: reports,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// discussionsList, activeCount
exports.getChatStatsData = async (req, res) => {
  try {
    const discussions = await Discussion.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "owner" },
      ],
    });

    const activeDiscussions = await Discussion.findAll();

    return res.status(200).json({
      discussions: discussions,
      activeCount: activeDiscussions.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// coinPacksList, activeCount
exports.getCoinPackStatsData = async (req, res) => {
  try {
    const coinPacks = await PurchasedCoins.findAll({
      include: [{ model: User, as: "user" }],
    });

    const activeDiscussions = await PurchasedCoins.findAll({
      where: {
        expiration_date: { [Op.lt]: Sequelize.literal("NOW()") },
        coins_used: { [Op.gt]: 0 },
      },
    });

    return res.status(200).json({
      coinPack: coinPacks,
      activeCount: activeDiscussions.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// subscriptionList, usageList
exports.getCategoriesStatsData = async (req, res) => {
  try {
    const subscription = await CategorySubscriptionModel.findAll({
      include: [{ model: User, as: "user" }],
    });

    const stats = await Task.findAll({
      attributes: [
        "category_id", // Include category_id to group results
        [Sequelize.fn("COUNT", Sequelize.col("task.id")), "total_tasks"], // Count tasks
      ],
      group: ["category_id"], // Group by category_id
      raw: true, // Return raw data instead of Sequelize instances
      include: [
        {
          model: Category, // Join with Category to include category details
          attributes: ["name"], // Include category name for better readability
        },
      ],
      order: [[Sequelize.literal("total_tasks"), "DESC"]], // Sort by total tasks in descending order
    });

    return res.status(200).json({
      subscription: subscription,
      usage: stats,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// taskList, activeCount, expiredCount
exports.getTaskStatsData = async (req, res) => {
  try {
    const tasks = await Task.findAll({
      include: [{ model: User, as: "user" }],
    });

    const activeTasks = await Reservation.findAll({
      where: { status: "confirmed" },
    });

    const expiredTasks = await Reservation.findAll({
      where: {
        status: { [Sequelize.Op.ne]: "confirmed" },
      },
      include: [
        {
          model: Task,
          required: false,
          where: {
            due_date: { [Sequelize.Op.lt]: Sequelize.literal("NOW()") },
          },
        },
      ],
    });

    return res.status(200).json({
      tasks: tasks,
      activeCount: activeTasks.length,
      expiredCount: expiredTasks.length,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateStatus = async (req, res) => {
  try {
    let id = req.body.id;
    let status = req.body.status;
    if (!id || !status) {
      return res.status(400).json({ message: "missing" });
    }
    let transaction = await BalanceTransaction.findByPk(id);
    if (!transaction) {
      return res.status(404).json({ message: "transaction_not_found" });
    }
    const transactionUser = await User.findByPk(transaction.userId);
    if (!transactionUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    if (status === "completed") {
      transactionUser.balance += transaction.amount;
      transactionUser.save();
      notificationService.sendNotification(
        transactionUser.id,
        "Balance Update",
        "Your deposit has been accepted.",
        NotificationType.BALANCE,
        {}
      );
    } else if (status === "failed") {
      notificationService.sendNotification(
        transactionUser.id,
        "Deposit Failed",
        "Your deposit has been failed.",
        NotificationType.BALANCE,
        {
          /* TODO add reasons */
        }
      );
    }

    transaction.status = status;
    transaction.save();

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
