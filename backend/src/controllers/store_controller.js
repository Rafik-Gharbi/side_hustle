const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Store } = require("../models/store_model");
const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  getFileType,
  checkStoreFavorite,
  shuffleArray,
  calculateTaskCoinsPrice,
} = require("../helper/helpers");
const { Service } = require("../models/service_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");
const { populateServices, populateOneService } = require("../sql/sql_request");
const { Review } = require("../models/review_model");
const { Boost } = require("../models/boost_model");
const { Op } = require("sequelize");
const { Reservation } = require("../models/reservation_model");

// filter stores
exports.filterStores = async (req, res) => {
  try {
    const withCoordinates = req.query.withCoordinates;
    const searchQuery = req.query.searchQuery ?? "";
    let categoryId = req.query.categoryId;
    const priceMin = req.query.priceMin;
    const priceMax = req.query.priceMax;
    const nearby = req.query.nearby;
    const page = req.query.page;
    const limit = req.query.limit;
    const currentUserId = req.decoded?.id;

    const pageQuery = !page || page === "0" ? 1 : page;
    const limitQuery = limit ? parseInt(limit) : 9;
    const offset = (pageQuery - 1) * limit;

    // TODO add store favorite feature
    // let userFavorites = [];
    // if (currentUserId) {
    //   userFavorites = await getFavoriteByUserId(currentUserId);
    // }

    if (categoryId == -1) categoryId = undefined;

    const queryCoordinates = `SELECT store.*, 
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
      AND service.archived = false
      AND store.coordinates IS NOT NULL
      ${categoryId ? `AND service.category_id = :categoryId` : ``}
      ${
        priceMin && priceMax
          ? `AND service.price >= :priceMin AND service.price <= :priceMax`
          : ``
      }
      GROUP BY store.id
    ;`;

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
      AND service.archived = false
      ${categoryId ? `AND service.category_id = :categoryId` : ``}
      ${
        priceMin && priceMax
          ? `AND service.price >= :priceMin AND service.price <= :priceMax`
          : ``
      }
      GROUP BY store.id
      LIMIT :limit OFFSET :offset
    ;`;
    const stores = await sequelize.query(
      withCoordinates ? queryCoordinates : query,
      {
        type: sequelize.QueryTypes.SELECT,
        replacements: {
          searchQuery: `%${searchQuery}%`,
          categoryId: categoryId,
          priceMin: priceMin,
          priceMax: priceMax,
          limit: limitQuery,
          offset: offset,
        },
      }
    );
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
        const services = await populateServices(foundServices);

        const isFavorite = await checkStoreFavorite(row, currentUserId);

        const storeOwnerReviews = await Review.findAll({
          where: { user_id: owner.id },
        });
        const storeOwnerRating =
          storeOwnerReviews.length > 0
            ? storeOwnerReviews
                .map((review) => review.rating)
                .reduce((total, rating) => total + rating, 0) /
              storeOwnerReviews.length
            : 0;
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
          rating: storeOwnerRating,
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
      picture: req.files?.photo ? req.files?.photo[0]["filename"] : nill,
    });

    return res.status(200).json({
      store: {
        id: store.id,
        name: store.name,
        description: store.description,
        governorate_id: store.governorate_id,
        coordinates: store.coordinates,
        picture: store.picture,
        owner: user,
      },
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// add a new store service
exports.addService = async (req, res) => {
  const {
    name,
    description,
    price,
    category_id,
    included,
    notIncluded,
    notes,
    timeEstimationFrom,
    timeEstimationTo,
  } = req.body;

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
    if (user.role != "subscribed" && foundServices.length > 4) {
      return res.status(400).json({ message: "service_limit_reached" });
    }

    let service = await Service.create({
      name,
      description,
      category_id,
      price,
      store_id: existStore.id,
      included,
      notIncluded,
      notes,
      timeEstimationFrom,
      timeEstimationTo,
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
        included: service.included,
        notIncluded: service.notIncluded,
        notes: service.notes,
        timeEstimationFrom: service.timeEstimationFrom,
        timeEstimationTo: service.timeEstimationTo,
        coins: calculateTaskCoinsPrice(service.price),
        owner: user,
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
  const {
    id,
    name,
    description,
    price,
    category_id,
    included,
    notIncluded,
    notes,
    timeEstimationFrom,
    timeEstimationTo,
  } = req.body;

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
    foundService.included = included;
    foundService.notIncluded = notIncluded;
    foundService.notes = notes;
    foundService.timeEstimationFrom = timeEstimationFrom;
    foundService.timeEstimationTo = timeEstimationTo;
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
        included: included,
        notIncluded: notIncluded,
        notes: notes,
        timeEstimationFrom: timeEstimationFrom,
        timeEstimationTo: timeEstimationTo,
        coins: calculateTaskCoinsPrice(service.price),
        owner: user,
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
    const serviceBookings = await Reservation.findAll({
      where: { service_id: service_id },
    });
    if (serviceBookings.length == 0) {
      foundService.destroy();
    } else {
      foundService.archived = true;
      foundService.save();
    }

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
      where: { store_id: existStore.id, archived: false },
    });
    const services = await populateServices(foundServices);

    const storeReviews = await Review.findAll({
      where: { user_id: existStore.owner_id },
    });
    let reviews = [];
    reviews = await Promise.all(
      storeReviews.map(async (review) => {
        const reviewee = await User.findOne({
          where: { id: review.reviewee_id },
        });
        return {
          id: review.id,
          message: review.message,
          rating: review.rating,
          reviewee: {
            id: reviewee.id,
            name: reviewee.name,
            governorate_id: reviewee.governorate_id,
            picture: reviewee.picture,
            isVerified: reviewee.isVerified,
          },
          user: {
            id: user.id,
            name: user.name,
            governorate_id: user.governorate_id,
            picture: user.picture,
            isVerified: user.isVerified,
          },
          quality: review.quality,
          createdAt: review.createdAt,
          fees: review.fees,
          punctuality: review.punctuality,
          politeness: review.politeness,
        };
      })
    );
    const storeOwnerRating =
      reviews.length > 0
        ? reviews
            .map((review) => review.rating)
            .reduce((total, rating) => total + rating, 0) / reviews.length
        : 0;

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
        rating: storeOwnerRating,
      },
      reviews: reviews,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// get user's store
exports.getStoreById = async (req, res) => {
  try {
    const ID = req.params.id;
    const existStore = await Store.findOne({
      where: { id: ID },
    });
    if (!existStore) {
      return res.status(200).json({ store: null });
    }
    const user = await User.findOne({ where: { id: existStore.owner_id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const foundServices = await Service.findAll({
      where: { store_id: existStore.id, archived: false },
    });
    const services = await populateServices(foundServices);

    const storeReviews = await Review.findAll({
      where: { user_id: existStore.owner_id },
    });
    let reviews = [];
    reviews = await Promise.all(
      storeReviews.map(async (review) => {
        const reviewee = await User.findOne({
          where: { id: review.reviewee_id },
        });
        return {
          id: review.id,
          message: review.message,
          rating: review.rating,
          reviewee: {
            id: reviewee.id,
            name: reviewee.name,
            governorate_id: reviewee.governorate_id,
            picture: reviewee.picture,
            isVerified: reviewee.isVerified,
          },
          user: {
            id: user.id,
            name: user.name,
            governorate_id: user.governorate_id,
            picture: user.picture,
            isVerified: user.isVerified,
          },
          quality: review.quality,
          createdAt: review.createdAt,
          fees: review.fees,
          punctuality: review.punctuality,
          politeness: review.politeness,
        };
      })
    );
    const storeOwnerRating =
      reviews.length > 0
        ? reviews
            .map((review) => review.rating)
            .reduce((total, rating) => total + rating, 0) / reviews.length
        : 0;

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
        rating: storeOwnerRating,
      },
      reviews: reviews,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// get user's store
exports.getHotServices = async (req, res) => {
  try {
    // get hot tasks
    const activeBoost = await Boost.findAll({
      where: {
        isTask: false,
        isActive: true,
        endDate: { [Op.gt]: new Date() }, // grater than today
      },
    });
    const services = await Promise.all(
      activeBoost.map(async (row) => {
        const service = await Service.findOne({
          where: { id: row.task_service_id },
        });
        const populatedService = await populateOneService(service);
        const serviceStore = await Store.findOne({
          where: { id: service.store_id },
        });
        const storeOwner = await User.findOne({
          where: { id: serviceStore.owner_id },
        });
        const foundStore = {
          id: serviceStore.id,
          name: serviceStore.name,
          description: serviceStore.description,
          governorate_id: serviceStore.governorate_id,
          coordinates: serviceStore.coordinates,
          picture: serviceStore.picture,
          owner: storeOwner,
        };
        return {
          service: populatedService,
          store: foundStore,
        };
      })
    );

    // Shuffle the services array
    shuffleArray(services);

    // Apply limit and offset to the shuffled array
    const hotServices = services.slice(0, 3);
    return res.status(200).json({ hotServices });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};
