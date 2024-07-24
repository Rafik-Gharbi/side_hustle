module.exports = (app) => {
  const paramsController = require("../controllers/params_controller");

  var router = require("express").Router();

  // check backend is reachable
  router.get("/check-connection", paramsController.checkConnection);
  // get app params governorates and categories
  router.get("/governorates", paramsController.getAllGovernorates);
  router.get("/categories", paramsController.getAllCategories);

  app.use("/params", router);
};
