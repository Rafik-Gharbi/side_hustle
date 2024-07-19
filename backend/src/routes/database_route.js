module.exports = (app) => {
  const databaseController = require("../controllers/database_controller");

  var router = require("express").Router();

  // insert elements in the database
  router.get("/insert", databaseController.insert);

  // reset the database
  router.get("/reset", databaseController.reset);

  app.use("/db", router);
};
