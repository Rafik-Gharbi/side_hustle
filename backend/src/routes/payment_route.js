const {
  tokenVerification,
  clientIsVerified,
  roleMiddleware,
  tokenVerificationOptional,
} = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const paymentController = require("../controllers/payment_controller");

  var router = require("express").Router();

  // get Flouci payment link
  router.post(
    "/flouci",
    tokenVerification,
    clientIsVerified,
    paymentController.initFlouciPayment
  );
  
  // verify and update payment status
  router.get(
    "/verify/:id",
    tokenVerification,
    paymentController.verifyFlouciPayment
  );
  
  // pay with balance
  router.post(
    "/balance",
    tokenVerification,
    clientIsVerified,
    paymentController.payWithBalance
  );
  
  app.use("/payment", router);
};
