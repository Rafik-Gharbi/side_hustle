const { sendFirebaseNotification } = require("../../firebase-admin");
const { Notification } = require("../models/notification_model");
const { User } = require("../models/user_model");

const NotificationType = Object.freeze({
  VERIFICATION: "verification",
  CHAT: "chat",
  RESERVATION: "reservation",
  BOOKING: "booking",
  NEWTASK: "newTask",
  REVIEW: "review",
  OTHERS: "others",
});

class NotificationService {
  constructor() {
    this.io = null;
  }

  init(io) {
    this.io = io;
  }

  async sendNotificationList(userIdList, title, body, type, action) {
    userIdList.forEach(async (element) => {
      await this.sendNotification(element, title, body, type, action);
    });
  }

  async sendNotification(userId, title, body, type, action) {
    try {
      let actionEncoded;
      if (action) actionEncoded = JSON.stringify(action);
      // Save notification to database
      await Notification.create({
        user_id: userId,
        title,
        body,
        type,
        action: actionEncoded,
      });

      // Fetch user to get FCM token
      const user = await User.findByPk(userId);

      if (user && user.fcmToken) {
        // Send notification via Firebase Admin
        sendFirebaseNotification([user.fcmToken], title, body, actionEncoded);
      } else {
        // Send notification via WebSocket
        this.io
          .to(`${userId}`)
          .emit("notification", { title, body, type, actionEncoded });
      }
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }

  async sendNotificationToAdmin(title, body, type, action) {
    try {
      let admins = await User.findAll({ where: { role: "admin" } });
      if (admins.length < 1) return;
      admins.forEach(async (admin) => {
        await this.sendNotification(admin.id, title, body, type, action);
      });
    } catch (error) {
      console.error("Error sending notification to admins:", error);
    }
  }
}

module.exports = {
  notificationService: new NotificationService(),
  NotificationType,
};
