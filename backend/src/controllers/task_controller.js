const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Task } = require("../models/task_model");
const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const { getFavoriteByUserId } = require("../sql/sql_request");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const { getFileType } = require("../helper/helpers");

// get all tasks
exports.getAllTasks = async (req, res) => {
  try {
    const currentUserId = req.decoded.id;
    let userFavorites = [];
    if (currentUserId) {
      userFavorites = getFavoriteByUserId(currentUserId);
    }
    const query = `SELECT task.*, 
      user.id AS user_id,
      user.name,
      user.email,
      user.gender,
      user.birthdate,
      user.picture,
      user.governorate_id as user_governorate_id,
      user.phone_number,
      user.role FROM task JOIN user ON task.owner_id = user.id;`;
    const tasks = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
    });
    const formattedList = await Promise.all(
      tasks.map(async (row) => {
        let owner = {
          id: row.owner_id,
          name: row.name,
          email: row.email,
          picture: row.picture,
          phone: row.phone_number,
        };

        return {
          id: row.id,
          price: row.price,
          title: row.title,
          description: row.description,
          delivrables: row.delivrables,
          governorate_id: row.governorate_id,
          category_id: row.category_id,
          owner: owner,
          isFavorite:
            currentUserId && userFavorites.length > 0
              ? userFavorites.some((e) => e.task_id == row.id)
              : false,
        };
      })
    );
    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// get boosted tasks
exports.getHotTasks = async (req, res) => {
  try {
    const currentUserId = req.decoded?.id;
    let userFavorites = [];
    if (currentUserId) {
      userFavorites = await getFavoriteByUserId(currentUserId);
    }

    const query = `SELECT task.*, 
      user.id AS user_id,
      user.name,
      user.email,
      user.gender,
      user.birthdate,
      user.picture,
      user.governorate_id as user_governorate_id,
      user.phone_number,
      user.role
    FROM task JOIN user ON task.owner_id = user.id LIMIT 6
    ;`;
    const tasks = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
    });
    const formattedList = await Promise.all(
      tasks.map(async (row) => {
        let owner = {
          id: row.owner_id,
          name: row.name,
          email: row.email,
          picture: row.picture,
          phone: row.phone_number,
        };

        let taskAttachments = [];
        taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.id },
        });

        return {
          id: row.id,
          price: row.price,
          title: row.title,
          description: row.description,
          delivrables: row.delivrables,
          governorate_id: row.governorate_id,
          category_id: row.category_id,
          owner: owner,
          attachments: taskAttachments.length == 0 ? [] : taskAttachments,
          isFavorite:
            currentUserId && userFavorites.length > 0
              ? userFavorites.some((e) => e.task_id == row.id)
              : false,
        };
      })
    );
    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// filter tasks
exports.filterTasks = async (req, res) => {
  try {
    const searchQuery = req.query.searchQuery ?? "";
    let categoryId = req.query.categoryId;
    const priceMin = req.query.priceMin;
    const priceMax = req.query.priceMax;
    const nearby = req.query.nearby;
    const currentUserId = req.decoded?.id;
    let userFavorites = [];
    if (currentUserId) {
      userFavorites = await getFavoriteByUserId(currentUserId);
    }

    if (categoryId == -1) categoryId = undefined;

    const query = `SELECT task.*, 
      user.id AS user_id,
      user.name,
      user.email,
      user.gender,
      user.birthdate,
      user.picture,
      user.governorate_id as user_governorate_id,
      user.phone_number,
      user.role FROM task JOIN user ON task.owner_id = user.id WHERE (task.title LIKE :searchQuery OR task.description LIKE :searchQuery)
    ${categoryId ? `AND task.category_id = :categoryId` : ``}
    ${
      priceMin && priceMax
        ? `AND task.price >= :priceMin AND task.price <= :priceMax`
        : ``
    }
;`;
    const tasks = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        searchQuery: `%${searchQuery}%`,
        categoryId: categoryId,
        priceMin: priceMin,
        priceMax: priceMax,
      },
    });
    const formattedList = await Promise.all(
      tasks.map(async (row) => {
        let owner = {
          id: row.owner_id,
          name: row.name,
          email: row.email,
          picture: row.picture,
          phone: row.phone_number,
        };

        let taskAttachments = [];
        taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.id },
        });

        return {
          id: row.id,
          price: row.price,
          title: row.title,
          description: row.description,
          delivrables: row.delivrables,
          governorate_id: row.governorate_id,
          category_id: row.category_id,
          owner: owner,
          attachments: taskAttachments.length == 0 ? [] : taskAttachments,
          isFavorite:
            currentUserId && userFavorites.length > 0
              ? userFavorites.some((e) => e.task_id == row.id)
              : false,
        };
      })
    );
    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// add a new task
exports.addTask = async (req, res) => {
  const {
    title,
    description,
    price,
    category_id,
    governorate_id,
    delivrables,
    dueDate,
    owner_id,
  } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: owner_id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const category = await Category.findOne({ where: { id: category_id } });
    if (!category) {
      return res.status(404).json({ message: "category_not_found" });
    }
    const governorate = await Governorate.findOne({
      where: { id: governorate_id },
    });
    if (!governorate) {
      return res.status(404).json({ message: "governorate_not_found" });
    }

    let result = await Task.create({
      title,
      description,
      price,
      category_id,
      governorate_id,
      delivrables,
      due_date: dueDate,
      owner_id,
    });

    let attachments = [];
    const files = req.files?.photo ? req.files?.photo : req.files?.gallery;
    if (files) {
      attachments = await Promise.all(
        files.map(async (file) => {
          let savedFile = await TaskAttachmentModel.create({
            url: file.filename,
            type: getFileType(file),
            task_id: result.id,
          });

          return savedFile;
        })
      );
    }

    const task = {
      id: result.id,
      price: result.price,
      title: result.title,
      description: result.description,
      delivrables: result.delivrables,
      governorate_id: result.governorate_id,
      category_id: result.category_id,
      owner: user,
      attachments,
    };

    // Return token
    return res.status(200).json({ task });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};
