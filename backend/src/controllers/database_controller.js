const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const { LanguageType } = require("../models/type_language_model");
const { constantId } = require("../helper/constants");
const { User } = require("../models/user_model");
const { Task } = require("../models/task_model");
const { Store } = require("../models/store_model");
const { Service } = require("../models/service_model");
const { deleteDatabase } = require("../../db.config");
const Bcrypt = require("bcrypt");
const { removeSpacesFromPhoneNumber } = require("../helper/helpers");

// insert elements in the database
exports.insert = async (req, res) => {
  try {
    const users = constantId.Users;
    const languageType = constantId.LanguageType;
    const categories = constantId.categories;
    const governorates = constantId.governorates;
    const tasks = constantId.tasks;
    const stores = constantId.stores;
    const services = constantId.services;

    for (const user of users) {
      const hashedPassword = await Bcrypt.hash(user.password, 10);
      user.phone_number = removeSpacesFromPhoneNumber(user.phone_number);
      user.password = hashedPassword;
    }

    const createdLanguageType = await LanguageType.bulkCreate(languageType);
    const createdGovernorates = await Governorate.bulkCreate(governorates);
    const createdCategories = await Category.bulkCreate(categories);
    const createdUsers = await User.bulkCreate(users);
    const createdTasks = await Task.bulkCreate(tasks);
    const createdStores = await Store.bulkCreate(stores);
    const createdServices = await Service.bulkCreate(services);

    const result = {
      createdUsers,
      createdLanguageType,
      createdGovernorates,
      createdCategories,
      createdTasks,
      createdStores,
      createdServices,
    };

    return res.status(200).json(result);
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ error });
  }
};

// reset the database
exports.reset = async (req, res) => {
  try {
    await deleteDatabase();

    return res.json({ message: "Database reset successful" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ error: "Failed to reset database" });
  }
};
