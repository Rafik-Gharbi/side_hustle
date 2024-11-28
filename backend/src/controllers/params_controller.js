const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const { User } = require("../models/user_model");
const { Report } = require("../models/report_model");
const { Feedback } = require("../models/feedback_model");
const { CoinPack } = require("../models/coin_pack_model");
const { contactUsMail } = require("../views/template_email");
const { sendMail } = require("../helper/email_service");

// check backend is reachable
exports.checkCurrentVersion = async (req, res) => {
  try {
    const version = process.env.APP_VERSION;
    return res.status(200).json({ result: true, version: version });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// get all regions
exports.getAllGovernorates = async (req, res) => {
  try {
    let governorates = await Governorate.findAll();
    return res.status(200).json({ governorates });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// get all categories
exports.getAllCategories = async (req, res) => {
  try {
    let categories = await Category.findAll();
    const populatedCategories = await Promise.all(
      categories.map(async (row) => {
        let subscribedUsers = await CategorySubscriptionModel.findAll({
          where: { category_id: row.id },
        });

        let subscribedCount = subscribedUsers.length;

        if (row.parentId === -1) {
          const childCategories = categories.filter(category => category.parentId === row.id);
          for (const child of childCategories) {
            let childSubscribedUsers = await CategorySubscriptionModel.findAll({
              where: { category_id: child.id },
            });
            subscribedCount += childSubscribedUsers.length;
          }
        }

        return {
          id: row.id,
          name: row.name,
          description: row.description,
          icon: row.icon,
          parentId: row.parentId,
          subscribed: subscribedCount,
        };
      })
    );
    return res.status(200).json({ categories: populatedCategories });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getCoinPacks = async (req, res) => {
  try {
    const coins = await CoinPack.findAll();
    return res.status(200).json({ coins });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.sendMail = async (req, res) => {
  try {
    const template = contactUsMail('email', 'name', 'subject', 'body', 'phone');
    sendMail(
      process.env.AUTH_USER_EMAIL,
      `Contact Us The Landlord - Testing`,
      template,
      req.host
    );
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.reportUser = async (req, res) => {
  try {
    const { user, reportedUser, task, service, reasons, explanation } = req.body;
    if ((!task && !service) || !reasons) {
      return res.status(400).json({ message: "missing" });
    }

    const existUser = await User.findOne({ where: { id: reportedUser.id } });
    if (!existUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await Report.create({
      reasons,
      explanation,
      task_id: task?.id,
      service_id: service?.id,
      user_id: req.decoded?.id ?? user?.id,
      reported_id: existUser.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.feedback = async (req, res) => {
  try {
    const { feedback, comment } = req.body;
    if (!feedback) {
      return res.status(400).json({ message: "missing" });
    }

    await Feedback.create({
      feedback,
      comment,
      user_id: req.decoded?.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
