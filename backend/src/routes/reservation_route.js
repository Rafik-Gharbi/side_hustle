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
    reservationController.addTaskReservation
  );

  // update reservation
  router.post(
    "/update-status",
    tokenVerification,
    reservationController.updateTaskReservationStatus
  );

  // list own reservation via JWT
  router.get(
    "/tasks-offers",
    tokenVerification,
    reservationController.userTaskOffersHistory
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
    reservationController.getServiceReservationDetails
  );

  // create booking
  router.post(
    "/add-service",
    tokenVerification,
    clientIsVerified,
    reservationController.addServiceReservation
  );

  // update booking
  router.post(
    "/update-service-status",
    tokenVerification,
    reservationController.updateServiceStatus
  );

  // list own booking via JWT
  router.get(
    "/services-requests",
    tokenVerification,
    reservationController.userRequestedServices
  );

  // list provided services via JWT
  router.get(
    "/service-offers",
    tokenVerification,
    reservationController.userServicesProvided
  );

  // list booking by service
  router.get(
    "/service-booking",
    tokenVerification,
    reservationController.getReservationByService
  );

  app.use("/reservation", router);
};
