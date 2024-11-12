const { tokenVerification, roleMiddleware } = require("../middlewares/authentificationHelper");
const { depositImageUpload } = require("../middlewares/multer-deposit");

module.exports = (app) => {
  const balanceController = require("../controllers/balance_controller");

  var router = require("express").Router();

  router.post(
    "/request-withdrawal",
    tokenVerification,
    balanceController.requestWithdrawal
  );
  router.post(
    "/request-deposit",
    tokenVerification,
    depositImageUpload,
    balanceController.requestDeposit
  );
  router.get(
    "/transactions",
    tokenVerification,
    balanceController.getBalanceTransactions
  );
  router.put(
    "/status",
    // TODO
    // tokenVerification, 
    // roleMiddleware("admin"),
    balanceController.updateStatus
  );

  app.use("/balance", router);
};
