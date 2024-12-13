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
  populateStores,
  populateOneTask,
  populateOneService,
  getUserSupportRequiredActionsCount,
  populateSupportTickets,
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
const { getDate } = require("../helper/helpers");
const { SupportTicket } = require("../models/support_ticket");

async function getAdminRequiredActionsCount() {
  try {
    let requiredActionsCount = 0;
    const approveCount = await usersForApproving();
    requiredActionsCount += approveCount.length;
    const balanceTransactions = await getBalanceTransactions();
    requiredActionsCount += balanceTransactions.length;
    const userReports = await getAllReports();
    requiredActionsCount += userReports.length;
    const userFeedbacks = await getUsersFeedbacks();
    requiredActionsCount += userFeedbacks.length;
    const userSupport = await getUsersSupport();
    requiredActionsCount += userSupport.length;

    return requiredActionsCount;
  } catch (error) {
    console.log(`Error at getAdminRequiredActionsCount`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function usersForApproving() {
  try {
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

    return users;
  } catch (error) {
    console.log(`Error at usersForApproving`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function approveUser(userId) {
  try {
    const userForApproveId = userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return "user_not_found";
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

    return true;
  } catch (error) {
    console.log(`Error at approveUser`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function userNotApprovable(userId) {
  try {
    const userForApproveId = userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return "user_not_found";
    }
    const userDocument = await UserDocumentModel.findOne({
      where: { user_id: userForApproveId },
    });
    if (!userDocument) {
      return "user_document_not_found";
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
    return true;
  } catch (error) {
    console.log(`Error at userNotApprovable`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getBalanceTransactions() {
  try {
    const pendingTransactions = await BalanceTransaction.findAll({
      where: { status: "pending" },
      include: [{ model: User, as: "user" }],
    });
    return pendingTransactions;
  } catch (error) {
    console.log(`Error at getBalanceTransactions`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getAllReports() {
  try {
    // TODO group reports by user
    const allReports = await Report.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reportedUser" },
        { model: Task, as: "task", include: [{ model: User, as: "user" }] },
        { model: Service, as: "service" },
      ],
    });

    for (let index = 0; index < allReports.length; index++) {
      const element = allReports[index];
      if (element.task) element.task = await populateOneTask(element.task);
      if (element.service)
        element.service = await populateOneService(element.service);
    }
    return allReports;
  } catch (error) {
    console.log(`Error at getAllReports`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getUsersFeedbacks() {
  try {
    // TODO group feedback by user
    const allFeedbacks = await Feedback.findAll({
      include: [{ model: User, as: "user" }],
    });
    return allFeedbacks;
  } catch (error) {
    console.log(`Error at getUsersFeedbacks`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getUsersSupport() {
  try {
    // TODO group feedback by user
    let tickets = await SupportTicket.findAll({
      where: { status: { [Op.not]: "closed" } },
      include: [
        { model: User, as: "user" },
        { model: User, as: "assigned" },
      ],
    });
    tickets = await populateSupportTickets(tickets);

    return tickets;
  } catch (error) {
    console.log(`Error at getUsersSupport`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getAdminData() {
  try {
    const approveUsersActionRequired =
      await getApproveUsersRequiredActionsCount();
    const balanceTransactionsActionRequired =
      await getBalanceTransactionsRequiredActionsCount();
    const userReportsActionRequired =
      await getUserReportsRequiredActionsCount();
    const userFeedbacksActionRequired =
      await getUserFeedbacksRequiredActionsCount();
    const userSupportActionRequired =
      await getUserSupportRequiredActionsCount();
    // User stats
    const userStat = await getUserStatsData();
    const totalUsers = userStat.users.length;
    const activeUsers = userStat.activeCount;
    const verifiedUsers = userStat.users.filter((user) => {
      return user.isVerified === "verified";
    }).length;
    // Balance stats
    const balanceStat = await getBalanceStatsData();
    const totalDeposits = balanceStat.depositList.length;
    const totalWithdrawals = balanceStat.withdrawalList.length;
    const maxUserBalance = balanceStat.maxBalance;
    const userHasBalance = balanceStat.totalUsers;
    // Contract stats
    const contractList = await getContractStatsData();
    const totalContract = contractList.length;
    const totalPayedContract = contractList.filter((contract) => {
      return contract.isPayed === true;
    }).length;
    const activeContract = contractList.filter((contract) => {
      return contract.dueDate > getDate();
    }).length;
    // Task stats
    const taskStats = await getTaskStatsData();
    const totalTasks = taskStats.tasks.length;
    const activeTasks = taskStats.activeCount;
    const expiredTasks = taskStats.expiredCount;
    // Store stats
    const storeStats = await getStoreStatsData();
    const totalStores = storeStats.stores.length;
    const totalServices =
      storeStats.stores
        ?.map((store) => store.services?.length || 0)
        .reduce((total, count) => total + count, 0) || 0;
    // Feedback stats
    const feedbackList = await getFeedbackStatsData();
    const totalFeedbacks = feedbackList.length;
    // Report stats
    const reportList = await getReportStatsData();
    const totalReports = reportList.length;
    // Categories stats
    const categoryStats = await getCategoriesStatsData();
    const totalSubscription = categoryStats.subscription.length;
    const totalCategories = categoryStats.categories.filter((category) => {
      return category.parentId === -1;
    }).length;
    const totalSubCategories = categoryStats.categories.filter((category) => {
      return category.parentId !== -1;
    }).length;
    // Chat stats
    const chatStats = await getChatStatsData();
    const totalDiscussions = chatStats.discussions.length;
    const activeDiscussions = chatStats.activeCount;
    // CoinPack stats
    const coinPackStats = await getCoinPackStatsData();
    const totalCoinPacksSold = coinPackStats.coinPack.length;
    const totalActiveCoinPacks = coinPackStats.activeCount;
    // Favorite stats
    const favoriteStats = await getFavoriteStatsData();
    const totalStoresFavorite = favoriteStats.stores.length;
    const totalTasksFavorite = favoriteStats.tasks.length;
    // Referral stats
    const referralStats = await getReferralStatsData();
    const totalReferrals = referralStats.referrals.length;
    const totalSuccessReferrals = referralStats.successCount;
    // Review stats
    const reviewList = await getReviewStatsData();
    const totalReviews = reviewList.length;

    return {
      approveCount: approveUsersActionRequired,
      balanceCount: balanceTransactionsActionRequired,
      reportsCount: userReportsActionRequired,
      feedbackCount: userFeedbacksActionRequired,
      supportCount: userSupportActionRequired,
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      verifiedUsers: verifiedUsers,
      totalDeposits: totalDeposits,
      totalWithdrawals: totalWithdrawals,
      maxUserBalance: maxUserBalance,
      userHasBalance: userHasBalance,
      totalContract: totalContract,
      totalPayedContract: totalPayedContract,
      activeContract: activeContract,
      activeTasks: activeTasks,
      expiredTasks: expiredTasks,
      totalStores: totalStores,
      totalServices: totalServices,
      totalFeedbacks: totalFeedbacks,
      totalReports: totalReports,
      totalSubscription: totalSubscription,
      totalCategories: totalCategories,
      totalSubCategories: totalSubCategories,
      totalDiscussions: totalDiscussions,
      activeDiscussions: activeDiscussions,
      totalCoinPacksSold: totalCoinPacksSold,
      totalActiveCoinPacks: totalActiveCoinPacks,
      totalStoresFavorite: totalStoresFavorite,
      totalTasksFavorite: totalTasksFavorite,
      totalTasks: totalTasks,
      totalReferrals: totalReferrals,
      totalSuccessReferrals: totalSuccessReferrals,
      totalReviews: totalReviews,
    };
  } catch (error) {
    console.log(`Error at getAdminData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

/// userList, activeCount
async function getUserStatsData() {
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

    return {
      users: users,
      activeCount: activeUserIds.length,
    };
  } catch (error) {
    console.log(`Error at getUserStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

/// depositList, withdrawalList, maxBalance, totalUsers
async function getBalanceStatsData() {
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

    return {
      depositList: deposits,
      withdrawalList: withdrawals,
      maxBalance: maxBalance,
      totalUsers: usersHasBalance.length,
    };
  } catch (error) {
    console.log(`Error at getBalanceStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

/// storeList, userList, taskList, contractList
async function getGovernorateStatsData() {
  try {
    let stores = await Store.findAll();
    stores = await populateStores(stores);
    const users = await User.findAll();
    const tasks = await Task.findAll({
      include: [{ model: User, as: "user" }],
    });
    const contracts = await Contract.findAll();

    return {
      tasks: tasks,
      users: users,
      contracts: contracts,
      stores: stores,
    };
  } catch (error) {
    console.log(`Error at getGovernorateStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

/// referralsList, referralSuccessCount
async function getReferralStatsData() {
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

    return {
      referrals: referrals,
      successCount: successful.length,
    };
  } catch (error) {
    console.log(`Error at getReferralStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getContractStatsData() {
  try {
    const contracts = await Contract.findAll({
      include: [
        { model: Task, as: "task" },
        { model: Service, as: "service" },
      ],
    });

    return contracts;
  } catch (error) {
    console.log(`Error at getContractStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

// stores, ServiceUsage
async function getStoreStatsData() {
  try {
    let stores = await Store.findAll({
      include: [{ model: User, as: "user" }],
    });

    stores = await populateStores(stores);

    const usage = await Reservation.findAll({
      where: { service_id: { [Op.not]: null } },
      include: [{ model: Service, as: "service" }],
    });
    return {
      stores: stores,
      usage: usage,
    };
  } catch (error) {
    console.log(`Error at getStoreStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getReviewStatsData() {
  try {
    const reviews = await Review.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reviewee" },
      ],
    });

    return reviews;
  } catch (error) {
    console.log(`Error at getReviewStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getFavoriteStatsData() {
  try {
    const stores = await FavoriteStore.findAll({
      include: [{ model: User, as: "user" }],
    });
    const tasks = await FavoriteTask.findAll({
      include: [{ model: User, as: "user" }],
    });

    return {
      stores: stores,
      tasks: tasks,
    };
  } catch (error) {
    console.log(`Error at getFavoriteStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getFeedbackStatsData() {
  try {
    const feedbacks = await Feedback.findAll({
      include: [{ model: User, as: "user" }],
    });

    return feedbacks;
  } catch (error) {
    console.log(`Error at getFeedbackStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function getReportStatsData() {
  try {
    const reports = await Report.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "reportedUser" },
        { model: Task, as: "task", include: [{ model: User, as: "user" }] },
        { model: Service, as: "service" },
      ],
    });

    return reports;
  } catch (error) {
    console.log(`Error at getReportStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

// discussionsList, activeCount
async function getChatStatsData() {
  try {
    const discussions = await Discussion.findAll({
      include: [
        { model: User, as: "user" },
        { model: User, as: "owner" },
      ],
    });

    const activeDiscussions = await Discussion.findAll();

    return {
      discussions: discussions,
      activeCount: activeDiscussions.length,
    };
  } catch (error) {
    console.log(`Error at getChatStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

// coinPacksList, activeCount
async function getCoinPackStatsData() {
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

    return {
      coinPack: coinPacks,
      activeCount: activeDiscussions.length,
    };
  } catch (error) {
    console.log(`Error at getCoinPackStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

// subscriptionList, usageList
async function getCategoriesStatsData() {
  try {
    const subscription = await CategorySubscriptionModel.findAll({
      attributes: [
        "category_id", // Include category_id to group results
        [Sequelize.fn("COUNT", Sequelize.col("category_id")), "total_use"], // Count tasks
      ],
      group: ["category_id"], // Group by category_id
      raw: true, // Return raw data instead of Sequelize instances
      include: [
        {
          model: Category, // Join with Category to include category details
          attributes: ["name"], // Include category name for better readability
        },
      ],
      order: [[Sequelize.literal("total_use"), "DESC"]], // Sort by total tasks in descending order
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

    const categories = await Category.findAll();

    return {
      subscription: subscription,
      usage: stats,
      categories: categories,
    };
  } catch (error) {
    console.log(`Error at getCategoriesStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

// taskList, activeCount, expiredCount
async function getTaskStatsData() {
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

    return {
      tasks: tasks,
      activeCount: activeTasks.length,
      expiredCount: expiredTasks.length,
    };
  } catch (error) {
    console.log(`Error at getTaskStatsData`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

async function updateStatus(id, status) {
  try {
    if (!id || !status) {
      return "missing";
    }
    let transaction = await BalanceTransaction.findByPk(id);
    if (!transaction) {
      return "transaction_not_found";
    }
    const transactionUser = await User.findByPk(transaction.userId);
    if (!transactionUser) {
      return "user_not_found";
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

    return true;
  } catch (error) {
    console.log(`Error at updateStatus`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return;
  }
}

module.exports = {
  usersForApproving,
  approveUser,
  userNotApprovable,
  getBalanceTransactions,
  getAllReports,
  getUsersFeedbacks,
  getUsersSupport,
  getAdminData,
  getUserStatsData,
  getBalanceStatsData,
  getGovernorateStatsData,
  getReferralStatsData,
  getContractStatsData,
  getStoreStatsData,
  getReviewStatsData,
  getFavoriteStatsData,
  getFeedbackStatsData,
  getReportStatsData,
  getChatStatsData,
  getCoinPackStatsData,
  getCategoriesStatsData,
  getTaskStatsData,
  updateStatus,
  getAdminRequiredActionsCount,
};
