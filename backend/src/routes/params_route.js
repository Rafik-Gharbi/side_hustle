const { tokenVerification } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const paramsController = require("../controllers/params_controller");

  var router = require("express").Router();

  // check backend is reachable
  router.get("/check-connection", paramsController.checkConnection);

  // get app params governorates and categories
  router.get("/governorates", paramsController.getAllGovernorates);

  router.get("/categories", paramsController.getAllCategories);

  router.post("/report", tokenVerification, paramsController.reportUser);

  router.post("/feedback", tokenVerification, paramsController.feedback);

  app.use("/params", router);
};
