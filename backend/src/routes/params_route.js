const { tokenVerification, tokenVerificationOptional } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const paramsController = require("../controllers/params_controller");

  var router = require("express").Router();

  // check backend is reachable
  router.get("/check-connection", paramsController.checkCurrentVersion);

  // get app params governorates and categories
  router.get("/governorates/:lang", paramsController.getAllGovernorates);

  router.get("/categories/:lang", paramsController.getAllCategories);

  router.get("/coin-packs/:lang", paramsController.getCoinPacks);

  router.get("/send-mail", paramsController.sendMail);

  router.post("/report", tokenVerificationOptional, paramsController.reportUser);

  router.post("/feedback", tokenVerificationOptional, paramsController.feedback);

  app.use("/params", router);
};
