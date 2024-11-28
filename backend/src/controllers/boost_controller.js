const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { Boost } = require("../models/boost_model");
const { Op } = require("sequelize");
const { Governorate } = require("../models/governorate_model");
const { populateOneTask, populateOneService } = require("../sql/sql_request");
const { BalanceTransaction } = require("../models/balance_transaction_model");

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
    const page = req.query.pageQuery;
    const limitQuery = req.query.limitQuery;
    const pageQuery = !page || page === "0" ? 1 : page;
    const limit = limitQuery ? parseInt(limitQuery) : 9;
    const offset = (pageQuery - 1) * limit;

    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let existActiveBoost = [];
    existActiveBoost = await Boost.findAll({
      where: { user_id: userFound.id },
      limit: limit,
      offset: offset,
    });

    let activeBoost = [];
    activeBoost = await Promise.all(
      existActiveBoost.map(async (boost) => {
        let task;
        let service;
        if (boost.isTask) {
          task = await Task.findOne({
            where: { id: boost.task_service_id },
          });
          task = await populateOneTask(task, userFound.id);
        } else {
          service = await Service.findOne({
            where: { id: boost.task_service_id },
          });
          service = await populateOneService(service);
        }
        if (boost.isTask) return { boost, task };
        else return { boost, service };
      })
    );

    return res.status(200).json({ boosts: activeBoost });
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
    // TODO this is only working from balance for now, add bank card payment later
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
    if (budget > userFound.balance) {
      return res.status(400).json({ message: "not_enough_balance" });
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

    BalanceTransaction.create({
      userId: userFound.id,
      amount: budget,
      type: "boostPurchase",
      status: "completed",
      description: `Boost of ${isTask ? "task" : "service"} ${foundTaskService.id}`,
    });

    userFound.balance -= coinPack.price;
    userFound.save();
    const token = await generateJWT(userFound);

    return res.status(200).json({ boost, token });
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
    isActive,
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
    if (!existActiveBoost) {
      return res.status(400).json({ message: "boost_not_found" });
    }

    const boost = await existActiveBoost.update({
      id: id,
      budget: budget,
      gender: gender,
      endDate: endDate,
      minAge: minAge,
      maxAge: maxAge,
      governorate_id: governorate_id,
      isActive: isActive,
    });

    return res.status(200).json({ boost });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};
