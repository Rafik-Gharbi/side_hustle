const { tokenVerification } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const referralController = require("../controllers/referral_controller");

  var router = require("express").Router();

  router.get("/list", tokenVerification, referralController.listReferral);

  app.use("/referral", router);
};
