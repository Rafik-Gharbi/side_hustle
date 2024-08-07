const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { Boost } = require("../models/boost_model");
const { Op } = require("sequelize");
const { Governorate } = require("../models/governorate_model");

exports.getBoostByTaskId = async (req, res) => {
  const ID = req.params.id;
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const existActiveBoost = await Boost.findOne({
      where: {
        task_service_id: ID,
        isTask: true,
        endDate: { [Op.gt]: new Date() }, // grater than today
      },
    });

    return res.status(200).json({ boost: existActiveBoost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getBoostByServiceId = async (req, res) => {
  const ID = req.params.id;
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const existActiveBoost = await Boost.findOne({
      where: {
        task_service_id: ID,
        isTask: false,
        endDate: { [Op.gt]: new Date() }, // grater than today
      },
    });

    return res.status(200).json({ boost: existActiveBoost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getUserBoosts = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let existActiveBoost = [];
    existActiveBoost = await Boost.findAll({
      where: { user_id: userFound.id },
    });

    return res.status(200).json({ boosts: existActiveBoost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.add = async (req, res) => {
  const {
    governorate_id,
    endDate,
    budget,
    gender,
    minAge,
    maxAge,
    taskServiceId,
    isTask,
  } = req.body;
  if (!endDate || !budget || !taskServiceId || isTask === undefined) {
    return res.status(400).json({ message: "missing" });
  }
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let foundTaskService;
    if (isTask) {
      foundTaskService = await Task.findByPk(taskServiceId);
    } else {
      foundTaskService = await Service.findByPk(taskServiceId);
    }
    if (!foundTaskService) {
      return res
        .status(404)
        .json({ message: isTask ? "task_not_found" : "service_not_found" });
    }
    if (governorate_id) {
      const governorate = await Governorate.findByPk(governorate_id);
      if (!governorate)
        return res.status(404).json({ message: "governorate_not_found" });
    }
    const existActiveBoost = await Boost.findOne({
      where: {
        task_service_id: foundTaskService.id,
        isTask: isTask,
        endDate: { [Op.gt]: new Date() }, // grater than today
      },
    });
    if (existActiveBoost) {
      return res.status(400).json({ message: "boost_already_exist" });
    }

    const boost = await Boost.create({
      budget: budget,
      gender: gender,
      endDate: endDate,
      minAge: minAge,
      maxAge: maxAge,
      task_service_id: foundTaskService.id,
      isTask: isTask,
      user_id: userFound.id,
      governorate_id: governorate_id,
    });

    return res.status(200).json({ boost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.update = async (req, res) => {
  const {
    id,
    governorate_id,
    endDate,
    budget,
    gender,
    minAge,
    maxAge,
    active,
  } = req.body;
  if (!id || !endDate || !budget) {
    return res.status(400).json({ message: "missing" });
  }
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (governorate_id) {
      const governorate = await Governorate.findByPk(governorate_id);
      if (!governorate)
        return res.status(404).json({ message: "governorate_not_found" });
    }
    const existActiveBoost = await Boost.findOne({
      where: { id: id },
    });
    if (existActiveBoost) {
      return res.status(400).json({ message: "boost_not_found" });
    }

    const boost = await Boost.update({
      budget: budget,
      gender: gender,
      endDate: endDate,
      minAge: minAge,
      maxAge: maxAge,
      governorate_id: governorate_id,
      active: active,
    });

    return res.status(200).json({ boost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};
