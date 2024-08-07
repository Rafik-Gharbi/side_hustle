const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Task } = require("../models/task_model");
const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  getFavoriteTaskByUserId,
  populateTasks,
  fetchAndSortNearbyTasks,
  fetchUserReservation,
  fetchUserBooking,
  fetchUserOngoingReservation,
  fetchUserOngoingBooking,
  getRandomHotTasks,
} = require("../sql/sql_request");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const { getFileType, getTaskCondidatesNumber } = require("../helper/helpers");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");

// get boosted tasks & nearby tasks
exports.getHomeTasks = async (req, res) => {
  try {
    const currentUserId = req.decoded?.id;
    let foundUser;
    if (currentUserId) {
      foundUser = await User.findOne({ where: { id: currentUserId } });
    }

    // get nearby tasks or user governorate tasks
    let nearbyTasks = [];
    nearbyTasks = await fetchAndSortNearbyTasks(foundUser, (limit = 3));

    // get hot tasks
    const hotTasks = await getRandomHotTasks(foundUser, (limit = 3));

    // get user's reservation (pending and ongoing tasks)
    let reservation = [];
    if (currentUserId) {
      const userReservations = await fetchUserReservation(currentUserId);
      reservation = userReservations.filter(
        (e) => e.status === "pending" || e.status === "confirmed"
      );
    }

    // get user's booking (pending and ongoing tasks)
    let booking = [];
    if (currentUserId) {
      const userBookings = await fetchUserBooking(currentUserId);
      booking = userBookings.filter(
        (e) => e.status === "pending" || e.status === "confirmed"
      );
    }

    // get user's ongoing reservation (pending and ongoing tasks)
    let ongoingReservation = [];
    if (currentUserId) {
      const userReservations = await fetchUserOngoingReservation(currentUserId);
      ongoingReservation = userReservations.filter(
        (e) => e.status === "pending" || e.status === "confirmed"
      );
    }

    // get user's ongoing booking (pending and ongoing tasks)
    let ongoingBooking = [];
    if (currentUserId) {
      const userBookings = await fetchUserOngoingBooking(currentUserId);
      ongoingBooking = userBookings.filter(
        (e) => e.status === "pending" || e.status === "confirmed"
      );
    }
    return res.status(200).json({
      hotTasks,
      nearbyTasks,
      reservation,
      booking,
      ongoingReservation,
      ongoingBooking,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// filter tasks
exports.filterTasks = async (req, res) => {
  try {
    const withCoordinates = req.query.withCoordinates;
    const searchQuery = req.query.searchQuery ?? "";
    const priceMin = req.query.priceMin;
    const priceMax = req.query.priceMax;
    const page = req.query.page;
    const limit = req.query.limit;
    const currentUserId = req.decoded?.id;
    let categoryId = req.query.categoryId;
    let nearby = req.query.nearby;
    let taskId = req.query.taskId;

    const pageQuery = !page || page === "0" ? 1 : page;
    const limitQuery = limit ? parseInt(limit) : 9;
    const offset = (pageQuery - 1) * limit;

    if (categoryId == -1) categoryId = undefined;
    if (nearby <= 1) nearby = undefined;

    const queryCoordinates = `SELECT task.*, 
      user.id AS user_id,
      user.name,
      user.email,
      user.gender,
      user.birthdate,
      user.picture,
      user.governorate_id as user_governorate_id,
      user.phone_number,
      user.role FROM task JOIN user ON task.owner_id = user.id 
      WHERE (task.title LIKE :searchQuery OR task.description LIKE :searchQuery)
      AND task.coordinates IS NOT NULL
      ${categoryId ? `AND task.category_id = :categoryId` : ``}
      ${
        priceMin && priceMax
          ? `AND task.price >= :priceMin AND task.price <= :priceMax`
          : ``
      }
    ;`;
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
      ${taskId ? `AND task.id = :taskId` : ``}
      ${
        priceMin && priceMax
          ? `AND task.price >= :priceMin AND task.price <= :priceMax`
          : ``
      }
      LIMIT :limit OFFSET :offset
    ;`;
    const tasks = await sequelize.query(
      withCoordinates ? queryCoordinates : query,
      {
        type: sequelize.QueryTypes.SELECT,
        replacements: {
          searchQuery: `%${searchQuery}%`,
          categoryId: categoryId,
          priceMin: priceMin,
          priceMax: priceMax,
          taskId: taskId,
          limit: limitQuery,
          offset: offset,
        },
      }
    );
    const formattedList = await populateTasks(tasks, currentUserId);
    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// user task request
exports.taskRequest = async (req, res) => {
  try {
    const page = req.query.page;
    const limit = req.query.limit;
    const currentUserId = req.decoded?.id;

    const pageQuery = page ?? 1;
    const limitQuery = limit ? parseInt(limit) : 9;
    const offset = (pageQuery - 1) * limit;

    let userFavorites = [];
    const userFound = await User.findByPk(currentUserId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    } else {
      userFavorites = await getFavoriteTaskByUserId(currentUserId);
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
      user.role FROM task JOIN user ON task.owner_id = user.id WHERE task.owner_id = :userId
      LIMIT :limit OFFSET :offset
;`;
    const tasks = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        userId: currentUserId,
        limit: limitQuery,
        offset: offset,
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

        const condidates = await getTaskCondidatesNumber(row.id);

        return {
          condidates,
          task: {
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
          },
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
    coordinates,
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
      coordinates,
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
      coordinates,
    };

    // Send notification to subscribed task category
    const subscribed = await CategorySubscriptionModel.findAll({
      where: { category_id: task.category_id },
    });
    let tokenList = [];
    tokenList = await Promise.all(
      subscribed.map(async (subscription) => {
        const subscribedUser = await User.findOne({
          where: { id: subscription.user_id },
        });
        if (user.id != subscribedUser.id) {
          return subscribedUser.id;
        }
      })
    );
    await notificationService.sendNotificationList(
      tokenList,
      "New Task Available",
      `A new task in "${category.name}" category has been created. Check it out!`,
      NotificationType.NEWTASK,
      { taskId: task.id }
    );

    // Return created task
    return res.status(200).json({ task });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// update a task
exports.updateTask = async (req, res) => {
  const transaction = await sequelize.transaction();
  const id = req.params.id;
  try {
    const {
      title,
      description,
      price,
      category_id,
      governorate_id,
      delivrables,
      dueDate,
      coordinates,
    } = req.body;

    if (!id) {
      return res.status(400).json({ message: "missing_task_id" });
    }
    const task = await Task.findByPk(id);
    if (!task) {
      return res.status(404).json({ message: "task_not_found" });
    }
    const foundUser = await User.findByPk(req.decoded.id);
    if (!foundUser) {
      return res.status(404).json({ message: "owner_not_found" });
    }
    if (foundUser.id != task.owner_id) {
      return res.status(401).json({ message: "not_owner_task" });
    }

    // Update task
    const updatedTask = await task.update(
      {
        title,
        description,
        price,
        category_id,
        governorate_id,
        delivrables,
        dueDate,
        coordinates,
      },
      { transaction }
    );

    // Parse the images string from the request body
    // const updatedImages = JSON.parse(images);

    // Find existing images and determine which ones to delete
    const existingAttachments = await TaskAttachmentModel.findAll({
      where: { task_id: id },
    });
    const imagesToDelete = existingAttachments.filter(
      (img) => !images.some((updatedImg) => updatedImg.url === img.url)
    );
    for (const img of imagesToDelete) {
      await TaskAttachmentModel.destroy({ where: { id: img.id }, transaction });
    }
    // Handle image uploads
    if (req.files && req.files.gallery) {
      const imagePromises = req.files.gallery.map(async (imageProp) => {
        if (imageProp) {
          try {
            const originalPath = imageProp.path;
            const thumbnailPath = `public/task/${imageProp.filename}`;
            await sharp(originalPath).resize(200, 200).toFile(thumbnailPath);

            await TaskAttachmentModel.create(
              {
                url: imageProp.filename,
                type: getFileType(file),
                task_id: task.id,
              },
              { transaction }
            );
          } catch (error) {
            throw new Error(
              `Error processing image ${imageProp.originalname}: ${error.message}`
            );
          }
        }
      });

      await Promise.all(imagePromises);
    }

    // Commit the transaction
    await transaction.commit();

    return res.status(200).json({
      task: {
        id: updatedTask.id,
        price: updatedTask.price,
        title: updatedTask.title,
        description: updatedTask.description,
        delivrables: updatedTask.delivrables,
        governorate_id: updatedTask.governorate_id,
        category_id: updatedTask.category_id,
        coordinates: updatedTask.coordinates,
        owner: foundUser,
      },
    });
  } catch (error) {
    // Rollback the transaction in case of error
    if (transaction) await transaction.rollback();
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// delete a task
exports.deleteTask = async (req, res) => {
  try {
    const ID = req.params.id;
    // Fetch images related to the task
    const attachments = await TaskAttachmentModel.findAll({
      where: { task_id: ID },
    });

    await Task.destroy({ where: { id: ID } });
    // Delete the image files
    attachments.forEach((image) => {
      deleteImage(path.join(__dirname, "../../public/task", image.url));
    });
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json(error);
  }
};
