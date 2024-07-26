const { sequelize } = require("../../db.config");
const {
  getDate,
  getFeesAndDevise,
  getServiceCondidatesNumber,
  checkStoreFavorite,
} = require("../helper/helpers");
const { User } = require("../models/user_model");
const { FavoriteTask } = require("../models/favorite_task_model");
const { FavoriteStore } = require("../models/favorite_store_model");
const { Task } = require("../models/task_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");
const { Service } = require("../models/service_model");
const { Store } = require("../models/store_model");

//toggle fav by providing id of task and jwt
exports.toggleTaskFavorite = async (req, res) => {
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

    let favoriteFound = await FavoriteTask.findOne({
      where: {
        user_id: userFound.id,
        task_id: taskFound.id,
      },
    });

    if (!favoriteFound) {
      await FavoriteTask.create({
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

//toggle fav by providing id of store and jwt
exports.toggleStoreFavorite = async (req, res) => {
  try {
    let idStore = req.body.idStore;
    if (!idStore) {
      return res.status(400).json({ message: "missing_id" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let storeFound = await Store.findByPk(idStore);
    if (!storeFound) {
      return res.status(404).json({ message: "store_not_found" });
    }

    let favoriteFound = await FavoriteStore.findOne({
      where: {
        user_id: userFound.id,
        store_id: storeFound.id,
      },
    });

    if (!favoriteFound) {
      await FavoriteStore.create({
        user_id: userFound.id,
        store_id: storeFound.id,
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

    const queryTasks = `
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
          favorite_task
      JOIN 
          task ON task.id = favorite_task.task_id
      JOIN
          user ON favorite_task.user_id = user.id
      WHERE 
          favorite_task.user_id = :userId
      GROUP BY 
          task.id
      LIMIT :limit OFFSET :offset;

    `;

    const favoriteTaskList = await sequelize.query(queryTasks, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: userFound.id,
        offset: offset,
        limit: limit,
      },
    });

    const queryStores = `
      SELECT
          store.*, 
          user.id AS user_id,
          user.name AS user_name,
          user.email,
          user.gender,
          user.birthdate,
          user.picture AS user_picture,
          user.governorate_id as user_governorate_id,
          user.phone_number,
          user.role
      FROM 
          favorite_store
      JOIN 
          store ON store.id = favorite_store.store_id
      JOIN
          user ON favorite_store.user_id = user.id
      WHERE 
          favorite_store.user_id = :userId
      GROUP BY 
          store.id
      LIMIT :limit OFFSET :offset;

    `;

    const favoriteStoreList = await sequelize.query(queryStores, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: userFound.id,
        offset: offset,
        limit: limit,
      },
    });

    const savedTasks = await Promise.all(
      favoriteTaskList.map(async (row) => {
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

    const savedStores = await Promise.all(
      favoriteStoreList.map(async (row) => {
        let storeOwner = await User.findByPk(row.owner_id);
        const foundServices = await Service.findAll({
          where: { store_id: row.id },
        });
        const services = await Promise.all(
          foundServices.map(async (service) => {
            let gallery = [];
            gallery = await ServiceGalleryModel.findAll({
              where: { service_id: service.id },
            });

            const requests = await getServiceCondidatesNumber(service.id);
            return {
              id: service.id,
              price: service.price,
              name: service.name,
              description: service.description,
              category_id: service.category_id,
              gallery,
              requests,
            };
          })
        );
        const isFavorite = await checkStoreFavorite(row, userFound.id);

        return {
          id: row.id,
          name: row.name,
          description: row.description,
          coordinates: row.coordinates,
          picture: row.picture,
          governorate_id: row.governorate_id,
          services,
          owner: storeOwner,
          isFavorite,
        };
      })
    );

    return res.status(200).json({ savedTasks, savedStores });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
