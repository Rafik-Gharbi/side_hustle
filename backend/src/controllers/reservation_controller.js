const cron = require("node-cron");
const {
  getDate,
  checkUnitDinar,
  getTaskCondidatesNumber,
  calculateTaskCoinsPrice,
  generateJWT,
  getServiceCondidatesNumber,
  fetchPurchasedCoinsTransactions,
  checkReferralActiveUserRewards,
} = require("../helper/helpers");
const { User } = require("../models/user_model");
const axios = require("axios");
const jwt = require("jsonwebtoken");
const { encryptData } = require("../helper/encryption");
const {
  fetchUserReservation,
  populateOneTask,
  populateOneService,
  getServiceOwner,
} = require("../sql/sql_request");
const { sendMail } = require("../helper/email_service");
const { Task } = require("../models/task_model");
const { Reservation } = require("../models/reservation_model");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const { Transaction } = require("../models/transaction_model");
const { Service } = require("../models/service_model");
const { Op } = require("sequelize");
const { Store } = require("../models/store_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");
const { sequelize } = require("../../db.config");
const { Contract } = require("../models/contract_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");

exports.addTaskReservation = async (req, res) => {
  const {
    taskId,
    date,
    totalPrice,
    coupon,
    status,
    note,
    proposedPrice,
    dueDate,
    coins,
  } = req.body;

  if (!taskId || !date || !totalPrice || !status) {
    return res.status(400).json({ message: "missing" });
  }

  // Start a database transaction
  const transaction = await sequelize.transaction();

  try {
    let userFound = await User.findByPk(req.decoded.id);
    let foundTask = await Task.findByPk(taskId);
    if (!foundTask) {
      return res.status(404).json({ message: "task_not_found" });
    }
    let taskOwner = await User.findByPk(foundTask.owner_id);

    if (!userFound || !taskOwner) {
      await transaction.rollback();
      return res.status(404).json({ message: "user_not_found" });
    }

    if (!foundTask) {
      await transaction.rollback();
      return res.status(404).json({ message: "task_not_found" });
    }

    let existReservation = await Reservation.findOne({
      where: {
        user_id: userFound.id,
        task_id: taskId,
      },
    });

    if (existReservation) {
      await transaction.rollback();
      return res.status(400).json({ message: "reservation_already_exist" });
    }

    const reservationTask = await populateOneTask(
      await Task.findOne({ where: { id: taskId } })
    );

    if (coins != calculateTaskCoinsPrice(reservationTask.price)) {
      await transaction.rollback();
      return res.status(400).json({ message: "coins_not_valid" });
    }

    const oneMonthFromNow = new Date();
    oneMonthFromNow.setMonth(oneMonthFromNow.getMonth() + 1);

    const purchaseTransactions = await fetchPurchasedCoinsTransactions(
      userFound.id
    );
    let remainingCoins = coins;

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
              task_id: taskId,
              user_id: userFound.id,
              coin_pack_id: purchaseTransaction.coin_pack_purchase.id,
            },
            { transaction }
          );
        }
      }
    }

    // Step 2: Deduct from base coins if necessary
    if (remainingCoins > 0) {
      if (userFound.availableCoins < remainingCoins) {
        await transaction.rollback();
        return res.status(400).json({ message: "insufficient_base_coins" });
      }

      // Subtract remaining coins from base coins
      userFound.availableCoins -= remainingCoins;
      await userFound.save({ transaction });

      // Log usage of base coins
      await Transaction.create(
        {
          coins: remainingCoins,
          task_id: taskId,
          user_id: userFound.id,
        },
        { transaction }
      );
    }

    // Step 3: Create the reservation
    const reservation = await Reservation.create(
      {
        date,
        task_id: taskId,
        provider_id: userFound.id,
        user_id: taskOwner.id,
        total_price: totalPrice,
        proposed_price: proposedPrice,
        coupon,
        note,
        status,
        dueDate,
      },
      { transaction }
    );

    // Commit the transaction if everything succeeds
    await transaction.commit();

    // Step 4: Send notification to the task owner
    notificationService.sendNotification(
      foundTask.owner_id,
      "notifications.new_proposal",
      "notifications.new_proposal_on_your_task",
      NotificationType.RESERVATION,
      { reservationId: reservation.id, taskId: taskId, isOwner: true }
    );

    // Generate JWT for the user
    const token = await generateJWT(userFound);

    return res.status(200).json({
      reservation: {
        id: reservation.id,
        date,
        task: reservationTask,
        user: userFound,
        provider: taskOwner,
        total_price: totalPrice,
        proposed_price: proposedPrice,
        coins: coins,
        coupon,
        note,
        status,
      },
      token: token,
    });
  } catch (error) {
    // Rollback the transaction in case of any failure
    await transaction.rollback();
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.listTaskReservation = async (req, res) => {
  try {
    const formattedList = await fetchUserReservation(req.decoded.id);

    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.userTaskReservationsHistory = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let reservationList = await Reservation.findAll({
      where: {
        user_id: userFound.id,
        status: { [Op.ne]: "pending" },
      },
    });
    const formattedList = await Promise.all(
      reservationList.map(async (row) => {
        let foundTask = await Task.findByPk(row.task_id);
        let taskOwnerFound = await User.findByPk(foundTask.owner_id);
        let taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.task_id },
        });
        const providerFound = await User.findOne({
          where: { id: row.provider_id },
        });

        return {
          id: row.id,
          user: userFound,
          provider: providerFound,
          date: row.createdAt,
          task: {
            id: foundTask.id,
            price: foundTask.price,
            deducted_coins: foundTask.deducted_coins,
            title: foundTask.title,
            description: foundTask.description,
            delivrables: foundTask.delivrables,
            governorate_id: foundTask.governorate_id,
            category_id: foundTask.category_id,
            owner: taskOwnerFound,
            attachments: taskAttachments.length == 0 ? [] : taskAttachments,
            isFavorite: false,
          },
          totalPrice: row.total_price,
          proposedPrice: row.proposed_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          taskAttachments,
          dueDate: row.dueDate,
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

exports.getReservationByTask = async (req, res) => {
  try {
    let taskFound = await Task.findByPk(req.query.taskId);
    if (!taskFound) {
      return res.status(404).json({ message: "task_not_found" });
    }

    let reservationList = await Reservation.findAll({
      where: {
        task_id: taskFound.id,
      },
    });
    const populatedTask = await populateOneTask(taskFound, req.decoded.id);

    const formattedList = await Promise.all(
      reservationList.map(async (row) => {
        const userFound = await User.findOne({
          where: { id: row.user_id },
        });
        const providerFound = await User.findOne({
          where: { id: row.provider_id },
        });

        return {
          id: row.id,
          user: userFound,
          provider: providerFound,
          date: row.createdAt,
          task: populatedTask,
          totalPrice: row.total_price,
          proposedPrice: row.proposed_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          taskAttachments: populatedTask.attachments,
          dueDate: row.dueDate,
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

exports.updateTaskReservationStatus = async (req, res) => {
  try {
    let reservationFound = await Reservation.findByPk(req.body.reservation.id);
    if (!reservationFound) {
      return res.status(404).json({ message: "reservation_not_found" });
    }
    if (!req.body.status) {
      return res.status(400).json({ message: "missing" });
    }
    let reservationList = await Reservation.findAll({
      where: {
        task_id: reservationFound.task_id,
      },
    });

    if (reservationList.length > 1 && req.body.status === "confirmed") {
      reservationList.forEach(async (reservation) => {
        if (reservation.id != reservationFound.id) {
          reservation.status = "rejected";
          await reservation.save();
          await notificationService.sendNotification(
            reservation.provider_id,
            "notifications.your_proposal_rejected",
            "notifications.owner_rejected_your_proposal",
            NotificationType.RESERVATION,
            {
              reservationId: reservationFound.id,
              taskId: reservationFound.task_id,
            }
          );
        }
      });
    }

    reservationFound.status = req.body.status;
    reservationFound.save();

    const transactions = await Transaction.findAll({
      where: {
        user_id: reservationFound.user_id,
        task_id: reservationFound.task_id,
      },
    });
    // Send a notification to the seeker regarding the new status
    switch (req.body.status) {
      case "confirmed":
        for (let index = 0; index < transactions.length; index++) {
          const element = transactions[index];
          element.status = "completed";
          element.save();
        }
        notificationService.sendNotification(
          reservationFound.provider_id,
          "notifications.your_proposal_confirmed",
          "notifications.owner_confirmed_your_proposal",
          NotificationType.RESERVATION,
          {
            reservationId: reservationFound.id,
            taskId: reservationFound.task_id,
          }
        );
        checkReferralActiveUserRewards(reservationFound.user_id);
        break;
      case "rejected":
        for (let index = 0; index < transactions.length; index++) {
          const element = transactions[index];
          element.status = "refunded";
          element.save();
          if (!element.coin_pack_id) {
            const userFound = await User.findByPk(reservationFound.user_id);
            userFound.availableCoins += element.coins;
            userFound.save();
          }
        }
        notificationService.sendNotification(
          reservationFound.provider_id,
          "notifications.your_proposal_rejected",
          "notifications.owner_rejected_your_proposal",
          NotificationType.RESERVATION,
          {
            reservationId: reservationFound.id,
            taskId: reservationFound.task_id,
          }
        );
        break;
      case "finished":
        const contract = await Contract.findOne({
          where: { reservation_id: reservationFound.id },
        });
        if (contract.isSigned && contract.isPayed) {
          await BalanceTransaction.create({
            userId: contract.provider_id,
            amount: contract.finalPrice,
            type: "taskEarnings",
            status: "pending",
            description: `Earnings for contract ${contract.id}`,
          });
          notificationService.sendNotification(
            reservationFound.provider_id,
            "notifications.task_finished",
            "notifications.task_owner_confirmed_work",
            NotificationType.RESERVATION,
            {
              reservationId: reservationFound.id,
              taskId: reservationFound.task_id,
            }
          );
        }
        break;
      default:
    }

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getServiceReservationDetails = async (req, res) => {
  try {
    const condidates = await getTaskCondidatesNumber(req.query.taskId);
    if (typeof condidates === "string")
      res.status(404).json({ message: condidates });
    const confirmedReservation = await Reservation.findOne({
      where: {
        task_id: req.query.taskId,
        status: "confirmed",
      },
    });

    let isUserTaskSeeker = false;
    if (
      confirmedReservation &&
      confirmedReservation.user_id === req.decoded?.id
    ) {
      isUserTaskSeeker = true;
    }

    let confirmedTaskUser;
    let reservation;
    let taskFound = await Task.findByPk(req.query.taskId);
    reservation = await Reservation.findOne({
      where: {
        task_id: taskFound.id,
        status: "confirmed",
      },
    });
    if (reservation) {
      const populatedTask = await populateOneTask(taskFound, req.decoded.id);
      let userFound = await User.findOne({
        where: { id: reservation.user_id },
      });
      let providerFound = await User.findOne({
        where: { id: reservation.provider_id },
      });
      confirmedTaskUser = await User.findOne({
        where: { id: reservation.user_id },
      });
      reservation = {
        id: reservation.id,
        user: userFound,
        provider: providerFound,
        date: reservation.createdAt,
        task: populatedTask,
        totalPrice: reservation.total_price,
        coupon: reservation.coupon,
        note: reservation.note,
        status: reservation.status,
        taskAttachments: populatedTask.attachments,
        dueDate: reservation.dueDate,
      };
    }

    return res
      .status(200)
      .json({ condidates, isUserTaskSeeker, confirmedTaskUser, reservation });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.addServiceReservation = async (req, res) => {
  const { serviceId, date, totalPrice, coupon, status, note, dueDate, coins } =
    req.body;
  if (!serviceId || !date || !totalPrice || !status) {
    return res.status(400).json({ message: "missing" });
  }
  const transaction = await sequelize.transaction();

  try {
    let userFound = await User.findByPk(req.decoded.id);
    let foundService = await Service.findByPk(serviceId);
    if (!userFound) {
      await transaction.rollback();
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!foundService) {
      await transaction.rollback();
      return res.status(404).json({ message: "service_not_found" });
    }
    let existReservation = await Reservation.findOne({
      where: {
        user_id: userFound.id,
        service_id: serviceId,
        [Op.or]: [{ status: "pending" }, { status: "confirmed" }],
      },
    });
    if (existReservation) {
      await transaction.rollback();
      return res.status(400).json({ message: "reservation_already_exist" });
    }
    const serviceStore = await Store.findOne({
      where: { id: foundService.store_id },
    });
    if (serviceStore.owner_id == userFound.id) {
      await transaction.rollback();
      return res.status(400).json({ message: "cannot_book_your_own_service" });
    }
    const storeOwner = await User.findOne({
      where: { id: serviceStore.owner_id },
    });

    const reservationService = await populateOneService(
      await Service.findOne({ where: { id: serviceId } })
    );

    if (coins != calculateTaskCoinsPrice(reservationService.price)) {
      await transaction.rollback();
      return res.status(400).json({ message: "coins_not_valid" });
    }

    const oneMonthFromNow = new Date();
    oneMonthFromNow.setMonth(oneMonthFromNow.getMonth() + 1);

    const purchaseTransactions = await fetchPurchasedCoinsTransactions(
      userFound.id
    );
    let remainingCoins = coins;

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
              service_id: serviceId,
              user_id: userFound.id,
              coin_pack_id: purchaseTransaction.coin_pack_purchase.id,
            },
            { transaction }
          );
        }
      }
    }

    // Step 2: Deduct from base coins if necessary
    if (remainingCoins > 0) {
      if (userFound.availableCoins < remainingCoins) {
        await transaction.rollback();
        return res.status(400).json({ message: "insufficient_base_coins" });
      }

      // Subtract remaining coins from base coins
      userFound.availableCoins -= remainingCoins;
      await userFound.save({ transaction });

      // Log usage of base coins
      await Transaction.create(
        {
          coins: remainingCoins,
          service_id: serviceId,
          user_id: userFound.id,
        },
        { transaction }
      );
    }

    // Step 3: Create the reservation
    const newReservation = await Reservation.create(
      {
        date,
        service_id: serviceId,
        user_id: storeOwner.id,
        provider_id: userFound.id,
        total_price: totalPrice,
        coupon,
        note,
        status,
        dueDate,
      },
      { transaction }
    );

    // Commit the transaction if everything succeeds
    await transaction.commit();

    const reservation = await Reservation.findOne({
      where: { id: newReservation.id },
      include: [
        { model: User, as: "user" },
        { model: User, as: "provider" },
        { model: Service, as: "service" },
      ],
    });

    // Step 4: Send notification to the task owner
    notificationService.sendNotification(
      serviceStore.owner_id,
      "notifications.new_reservation",
      "notifications.new_service_booked",
      NotificationType.BOOKING,
      { storeId: serviceStore.id, serviceId: foundService.id, isOwner: true }
    );
    const token = await generateJWT(userFound);

    return res.status(200).json({ reservation, token });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.userServicesHistory = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let reservationList = await Reservation.findAll({
      where: {
        user_id: userFound.id,
      },
    });
    const formattedList = await Promise.all(
      reservationList.map(async (row) => {
        const foundService = await Service.findByPk(row.service_id);
        const populatedService = await populateOneService(foundService);
        const serviceGallerys = await ServiceGalleryModel.findAll({
          where: { service_id: row.service_id },
        });
        const providerFound = await User.findOne({
          where: { id: row.provider_id },
        });

        return {
          id: row.id,
          user: userFound,
          provider: providerFound,
          date: row.createdAt,
          service: populatedService,
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          serviceGallerys,
          dueDate: row.dueDate,
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

exports.getReservationByService = async (req, res) => {
  try {
    let serviceFound = await Service.findByPk(req.query.serviceId);
    if (!serviceFound) {
      return res.status(404).json({ message: "service_not_found" });
    }

    let foundStore = await Store.findOne({
      where: {
        id: serviceFound.store_id,
      },
    });
    let reservationList = await Reservation.findAll({
      where: {
        service_id: serviceFound.id,
      },
    });
    let serviceGallerys = await ServiceGalleryModel.findAll({
      where: { service_id: serviceFound.id },
    });
    const owner = await User.findOne({
      where: { id: foundStore.owner_id },
    });

    const formattedList = await Promise.all(
      reservationList.map(async (row) => {
        let userFound = await User.findOne({
          where: { id: row.user_id },
        });
        const providerFound = await User.findOne({
          where: { id: row.provider_id },
        });
        const serviceCondidatesNumber = await getServiceCondidatesNumber(
          row.service_id
        );
        if (serviceCondidatesNumber == "service_not_found") {
          res.status(404).json({ message: "service_not_found" });
        }
        const requests =
          req.decoded.id == foundStore.owner_id ? serviceCondidatesNumber : -1;

        return {
          id: row.id,
          user: userFound,
          provider: providerFound,
          date: row.createdAt,
          service: {
            id: serviceFound.id,
            price: serviceFound.price,
            name: serviceFound.name,
            description: serviceFound.description,
            store_id: serviceFound.store_id,
            category_id: serviceFound.category_id,
            gallerys: serviceGallerys.length == 0 ? [] : serviceGallerys,
            isFavorite: false,
            owner,
            requests,
          },
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          serviceGallerys,
          dueDate: row.dueDate,
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

exports.updateServiceStatus = async (req, res) => {
  try {
    let reservationFound = await Reservation.findByPk(req.body.reservation.id);
    if (!reservationFound) {
      return res.status(404).json({ message: "reservation_not_found" });
    }
    if (!req.body.status) {
      return res.status(400).json({ message: "missing" });
    }

    reservationFound.status = req.body.status;
    reservationFound.save();

    const transactions = await Transaction.findAll({
      where: {
        user_id: reservationFound.user_id,
        service_id: reservationFound.service_id,
      },
    });
    // Send a notification to the seeker regarding the new status
    switch (req.body.status) {
      case "confirmed":
        for (let index = 0; index < transactions.length; index++) {
          const element = transactions[index];
          element.status = "completed";
          element.save();
        }
        notificationService.sendNotification(
          reservationFound.provider_id,
          "notifications.reservation_confirmed",
          "notifications.owner_confirmed_reservation",
          NotificationType.BOOKING,
          {
            reservationId: reservationFound.id,
            serviceId: reservationFound.service_id,
          }
        );
        checkReferralActiveUserRewards(reservationFound.user_id);
        break;
      case "rejected":
        for (let index = 0; index < transactions.length; index++) {
          const element = transactions[index];
          element.status = "refunded";
          element.save();
          if (!element.coin_pack_id) {
            const userFound = await User.findByPk(reservationFound.user_id);
            userFound.availableCoins += element.coins;
            userFound.save();
          }
        }
        notificationService.sendNotification(
          reservationFound.provider_id,
          "notifications.reservation_rejected",
          "notifications.owner_rejected_reservation",
          NotificationType.BOOKING,
          {
            reservationId: reservationFound.id,
            serviceId: reservationFound.service_id,
          }
        );
        break;
      case "finished":
        const contract = await Contract.findOne({
          where: { reservation_id: reservationFound.id },
        });
        if (contract.isSigned && contract.isPayed) {
          await BalanceTransaction.create({
            userId: contract.provider_id,
            amount: contract.finalPrice,
            type: "taskEarnings",
            status: "pending",
            description: `Earnings for contract ${contract.id}`,
          });
          const serviceOwner = await getServiceOwner(
            reservationFound.service_id
          );
          notificationService.sendNotification(
            serviceOwner.id,
            "notifications.service_finished",
            "notifications.seeker_finished_reservation",
            NotificationType.BOOKING,
            {
              reservationId: reservationFound.id,
              serviceId: reservationFound.service_id,
              isOwner: true,
            }
          );
        }
        break;
      default:
    }

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

async function payFinishedReservations() {
  const twelveHoursAgo = new Date(new Date() - 12 * 60 * 60 * 1000);
  const reservations = await Reservation.findAll({
    where: {
      status: "finished",
      updatedAt: {
        [Op.gte]: twelveHoursAgo,
      },
    },
  });
  for (const reservation of reservations) {
    const contract = await Contract.findOne({
      where: { reservation_id: reservation.id },
    });
    // TODO check if a support ticket is submitted, if so block the earnings
    if (contract.isSigned && contract.isPayed) {
      const transaction = await BalanceTransaction.findOne({
        where: {
          type: "taskEarnings",
          status: "pending",
          description: {
            [Op.like]: `%${contract.id}%`,
          },
        },
      });
      // send the provider's earnings to his balance
      if (transaction) {
        const provider = await User.findByPk(reservation.user_id);
        provider.balance += contract.finalPrice;
        provider.save();
        transaction.status = "completed";
        transaction.save();
      }
    }
  }
}

cron.schedule("0 9,21 * * *", () => {
  console.log("Running cron job to pay finished reservations");
  payFinishedReservations();
});
