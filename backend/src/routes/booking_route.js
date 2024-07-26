const {
  tokenVerification,
  clientIsVerified,
  roleMiddleware,
} = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const bookingController = require("../controllers/booking_controller");

  var router = require("express").Router();

  // create booking
  router.post(
    "/add",
    tokenVerification,
    clientIsVerified,
    bookingController.add
  );

  // update booking
  router.post(
    "/update-status",
    tokenVerification,
    bookingController.updateStatus
  );

  // list own booking via JWT
  router.get("/list", tokenVerification, bookingController.listBooking);

  // list own booking via JWT
  router.get(
    "/services-history",
    tokenVerification,
    bookingController.userServicesHistory
  );

  // list booking by service
  router.get(
    "/service-booking",
    tokenVerification,
    bookingController.getBookingByService
  );

  // get services condidates number
  router.get("/condidates", bookingController.getCondidatesNumber);

  // list all booking for admin
  router.get(
    "/list-all",
    tokenVerification,
    roleMiddleware(["admin"]),
    bookingController.getAllBooking
  );

  router.post(
    "/paiement",
    tokenVerification,
    clientIsVerified,
    bookingController.initPaiement
  );

  app.use("/booking", router);
};
