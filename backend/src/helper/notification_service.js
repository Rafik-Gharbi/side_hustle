const { sendFirebaseNotification } = require("../../firebase-admin");
const { i18n } = require("../../i18n");
const { Notification } = require("../models/notification_model");
const { User } = require("../models/user_model");

const NotificationType = Object.freeze({
  VERIFICATION: "verification",
  REWARDS: "rewards",
  CHAT: "chat",
  RESERVATION: "reservation",
  BALANCE: "balance",
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

  async sendNotificationList(userIdList, title, body, type, action, data = {}) {
    userIdList.forEach(async (element) => {
      await this.sendNotification(element, title, body, type, action, data);
    });
  }

  async sendNotification(userId, titleKey, bodyKey, type, action, data = {}) {
    try {
      const user = await User.findByPk(userId);
      const title = i18n.__({ phrase: titleKey, locale: user.language }, data);
      const body = i18n.__({ phrase: bodyKey, locale: user.language }, data);
      let actionEncoded;
      if (action) actionEncoded = JSON.stringify(action);
      // Save notification to database
      const notification = await Notification.create({
        user_id: userId,
        title,
        body,
        type,
        action: actionEncoded,
      });

      if (user && user.fcmToken) {
        // Send notification via Firebase Admin
        sendFirebaseNotification([user.fcmToken], title, body, actionEncoded);
      } else {
        // Send notification via WebSocket
        this.io.to(`${userId}`).emit("notification", { notification });
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
