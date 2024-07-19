module.exports = (app) => {
  const paramsController = require("../controllers/params_controller");

  var router = require("express").Router();

  // insert elements in the database
  router.get("/governorates", paramsController.getAllGovernorates);
  router.get("/categories", paramsController.getAllCategories);

  app.use("/params", router);
};
