const {
  tokenVerification,
  clientIsVerified,
  roleMiddleware,
  tokenVerificationOptional,
} = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const reservationController = require("../controllers/reservation_controller");

  var router = require("express").Router();

  // create reservation
  router.post(
    "/add",
    tokenVerification,
    clientIsVerified,
    reservationController.add
  );

  // update reservation
  router.post(
    "/update-status",
    tokenVerification,
    reservationController.updateStatus
  );

  // list own reservation via JWT
  router.get("/list", tokenVerification, reservationController.listReservation);

  // list own reservation via JWT
  router.get(
    "/reservations-history",
    tokenVerification,
    reservationController.userReservationsHistory
  );

  // list reservation by task
  router.get(
    "/task-reservation",
    tokenVerification,
    reservationController.getReservationByTask
  );

  // get tasks condidates number
  router.get(
    "/details",
    tokenVerificationOptional,
    reservationController.getReservationDetails
  );

  // // list all reservation for admin
  // router.get(
  //   "/list-all",
  //   tokenVerification,
  //   roleMiddleware(["admin"]),
  //   reservationController.getAllReservation
  // );

  router.post(
    "/paiement",
    tokenVerification,
    clientIsVerified,
    reservationController.initPaiement
  );

  app.use("/reservation", router);
};
