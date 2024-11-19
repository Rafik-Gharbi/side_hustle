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

  app.use("/admin", router);
};
