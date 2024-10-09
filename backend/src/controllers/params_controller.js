const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");

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
