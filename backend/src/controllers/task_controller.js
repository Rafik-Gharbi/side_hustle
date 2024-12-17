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
  populateOneTask,
  fetchAndSortGovernorateTasks,
} = require("../sql/sql_request");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const {
  getFileType,
  calculateTaskCoinsPrice,
  fetchPurchasedCoinsTransactions,
  checkReferralActiveUserRewards,
} = require("../helper/helpers");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const { Reservation } = require("../models/reservation_model");
const { Transaction } = require("../models/transaction_model");

// get boosted tasks & nearby tasks
exports.getHomeTasks = async (req, res) => {
  try {
    const currentUserId = req.decoded?.id;
    const searchMode = req.query.searchMode;
    let governorateId = req.query.governorateId;

    let foundUser;
    if (currentUserId) {
      foundUser = await User.findOne({ where: { id: currentUserId } });
    }
    if (typeof governorateId === "string") {
      governorateId = parseInt(governorateId, 10);
    }

    // get nearby tasks or user governorate tasks
    let nearbyTasks = [];
    if (searchMode === "nearby")
      nearbyTasks = await fetchAndSortNearbyTasks(
        foundUser,
        governorateId,
        (limit = 3)
      );

    let governorateTasks = [];
    if (searchMode !== "nearby" || nearbyTasks.length == 0)
      governorateTasks = await fetchAndSortGovernorateTasks(
        foundUser,
        governorateId,
        (limit = 3)
      );

    // get hot tasks
    const hotTasks = await getRandomHotTasks(
      foundUser,
      governorateId,
      (limit = 3)
    );

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
      governorateTasks,
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
    const boosted = req.query.boosted == "true";
    const querySearch = req.query.searchQuery ?? "";
    let governorateId = req.query.governorateId;
    const searchMode = req.query.searchMode;
    const minPrice = req.query.priceMin;
    const maxPrice = req.query.priceMax;
    const page = req.query.page;
    const limitEntry = req.query.limit;
    const currentUserId = req.decoded?.id;
    let categoryIdFilter = req.query.categoryId;
    let nearby = req.query.nearby;
    let taskIdFilter = req.query.taskId;

    const pageQuery = !page || page === "0" ? 1 : page;
    const limitQuery = limitEntry ? parseInt(limitEntry) : 9;
    const offsetQuery = (pageQuery - 1) * limitQuery;
    if (typeof governorateId === "string") {
      governorateId = parseInt(governorateId, 10);
    }
    if (typeof categoryIdFilter === "string") {
      categoryIdFilter = parseInt(categoryIdFilter, 10);
    }

    if (categoryIdFilter == -1) categoryIdFilter = undefined;
    if (nearby <= 1) nearby = undefined;

    let user;
    if (currentUserId) user = await User.findByPk(currentUserId);

    let tasks;
    if (boosted) {
      tasks = await getRandomHotTasks(user, limitQuery, offsetQuery);
    } else if (withCoordinates) {
      tasks = await fetchAndSortNearbyTasks(
        user,
        governorateId,
        (limit = limitQuery),
        (offset = offsetQuery),
        (searchQuery = `%${querySearch}%`),
        (categoryId = categoryIdFilter),
        (priceMin = minPrice),
        (priceMax = maxPrice),
        (taskId = taskIdFilter)
      );
    } else {
      tasks = await fetchAndSortGovernorateTasks(
        user,
        governorateId,
        (limit = limitQuery),
        (offset = offsetQuery),
        (searchQuery = `%${querySearch}%`),
        (categoryId = categoryIdFilter),
        (priceMin = minPrice),
        (priceMax = maxPrice),
        (taskId = taskIdFilter)
      );
    }
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

    const query = `
      SELECT
        task.*,
        user.id AS user_id,
        user.name,
        user.email,
        user.gender,
        user.birthdate,
        user.picture,
        user.governorate_id AS user_governorate_id,
        user.phone_number,
        user.role,
        CASE WHEN COUNT(CASE WHEN reservation.status IN('confirmed', 'finished') THEN 1 END) > 0 
          THEN -1 ELSE COUNT(reservation.id) END AS condidates
      FROM task JOIN user ON task.owner_id = user.id 
      LEFT JOIN reservation ON reservation.task_id = task.id 
      WHERE task.owner_id = :userId
      GROUP BY task.id
      ORDER BY condidates DESC
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

        return {
          condidates: row.condidates,
          task: {
            id: row.id,
            price: row.price,
            priceMax: row.priceMax,
            deducted_coins: row.deducted_coins,
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
    priceMax,
    category_id,
    governorate_id,
    delivrables,
    dueDate,
    owner_id,
    coordinates,
  } = req.body;

  const transaction = await sequelize.transaction();

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: owner_id } });
    if (!user) {
      await transaction.rollback();
      return res.status(404).json({ message: "user_not_found" });
    }
    const category = await Category.findOne({ where: { id: category_id } });
    if (!category) {
      await transaction.rollback();
      return res.status(404).json({ message: "category_not_found" });
    }
    const governorate = await Governorate.findOne({
      where: { id: governorate_id },
    });
    if (!governorate) {
      await transaction.rollback();
      return res.status(404).json({ message: "governorate_not_found" });
    }

    let deductedCoins = 0;

    let result = await Task.create(
      {
        title,
        description,
        price,
        priceMax,
        category_id,
        governorate_id,
        delivrables,
        due_date: dueDate,
        owner_id,
        coordinates,
        deducted_coins: deductedCoins,
      },
      { transaction }
    );

    if (price && price > 0) {
      let remainingCoins = calculateTaskCoinsPrice(price);
      deductedCoins = remainingCoins;

      const oneMonthFromNow = new Date();
      oneMonthFromNow.setMonth(oneMonthFromNow.getMonth() + 1);

      const purchaseTransactions = await fetchPurchasedCoinsTransactions(
        user.id
      );

      // Step 1: Prioritize purchased coins expiring within 1 month
      for (
        let i = 0;
        i < purchaseTransactions.length && remainingCoins > 0;
        i++
      ) {
        const purchaseTransaction = purchaseTransactions[i];
        const expirationDate = new Date(purchaseTransaction.createdAt);
        expirationDate.setMonth(
          expirationDate.getMonth() +
            purchaseTransaction.coin_pack_purchase.coin_pack.validMonths
        );

        // If the coins expire within 1 month, use them first
        if (
          expirationDate <= oneMonthFromNow &&
          purchaseTransaction.available > 0
        ) {
          const coinsToSubtractFromPurchased = Math.min(
            purchaseTransaction.available,
            remainingCoins
          );
          remainingCoins -= coinsToSubtractFromPurchased;
          purchaseTransaction.coin_pack_purchase.available -=
            coinsToSubtractFromPurchased;
          purchaseTransaction.coin_pack_purchase.save({ transaction });

          // Log usage of purchased coins
          if (coinsToSubtractFromPurchased > 0) {
            await Transaction.create(
              {
                coins: coinsToSubtractFromPurchased,
                task_id: result.id,
                user_id: user.id,
                type: "request",
                status: "completed",
                coin_pack_id: purchaseTransaction.coin_pack_purchase.id,
              },
              { transaction }
            );
          }
        }
      }

      // Step 2: Deduct from base coins if necessary
      if (remainingCoins > 0) {
        if (user.availableCoins < remainingCoins) {
          await transaction.rollback();
          return res.status(400).json({ message: "insufficient_base_coins" });
        }

        // Subtract remaining coins from base coins
        user.availableCoins -= remainingCoins;
        await user.save({ transaction });

        // Log usage of base coins
        await Transaction.create(
          {
            coins: remainingCoins,
            task_id: result.id,
            type: "request",
            status: "completed",
            user_id: user.id,
          },
          { transaction }
        );
      }
    }

    await transaction.commit();

    if (deductedCoins > 0) {
      result.deducted_coins = deductedCoins;
      result.save();
    }

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
      priceMax: result.priceMax,
      title: result.title,
      description: result.description,
      delivrables: result.delivrables,
      governorate_id: result.governorate_id,
      category_id: result.category_id,
      owner: user,
      attachments,
      coordinates,
      deducted_coins: deductedCoins,
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
    checkReferralActiveUserRewards(user.id);
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
      priceMax,
      category_id,
      governorate_id,
      delivrables,
      dueDate,
      coordinates,
    } = req.body;

    if (!id) {
      await transaction.rollback();
      return res.status(400).json({ message: "missing_task_id" });
    }
    const task = await Task.findByPk(id);
    if (!task) {
      await transaction.rollback();
      return res.status(404).json({ message: "task_not_found" });
    }
    const foundUser = await User.findByPk(req.decoded.id);
    if (!foundUser) {
      await transaction.rollback();
      return res.status(404).json({ message: "owner_not_found" });
    }
    if (foundUser.id != task.owner_id) {
      await transaction.rollback();
      return res.status(401).json({ message: "not_owner_task" });
    }

    let deductedCoins = task.deducted_coins;

    if (price && price > 0 && price > task.price) {
      let remainingCoins = calculateTaskCoinsPrice(price) - deductedCoins;
      if (remainingCoins > 0) {
        deductedCoins += remainingCoins;

        const oneMonthFromNow = new Date();
        oneMonthFromNow.setMonth(oneMonthFromNow.getMonth() + 1);

        const purchaseTransactions = await fetchPurchasedCoinsTransactions(
          foundUser.id
        );

        // Step 1: Prioritize purchased coins expiring within 1 month
        for (
          let i = 0;
          i < purchaseTransactions.length && remainingCoins > 0;
          i++
        ) {
          const purchaseTransaction = purchaseTransactions[i];
          const expirationDate = new Date(purchaseTransaction.createdAt);
          expirationDate.setMonth(
            expirationDate.getMonth() +
              purchaseTransaction.coin_pack_purchase.coin_pack.validMonths
          );

          // If the coins expire within 1 month, use them first
          if (
            expirationDate <= oneMonthFromNow &&
            purchaseTransaction.available > 0
          ) {
            const coinsToSubtractFromPurchased = Math.min(
              purchaseTransaction.available,
              remainingCoins
            );
            remainingCoins -= coinsToSubtractFromPurchased;
            purchaseTransaction.coin_pack_purchase.available -=
              coinsToSubtractFromPurchased;
            purchaseTransaction.coin_pack_purchase.save({ transaction });

            // Log usage of purchased coins
            if (coinsToSubtractFromPurchased > 0) {
              await Transaction.create(
                {
                  coins: coinsToSubtractFromPurchased,
                  task_id: task.id,
                  user_id: foundUser.id,
                  type: "request",
                  status: "completed",
                  coin_pack_id: purchaseTransaction.coin_pack_purchase.id,
                },
                { transaction }
              );
            }
          }
        }

        // Step 2: Deduct from base coins if necessary
        if (remainingCoins > 0) {
          if (foundUser.availableCoins < remainingCoins) {
            await transaction.rollback();
            return res.status(400).json({ message: "insufficient_base_coins" });
          }

          // Subtract remaining coins from base coins
          foundUser.availableCoins -= remainingCoins;
          await foundUser.save({ transaction });

          // Log usage of base coins
          await Transaction.create(
            {
              coins: remainingCoins,
              task_id: task.id,
              type: "request",
              status: "completed",
              user_id: foundUser.id,
            },
            { transaction }
          );
        }
      }
    }

    // Update task
    const updatedTask = await task.update(
      {
        title,
        description,
        price,
        priceMax,
        category_id,
        governorate_id,
        delivrables,
        dueDate,
        coordinates,
        deducted_coins: deductedCoins,
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
        priceMax: updatedTask.priceMax,
        title: updatedTask.title,
        description: updatedTask.description,
        delivrables: updatedTask.delivrables,
        governorate_id: updatedTask.governorate_id,
        category_id: updatedTask.category_id,
        coordinates: updatedTask.coordinates,
        owner: foundUser,
        deducted_coins: deductedCoins,
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

    const tasksReservation = await Reservation.findAll({
      where: { task_id: ID },
    });
    if (tasksReservation.length == 0) {
      await Task.destroy({ where: { id: ID } });
      // Delete the image files
      attachments.forEach((image) => {
        deleteImage(path.join(__dirname, "../../public/task", image.url));
      });
    } else {
      const task = await Task.findByPk(ID);
      task.archived = true;
      task.save();
    }
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json(error);
  }
};

exports.getTaskById = async (req, res) => {
  try {
    const ID = req.params.id;
    const foundTask = await Task.findByPk(ID);
    const task = await populateOneTask(foundTask);

    if (task.owner.id !== req.decoded.id) {
      return res.status(400).json({ message: "not_allowed" });
    }
    return res.status(200).json({ task });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json(error);
  }
};
