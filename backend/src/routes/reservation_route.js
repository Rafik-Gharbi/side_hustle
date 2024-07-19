const {
  tokenVerification,
  clientIsVerified,
  roleAuth,
  roleMiddleware,
} = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const reservationController = require("../controllers/reservation_controller");

  var router = require("express").Router();

  // create reservation (property and user connected)
  router.post(
    "/add",
    tokenVerification,
    clientIsVerified,
    reservationController.add
  );
  // list own reservation via JWT
  router.get("/list", tokenVerification, reservationController.listReservation);
  router.get(
    "/list-all",
    tokenVerification,
    roleMiddleware(["admin"]),
    reservationController.getAllReservation
  );

  router.post(
    "/paiement",
    tokenVerification,
    clientIsVerified,
    reservationController.initPaiement
  );

  app.use("/reservation", router);
};
