const {
  getDate,
  checkUnitDinar,
  getServiceCondidatesNumber,
} = require("../helper/helpers");
const { User } = require("../models/user_model");
const axios = require("axios");
const jwt = require("jsonwebtoken");
const { encryptData } = require("../helper/encryption");
const {
  emailReservationForCheckin,
  sendNotificationReservation,
} = require("../views/template_email");
const { sendMail } = require("../helper/email_service");
const { Service } = require("../models/service_model");
const { Booking } = require("../models/booking_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");
const { Store } = require("../models/store_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const { getServiceOwner, populateOneService } = require("../sql/sql_request");
const { Op } = require("sequelize");

exports.add = async (req, res) => {
  const { serviceId, date, totalPrice, coupon, status, note } = req.body;
  if (!serviceId || !date || !totalPrice || !status) {
    return res.status(400).json({ message: "missing" });
  }
  try {
    let userFound = await User.findByPk(req.decoded.id);
    let foundService = await Service.findByPk(serviceId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!foundService) {
      return res.status(404).json({ message: "service_not_found" });
    }
    let existBooking = await Booking.findOne({
      where: {
        user_id: userFound.id,
        service_id: serviceId,
        [Op.or]: [{ status: "pending" }, { status: "confirmed" }],
      },
    });
    if (existBooking) {
      return res.status(400).json({ message: "booking_already_exist" });
    }

    const booking = await Booking.create({
      date,
      service_id: serviceId,
      user_id: userFound.id,
      total_price: totalPrice,
      coupon,
      note,
      status,
    });
    // const templateUser = emailBookingForCheckin(foundService.name);

    // const templateLandlord = sendNotificationBooking(
    //   booking.date_from,
    //   booking.date_to,
    //   foundService.name,
    //   booking.service_id,
    //   booking.user_price,
    //   booking.id,
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
    //     await CouponBooking.create({
    //       booking_id: booking.id,
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

    // Send a notification for the service owner
    let store = await Store.findOne({ where: { id: foundService.store_id } });
    notificationService.sendNotification(
      store.owner_id,
      "You Have a New Booking",
      "Someone has booked a service in your store, check it out!",
      NotificationType.BOOKING,
      { storeId: store.id, serviceId: foundService.id, isOwner: true }
    );

    return res.status(200).json({ booking });
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
      serviceId,
      date,
      dateTo,
      guests,
      totalPrice,
      deviseName,
      ruPrice,
      id,
      coupon,
    } = req.body;
    if (!serviceId || !date || !dateTo || !guests || !totalPrice) {
      return res.status(400).json({ message: "missing_element" });
    }

    let userFound = await User.findByPk(req.decoded.id);
    token = jwt.sign(
      {
        serviceId: serviceId,
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
      orderId: `${serviceId}-${id}-${getDate()}`,
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

exports.listBooking = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let bookingList = await Booking.findAll({
      where: {
        user_id: userFound.id,
      },
    });
    const formattedList = await Promise.all(
      bookingList.map(async (row) => {
        let foundService = await Service.findByPk(row.service_id);
        let serviceGallerys = await ServiceGalleryModel.findAll({
          where: { service_id: row.service_id },
        });

        return {
          id: row.id,
          user: userFound,
          date: row.createdAt,
          service: foundService,
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          serviceGallerys,
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

exports.userServicesHistory = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    let bookingList = await Booking.findAll({
      where: {
        user_id: userFound.id,
      },
    });
    const formattedList = await Promise.all(
      bookingList.map(async (row) => {
        const foundService = await Service.findByPk(row.service_id);
        const populatedService = await populateOneService(foundService);
        let serviceGallerys = await ServiceGalleryModel.findAll({
          where: { service_id: row.service_id },
        });

        return {
          id: row.id,
          user: userFound,
          date: row.createdAt,
          service: populatedService,
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          serviceGallerys,
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

exports.getBookingByService = async (req, res) => {
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
    let bookingList = await Booking.findAll({
      where: {
        service_id: serviceFound.id,
      },
    });
    let serviceGallerys = await ServiceGalleryModel.findAll({
      where: { service_id: serviceFound.id },
    });

    const formattedList = await Promise.all(
      bookingList.map(async (row) => {
        let userFound = await User.findOne({
          where: { id: row.user_id },
        });
        const requests =
          req.decoded.id == foundStore.owner_id
            ? await getServiceCondidatesNumber(row.id)
            : -1;

        return {
          id: row.id,
          user: userFound,
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
            requests,
          },
          totalPrice: row.total_price,
          coupon: row.coupon,
          note: row.note,
          status: row.status,
          serviceGallerys,
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
    let bookingFound = await Booking.findByPk(req.body.booking.id);
    if (!bookingFound) {
      return res.status(404).json({ message: "booking_not_found" });
    }
    if (!req.body.status) {
      return res.status(400).json({ message: "missing" });
    }

    bookingFound.status = req.body.status;
    bookingFound.save();

    // Send a notification to the seeker regarding the new status
    switch (req.body.status) {
      case "confirmed":
        notificationService.sendNotification(
          bookingFound.user_id,
          "Your Booking Has Been Confirmed",
          "The service owner has confirmed your booking.",
          NotificationType.BOOKING,
          { bookingId: bookingFound.id, serviceId: bookingFound.service_id }
        );
        break;
      case "rejected":
        notificationService.sendNotification(
          bookingFound.user_id,
          "Your Booking Has Been Rejected",
          "The service owner has rejected your booking.",
          NotificationType.BOOKING,
          { bookingId: bookingFound.id, serviceId: bookingFound.service_id }
        );
        break;
      case "finished":
        const serviceOwner = await getServiceOwner(bookingFound.service_id);
        notificationService.sendNotification(
          serviceOwner.id,
          "Your Service Has Been Finished",
          "The service seeker has finished the booking. Good job!",
          NotificationType.BOOKING,
          { bookingId: bookingFound.id, serviceId: bookingFound.service_id, isOwner: true }
        );
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

exports.getCondidatesNumber = async (req, res) => {
  try {
    const condidates = await getServiceCondidatesNumber(req.query.serviceId);
    return res.status(200).json({ condidates });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getAllBooking = async (req, res) => {
  try {
    // const bookingList = await getBookingFiltered(req.query);
    // return res.status(200).json({ bookingList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
