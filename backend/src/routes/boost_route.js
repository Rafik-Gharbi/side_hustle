const {
  tokenVerification,
  clientIsVerified,
  roleMiddleware,
} = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const boostController = require("../controllers/boost_controller");

  var router = require("express").Router();

  // create boost
  router.post(
    "/add",
    tokenVerification,
    clientIsVerified,
    boostController.add
  );

  // update boost
  router.put(
    "/update",
    tokenVerification,
    boostController.update
  );

  // list own boost via JWT
  router.get("/list", tokenVerification, boostController.getUserBoosts);

  // list boost by task
  router.get(
    "/task/:id",
    tokenVerification,
    boostController.getBoostByTaskId
  );

  // list boost by service
  router.get(
    "/service/:id",
    tokenVerification,
    boostController.getBoostByServiceId
  );

  app.use("/boost", router);
};
