const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const { User } = require("../models/user_model");
const { Report } = require("../models/report_model");
const { Feedback } = require("../models/feedback_model");

// check backend is reachable
exports.checkConnection = async (req, res) => {
  try {
    return res.status(200).json({ result: true });
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

        return {
          id: row.id,
          name: row.name,
          icon: row.icon,
          parentId: row.parentId,
          subscribed: subscribedUsers.length,
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

exports.reportUser = async (req, res) => {
  try {
    const { user, task, service, reasons, explanation } = req.body;
    if ((!task && !service) || !reasons) {
      return res.status(400).json({ message: "missing" });
    }
    const reporterUser = await User.findByPk(req.decoded.id);
    if (!reporterUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const existUser = await User.findOne({ where: { id: user.id } });
    if (!existUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await Report.create({
      reasons,
      explanation,
      task_id: task?.id,
      service_id: service?.id,
      user_id: existUser.id,
      reported_id: reporterUser.id,
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
    const feedbackUser = await User.findByPk(req.decoded.id);
    if (!feedbackUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await Feedback.create({
      feedback,
      comment,
      user_id: feedbackUser.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
