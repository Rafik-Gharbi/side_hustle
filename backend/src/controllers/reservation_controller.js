const {
  getDate,
  checkUnitDinar,
  getTaskCondidatesNumber,
} = require("../helper/helpers");
const { User } = require("../models/user_model");
const axios = require("axios");
const jwt = require("jsonwebtoken");
const { encryptData } = require("../helper/encryption");
const {
  emailReservationForCheckin,
  sendNotificationReservation,
} = require("../views/template_email");
const { fetchNames, getImageByTaskId } = require("../sql/sql_request");
const { constantId } = require("../helper/constants");
const { sendMail } = require("../helper/email_service");
const { Task } = require("../models/task_model");
const { Reservation } = require("../models/reservation_model");
const { TaskAttachmentModel } = require("../models/task_attachment_model");

exports.add = async (req, res) => {
  const { taskId, date, totalPrice, coupon, status, note } = req.body;
  if (!taskId || !date || !totalPrice || !status) {
    return res.status(400).json({ message: "missing" });
  }
  try {
    let userFound = await User.findByPk(req.decoded.id);
    let foundTask = await Task.findByPk(taskId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!foundTask) {
      return res.status(404).json({ message: "task_not_found" });
    }
    let existReservation = await Reservation.findOne({
      where: {
        user_id: userFound.id,
        task_id: taskId,
      },
    });
    if (existReservation) {
      return res.status(400).json({ message: "reservation_already_exist" });
    }

    const reservation = await Reservation.create({
      date,
      task_id: taskId,
      user_id: userFound.id,
      total_price: totalPrice,
      coupon,
      note,
      status,
    });
    // const templateUser = emailReservationForCheckin(foundTask.name);

    // const templateLandlord = sendNotificationReservation(
    //   reservation.date_from,
    //   reservation.date_to,
    //   foundTask.name,
    //   reservation.task_id,
    //   reservation.user_price,
    //   reservation.id,
    //   userFound.name ? userFound.name : null,
    //   userFound.phone_number ? userFound.phone_number : null,
    //   userFound.email
    // );
    // if (coupon) {
    //   const couponFound = await Coupon.findOne({
    //     where: {
    //       name: coupon,
    //     },
    //   });
    //   if (couponFound) {
    //     await CouponReservation.create({
    //       reservation_id: reservation.id,
    //       coupon_id: couponFound.id,
    //     });
    //   }
    // }
    // try {
    //   sendMail(
    //     userFound.email,
    //     "Réservation confirmé",
    //     templateUser,
    //     req.host
    //   );
    //   sendMail(
    //     process.env.AUTH_USER_EMAIL,
    //     "Réservation confirmé",
    //     templateLandlord,
    //     req.host
    //   );
    // } catch (error) {
    //   console.error("\x1b[31m%s\x1b[0m", error);
    // }

    return res.status(200).json({ reservation });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.initPaiement = async (req, res) => {
  try {
    const {
      description,
      taskId,
      date,
      dateTo,
      guests,
      totalPrice,
      deviseName,
      ruPrice,
      id,
      coupon,
    } = req.body;
    if (!taskId || !date || !dateTo || !guests || !totalPrice) {
      return res.status(400).json({ message: "missing_element" });
    }

    let userFound = await User.findByPk(req.decoded.id);
    token = jwt.sign(
      {
        taskId: taskId,
        date: date,
        dateTo: dateTo,
        ruPrice: ruPrice,
        guests: guests,
        totalPrice: totalPrice,
        coupon: coupon,
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_RESERVATION_EXPIRATION }
    );
    const priceToPay = checkUnitDinar(totalPrice);
    if (!priceToPay) {
      return res.status(401).json({ message: "wrong_unit_money" });
    }
    const body = {
      receiverWalletId: process.env.KONNECT_WALLET_KEY,
      token: deviseName ? deviseName : "TND",
      amount: priceToPay,
      type: "immediate",
      description: description,
      acceptedPaymentMethods: ["wallet", "bank_card", "e-DINAR"],
      lifespan: 20,
      checkoutForm: false,
      addPaymentFeesToAmount: true,
      orderId: `${taskId}-${id}-${getDate()}`,
      firstName: userFound.name,
      lastName: userFound.name,
      phoneNumber: userFound.phone_number,
      email: userFound.email,
      silentWebhook: true,
      successUrl: `${
        process.env.LANDLORD_WEB
      }/payment-success?res=${encryptData(token)}`,
      failUrl: `${process.env.LANDLORD_WEB}/payment-failed`,
      theme: "light",
    };
    const responseKonnect = await axios.post(
      `${process.env.KONNECT_URL}/payments/init-payment`,
      body,
      {
        headers: {
          "x-api-key": process.env.KONNECT_API_KEY,
        },
      }
    );
    return res.status(200).json({
      refPaiement: responseKonnect.data.paymentRef,
      payUrl: responseKonnect.data.payUrl,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.listReservation = async (req, res) => {
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
        let foundTask = await Task.findByPk(row.task_id);
        let taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.task_id },
        });

        return {
          id: row.id,
          user: userFound,
          date: row.createdAt,
          task: foundTask,
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          taskAttachments,
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

exports.userTasksHistory = async (req, res) => {
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
        let foundTask = await Task.findByPk(row.task_id);
        let taskOwnerFound = await User.findByPk(foundTask.owner_id);
        let taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.task_id },
        });

        return {
          id: row.id,
          user: userFound,
          date: row.createdAt,
          task: {
            id: foundTask.id,
            price: foundTask.price,
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
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          taskAttachments,
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
    let taskOwnerFound = await User.findOne({
      where: { id: taskFound.owner_id },
    });
    let taskAttachments = await TaskAttachmentModel.findAll({
      where: { task_id: taskFound.id },
    });

    const formattedList = await Promise.all(
      reservationList.map(async (row) => {
        let userFound = await User.findOne({
          where: { id: row.user_id },
        });

        return {
          id: row.id,
          user: userFound,
          date: row.createdAt,
          task: {
            id: taskFound.id,
            price: taskFound.price,
            title: taskFound.title,
            description: taskFound.description,
            delivrables: taskFound.delivrables,
            governorate_id: taskFound.governorate_id,
            category_id: taskFound.category_id,
            owner: taskOwnerFound,
            attachments: taskAttachments.length == 0 ? [] : taskAttachments,
            isFavorite: false,
          },
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          taskAttachments,
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

exports.updateStatus = async (req, res) => {
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
        }
      });
    }

    reservationFound.status = req.body.status;
    reservationFound.save();
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getCondidatesNumber = async (req, res) => {
  try {
    const condidates = await getTaskCondidatesNumber(req.query.taskId);
    return res.status(200).json({ condidates });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getAllReservation = async (req, res) => {
  try {
    // const reservationList = await getReservationFiltered(req.query);
    // return res.status(200).json({ reservationList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};