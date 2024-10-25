const { tokenVerification } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const transactionController = require("../controllers/transaction_controller");

  var router = require("express").Router();

  router.get("/list", tokenVerification, transactionController.listTransaction);

  router.post(
    "/buy-coins/:id",
    tokenVerification,
    transactionController.buyCoins
  );

  app.use("/transaction", router);
};
