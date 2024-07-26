const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Store } = require("../models/store_model");
const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  getFileType,
  getServiceCondidatesNumber,
  checkStoreFavorite,
} = require("../helper/helpers");
const { Service } = require("../models/service_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");

// filter stores
exports.filterStores = async (req, res) => {
  try {
    const searchQuery = req.query.searchQuery ?? "";
    let categoryId = req.query.categoryId;
    const priceMin = req.query.priceMin;
    const priceMax = req.query.priceMax;
    const nearby = req.query.nearby;
    const page = req.query.page;
    const limit = req.query.limit;
    const currentUserId = req.decoded?.id;

    const pageQuery = page ?? 1;
    const limitQuery = limit ? parseInt(limit) : 9;
    const offset = (pageQuery - 1) * limit;

    // TODO add store favorite feature
    // let userFavorites = [];
    // if (currentUserId) {
    //   userFavorites = await getFavoriteByUserId(currentUserId);
    // }

    if (categoryId == -1) categoryId = undefined;

    const query = `SELECT store.*, 
      user.id AS user_id,
      user.name AS user_name,
      user.email,
      user.gender,
      user.birthdate,
      user.picture,
      user.governorate_id as user_governorate_id,
      user.phone_number,
      user.role
      FROM store 
      JOIN user ON store.owner_id = user.id 
      JOIN service ON service.store_id = store.id 
      WHERE (store.name LIKE :searchQuery OR store.description LIKE :searchQuery)
      ${categoryId ? `AND service.category_id = :categoryId` : ``}
      ${
        priceMin && priceMax
          ? `AND service.price >= :priceMin AND service.price <= :priceMax`
          : ``
      }
      GROUP BY store.id
      LIMIT :limit OFFSET :offset
;`;
    const stores = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        searchQuery: `%${searchQuery}%`,
        categoryId: categoryId,
        priceMin: priceMin,
        priceMax: priceMax,
        limit: limitQuery,
        offset: offset,
      },
    });
    const formattedList = await Promise.all(
      stores.map(async (row) => {
        let owner = {
          id: row.owner_id,
          name: row.user_name,
          email: row.email,
          picture: row.picture,
          phone: row.phone_number,
        };

        const foundServices = await Service.findAll({
          where: { store_id: row.id },
        });
        const services = await Promise.all(
          foundServices.map(async (service) => {
            let gallery = [];
            gallery = await ServiceGalleryModel.findAll({
              where: { service_id: service.id },
            });

            const requests =
              currentUserId == row.owner_id
                ? await getServiceCondidatesNumber(service.id)
                : -1;

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
        const isFavorite = await checkStoreFavorite(row, currentUserId);

        return {
          id: row.id,
          price: row.price,
          name: row.name,
          description: row.description,
          coordinates: row.coordinates,
          picture: row.picture,
          governorate_id: row.governorate_id,
          owner: owner,
          services,
          isFavorite,
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

// add a new store
exports.addStore = async (req, res) => {
  const { name, description, governorate_id, coordinates } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const governorate = await Governorate.findOne({
      where: { id: governorate_id },
    });
    if (!governorate) {
      return res.status(404).json({ message: "governorate_not_found" });
    }
    const existStore = await Store.findOne({
      where: { owner_id: user.id },
    });
    if (existStore) {
      return res.status(400).json({ message: "user_already_has_store" });
    }

    let store = await Store.create({
      name,
      description,
      governorate_id,
      owner_id: user.id,
      coordinates,
      picture: req.files?.photo?.filename,
    });

    return res.status(200).json({ store: store });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// add a new store service
exports.addService = async (req, res) => {
  const { name, description, price, category_id } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const category = await Category.findOne({
      where: { id: category_id },
    });
    if (!category) {
      return res.status(404).json({ message: "category_not_found" });
    }
    const existStore = await Store.findOne({
      where: { owner_id: user.id },
    });
    if (!existStore) {
      return res.status(404).json({ message: "store_not_found" });
    }
    const foundServices = await Service.findAll({
      where: { store_id: existStore.id },
    });
    // TODO work on the user limit regarding his subscription
    if (foundServices.length > 2) {
      return res.status(400).json({ message: "service_limit_reached" });
    }

    let service = await Service.create({
      name,
      description,
      category_id,
      price,
      store_id: existStore.id,
    });

    let gallery = [];
    const files = req.files?.photo ? req.files?.photo : req.files?.gallery;
    if (files) {
      gallery = await Promise.all(
        files.map(async (file) => {
          let savedFile = await ServiceGalleryModel.create({
            url: file.filename,
            type: getFileType(file),
            service_id: service.id,
          });

          return savedFile;
        })
      );
    }

    return res.status(200).json({
      service: {
        id: service.id,
        name: service.name,
        description: service.description,
        category_id: service.category_id,
        price: service.price,
        gallery: gallery,
      },
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// update a store service
exports.updateService = async (req, res) => {
  const { id, name, description, price, category_id } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const category = await Category.findOne({
      where: { id: category_id },
    });
    if (!category) {
      return res.status(404).json({ message: "category_not_found" });
    }
    const existStore = await Store.findOne({
      where: { owner_id: user.id },
    });
    if (!existStore) {
      return res.status(404).json({ message: "store_not_found" });
    }
    const foundService = await Service.findOne({
      where: { id: id },
    });
    if (!foundService) {
      return res.status(404).json({ message: "service_not_found" });
    }

    foundService.name = name;
    foundService.description = description;
    foundService.price = price;
    foundService.category_id = category_id;
    await foundService.save();

    let gallery = [];
    const files = req.files?.photo ? req.files?.photo : req.files?.gallery;
    if (files) {
      gallery = await Promise.all(
        files.map(async (file) => {
          const existGallery = await ServiceGalleryModel.findAll({
            where: { service_id: id },
          });
          let savedFile;
          if (existGallery.some((e) => e.url == file.url)) {
            savedFile = existGallery.findOne({ where: { url: file.url } });
          } else {
            savedFile = await ServiceGalleryModel.create({
              url: file.filename,
              type: getFileType(file),
              service_id: id,
            });
          }

          return savedFile;
        })
      );
    }

    return res.status(200).json({
      service: {
        id: id,
        name: name,
        description: description,
        category_id: category_id,
        price: price,
        gallery: gallery,
      },
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// delete a store service
exports.deleteService = async (req, res) => {
  const service_id = req.query.serviceId;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!service_id) {
      return res.status(400).json({ message: "missing" });
    }
    const foundService = await Service.findOne({
      where: { id: service_id },
    });
    if (!foundService) {
      return res.status(404).json({ message: "service_not_found" });
    }

    foundService.destroy();

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// get user's store
exports.getUserStore = async (req, res) => {
  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const existStore = await Store.findOne({
      where: { owner_id: user.id },
    });
    if (!existStore) {
      return res.status(200).json({ store: null });
    }
    const foundServices = await Service.findAll({
      where: { store_id: existStore.id },
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
    return res.status(200).json({
      store: {
        id: existStore.id,
        name: existStore.name,
        description: existStore.description,
        coordinates: existStore.coordinates,
        picture: existStore.picture,
        governorate_id: existStore.governorate_id,
        services,
        owner: user,
      },
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};
