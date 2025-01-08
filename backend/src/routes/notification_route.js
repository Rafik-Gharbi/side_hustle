const { tokenVerification } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const notificationController = require("../controllers/notification_controller");

  var router = require("express").Router();

  router.post("/mark-read", tokenVerification, notificationController.markAsReadNotification);
  router.post("/mark-read-all", tokenVerification, notificationController.markAsReadAllNotification);
  router.get("/list", tokenVerification, notificationController.getNotifications);
  router.get("/count", tokenVerification, notificationController.getNotSeenNotificationsCount);
  router.get("/test", tokenVerification, notificationController.testNotification);

  app.use("/notification", router);
};
