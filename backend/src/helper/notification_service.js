const { sendFirebaseNotification } = require("../../firebase-admin");
const { Notification } = require("../models/notification_model");
const { User } = require("../models/user_model");

const NotificationType = Object.freeze({
  VERIFICATION: "verification",
  CHAT: "chat",
  RESERVATION: "reservation",
  BOOKING: "booking",
  NEWTASK: "newTask",
  OTHERS: "others",
});

class NotificationService {
  constructor() {
    this.io = null;
  }

  init(io) {
    this.io = io;
  }

  async sendNotificationList(userIdList, title, body, type) {
    userIdList.forEach(async (element) => {
      await sendNotification(element, title, body, type);
    });
  }

  async sendNotification(userId, title, body, type) {
    try {
      // Save notification to database
      await Notification.create({ user_id: userId, title, body, type });

      // Fetch user to get FCM token
      const user = await User.findByPk(userId);

      if (user && user.fcmToken) {
        // Send notification via Firebase Admin
        sendFirebaseNotification([user.fcmToken], title, body);
      } else {
        // Send notification via WebSocket
        this.io.to(`${userId}`).emit("notification", { title, body, type });
      }
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  }

  async sendNotificationToAdmin(title, body, type) {
    try {
      let admins = await User.findAll({ where: { role: "admin" } });
      if (admins.length < 1) return;
      admins.forEach(async (admin) => {
        await sendNotification(admin.id, title, body, type);
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
