const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");

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
    return res.status(200).json({ categories });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
