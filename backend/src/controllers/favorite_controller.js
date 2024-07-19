const { sequelize } = require("../../db.config");
const { getDate, getFeesAndDevise } = require("../helper/helpers");
const { User } = require("../models/user_model");
const { Favorite } = require("../models/favorite_model");
const { Task } = require("../models/task_model");

//toggle fav by providing id of task and jwt
exports.toggleFavorite = async (req, res) => {
  try {
    let idTask = req.body.idTask;
    if (!idTask) {
      return res.status(400).json({ message: "missing_id" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let taskFound = await Task.findByPk(idTask);
    if (!taskFound) {
      return res.status(404).json({ message: "task_not_found" });
    }

    let favoriteFound = await Favorite.findOne({
      where: {
        user_id: userFound.id,
        task_id: taskFound.id,
      },
    });

    if (!favoriteFound) {
      await Favorite.create({
        user_id: userFound.id,
        task_id: taskFound.id,
      });
      return res.status(200).json({ added: true });
    } else {
      await favoriteFound.destroy();
      return res.status(200).json({ added: false });
    }
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
exports.listFavorite = async (req, res) => {
  const { pageQuery, limitQuery } = req.query;
  const page = pageQuery ?? 1;
  const limit = limitQuery ? parseInt(limitQuery) : 9;
  const offset = (page - 1) * limit;
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const query = `
      SELECT
          task.*, 
          user.id AS user_id,
          user.name,
          user.email,
          user.gender,
          user.birthdate,
          user.picture,
          user.governorate_id as user_governorate_id,
          user.phone_number,
          user.role
      FROM 
          favorite
      JOIN 
          task ON task.id = favorite.task_id
      JOIN
          user ON favorite.user_id = user.id
      WHERE 
          favorite.user_id = :userId
      GROUP BY 
          task.id
      LIMIT :limit OFFSET :offset;

    `;

    const favoriteList = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: userFound.id,
        offset: offset,
        limit: limit,
      },
    });

    const formattedList = await Promise.all(
      favoriteList.map(async (row) => {
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
          isFavorite: true,
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
