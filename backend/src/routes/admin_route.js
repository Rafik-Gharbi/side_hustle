module.exports = (app) => {
  const adminController = require("../controllers/admin_controller");
  const {
    tokenVerification,
    roleMiddleware,
  } = require("../middlewares/authentificationHelper");
  var router = require("express").Router();

  // get admins for approve
  router.get(
    "/approve",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.usersForApproving
  );
  
  // approve a admin
  router.put(
    "/approve",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.approveUser
  );
  
  // send notification for not approvable admin
  router.put(
    "/not-approvable",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.userNotApprovable
  );
  
  router.get(
    "/balance-transactions",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getBalanceTransactions
  );
  
  router.get(
    "/reports",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getAllReports
  );
  
  router.get(
    "/feedbacks",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getUsersFeedbacks
  );
  
  router.get(
    "/data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getAdminData
  );
  
  router.put(
    "/balance-status",
    tokenVerification, 
    roleMiddleware("admin"),
    adminController.updateStatus
  );

  router.get(
    "/user-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getUserStatsData
  );
  
  router.get(
    "/balance-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getBalanceStatsData
  );
  
  router.get(
    "/contract-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getContractStatsData
  );
  
  router.get(
    "/task-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getTaskStatsData
  );
  
  router.get(
    "/chat-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getChatStatsData
  );
  
  router.get(
    "/coin-pack-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getCoinPackStatsData
  );
  
  router.get(
    "/store-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getStoreStatsData
  );
  
  router.get(
    "/review-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getReviewStatsData
  );
  
  router.get(
    "/governorate-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getGovernorateStatsData
  );
  
  
  router.get(
    "/referral-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getReferralStatsData
  );
  
  router.get(
    "/favorite-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getFavoriteStatsData
  );
  
  router.get(
    "/feedback-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getFeedbackStatsData
  );

  router.get(
    "/report-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getReportStatsData
  );

  router.get(
    "/categories-stats-data",
    tokenVerification,
    roleMiddleware("admin"),
    adminController.getCategoriesStatsData
  );

  app.use("/admin", router);
};
