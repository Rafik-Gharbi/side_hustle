const { sequelize } = require("../../db.config");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const { Notification } = require("../models/notification_model");
const { User } = require("../models/user_model");

exports.markAsReadNotification = async (req, res) => {
  try {
    let idNotification = req.body.idNotification;
    if (!idNotification) {
      return res.status(400).json({ message: "missing_id" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let notificationFound = await Notification.findByPk(idNotification);
    if (!notificationFound) {
      return res.status(404).json({ message: "notification_not_found" });
    }

    notificationFound.seen = true;
    await notificationFound.save();

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.markAsReadAllNotification = async (req, res) => {
  try {
    let notifications = req.body;
    if (!notifications && notifications.length < 1) {
      return res.status(400).json({ message: "missing_id" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    notifications.forEach(async (element) => {
      let notificationFound = await Notification.findByPk(element.id);
      if (!notificationFound) {
        return res.status(404).json({ message: "notification_not_found" });
      }

      notificationFound.seen = true;
      await notificationFound.save();
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getNotifications = async (req, res) => {
  const { pageQuery, limitQuery } = req.query;
  const page = pageQuery ?? 1;
  const limit = limitQuery ? parseInt(limitQuery) : 9;
  const offset = (page - 1) * limit;
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const queryTasks = `
      SELECT *
      FROM notification
      WHERE notification.user_id = :userId
      ORDER BY notification.createdAt DESC
      LIMIT :limit OFFSET :offset;
    `;

    const notificationList = await sequelize.query(queryTasks, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: userFound.id,
        offset: offset,
        limit: limit,
      },
    });

    return res.status(200).json({ notificationList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getNotSeenNotificationsCount = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const queryTasks = `
      SELECT Count(*) as count
      FROM notification
      WHERE notification.user_id = :userId AND seen = 0
    `;

    const notificationList = await sequelize.query(queryTasks, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: userFound.id,
      },
    });

    return res.status(200).json({ count: notificationList[0]["count"] });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.testNotification = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    await notificationService.sendNotification(
      userFound.id,
      "notifications.new_task",
      "notifications.new_task_in_category",
      NotificationType.NEWTASK,
      { taskId: 0 },
      (data = { categoryName: "Test" })
    );

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
