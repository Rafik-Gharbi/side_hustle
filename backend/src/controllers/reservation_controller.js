const {
  getRentalsResponse,
  getDate,
  checkUnitDinar,
} = require("../helper/helpers");
const { User } = require("../models/user_model");
const axios = require("axios");
const jwt = require("jsonwebtoken");
const { encryptData } = require("../helper/encryption");
const {
  emailReservationForCheckin,
  sendNotificationReservation,
} = require("../views/template_email");
const { fetchNames, getImageByPropertyId } = require("../sql/sql_request");
const { constantId } = require("../helper/constants");
const { sendMail } = require("../helper/email_service");
exports.add = async (req, res) => {
  const { propertyId, dateFrom, dateTo, guests, totalPrice, ruPrice, coupon } =
    req.body;
  if (
    !propertyId ||
    !dateFrom ||
    !dateTo ||
    !guests ||
    !totalPrice ||
    !ruPrice
  ) {
    return res.status(400).json({ message: "missing_element" });
  }
  try {
    let clientFound = await User.findByPk(req.decoded.id);
    let foundProperty = await Property.findByPk(propertyId);
    const body = {
      Push_PutConfirmedReservationMulti_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        Reservation: {
          StayInfos: {
            StayInfo: {
              PropertyID: propertyId,
              DateFrom: dateFrom,
              DateTo: dateTo,
              NumberOfGuests: guests,
              Costs: {
                RUPrice: ruPrice,
                UserPrice: totalPrice,
              },
            },
          },
          //   CancellationPolicyInfo: {
          //     PolicyText:
          //       "Full refund until 11 days before arrival. 50% charge from 4 to 10 days before arrival. 100% charge from 0 to 3 days before arrival.",
          //     CancellationPolicies: {
          //       CancellationPolicy: [
          //         {
          //           _ValidFrom: "0",
          //           _ValidTo: "3",
          //           __text: "100",
          //         },
          //         {
          //           _ValidFrom: "4",
          //           _ValidTo: "10",
          //           __text: "50",
          //         },
          //       ],
          //     },
          //   },
          CustomerInfo: {
            Name: clientFound.name ?? clientFound.id.toString(),
            SurName: clientFound.name ?? clientFound.id.toString(),
            Email: clientFound.email ?? clientFound.id.toString(),
            Phone: clientFound.phone_number,
            // SkypeID: "test.test",
            Address: "Street 1/2",
            // ZipCode: "00-000",
            LanguageID: "1",
            CountryID: "42",
          },
          //   GuestDetailsInfo: {
          //     NumberOfAdults: "2",
          //     NumberOfChildren: "2",
          //     NumberOfInfants: "3",
          //   },
        },
      },
    };

    var jsonResult = await getRentalsResponse(
      body,
      "Push_PutConfirmedReservationMulti_RQ"
    );
    if (
      jsonResult.Push_PutConfirmedReservationMulti_RS.Status[0]["_"] !=
      "Success"
    ) {
      return res.status(400).json({
        message: jsonResult.Push_PutConfirmedReservationMulti_RS.Status[0]["_"],
      });
    } else {
      const reservation = await ReservationHistory.create({
        id: jsonResult.Push_PutConfirmedReservationMulti_RS.ReservationID[0],
        date_from: dateFrom,
        date_to: dateTo,
        property_id: propertyId,
        client_id: clientFound.id,
        ru_price: ruPrice,
        client_price: totalPrice,
      });
      const templateUser = emailReservationForCheckin(foundProperty.name);

      const templateLandlord = sendNotificationReservation(
        reservation.date_from,
        reservation.date_to,
        foundProperty.name,
        reservation.property_id,
        reservation.client_price,
        reservation.id,
        clientFound.name ? clientFound.name : null,
        clientFound.phone_number ? clientFound.phone_number : null,
        clientFound.email
      );
      if (coupon) {
        const couponFound = await Coupon.findOne({
          where: {
            name: coupon,
          },
        });
        if (couponFound) {
          await CouponReservation.create({
            reservation_id: reservation.id,
            coupon_id: couponFound.id,
          });
        }
      }
      try {
        sendMail(
          clientFound.email,
          "Réservation confirmé",
          templateUser,
          req.host
        );
        sendMail(
          process.env.AUTH_USER_EMAIL,
          "Réservation confirmé",
          templateLandlord,
          req.host
        );
        sendMail(
          "reservations@thelandlord.tn",
          `Réservation confirmé`,
          templateLandlord,
          req.host
        );
        sendMail(
          "Sarah.benachour@thelandlord.tn",
          `Réservation confirmé`,
          templateLandlord,
          req.host
        );
      } catch (error) {
        console.error("\x1b[31m%s\x1b[0m", error);
      }

      return res.status(200).send(reservation);
    }
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
      propertyId,
      dateFrom,
      dateTo,
      guests,
      totalPrice,
      deviseName,
      ruPrice,
      id,
      coupon,
    } = req.body;
    if (!propertyId || !dateFrom || !dateTo || !guests || !totalPrice) {
      return res.status(400).json({ message: "missing_element" });
    }

    let clientFound = await User.findByPk(req.decoded.id);
    token = jwt.sign(
      {
        propertyId: propertyId,
        dateFrom: dateFrom,
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
      orderId: `${propertyId}-${id}-${getDate()}`,
      firstName: clientFound.name,
      lastName: clientFound.name,
      phoneNumber: clientFound.phone_number,
      email: clientFound.email,
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
    var listMapped = [];
    let clientFound = await User.findByPk(req.decoded.id);

    if (!clientFound) {
      return res.status(404).json({ message: "client_not_found" });
    }

    let reservationList = await ReservationHistory.findAll({
      where: {
        client_id: clientFound.id,
      },
    });

    let promises = reservationList.map(async (reservation) => {
      var body = {
        Pull_GetReservationByID_RQ: {
          Authentication: {
            UserName: process.env.RENTALS_UNITED_LOGIN,
            Password: process.env.RENTALS_UNITED_PASS,
          },
          ReservationID: reservation.id,
        },
      };

      var jsonResult = await getRentalsResponse(
        body,
        "Pull_GetReservationByID_RQ"
      );

      const reservationData =
        jsonResult.Pull_GetReservationByID_RS.Reservation[0]; // Assuming there's only one reservation

      const stayInfo = reservationData.StayInfos[0].StayInfo[0]; // Assuming there's only one StayInfo
      const costs = stayInfo.Costs[0]; // Assuming there's only one Costs object
      const [propertyName, images] = await Promise.all([
        fetchNames([stayInfo.PropertyID[0]], "property"),
        getImageByPropertyId(stayInfo.PropertyID[0]),
      ]);
      const statusId = reservationData.StatusID[0];

      const statusObject = constantId.ReservationStatus.find(
        (status) => status.id === statusId
      );

      const pricePaid = checkUnitDinar(
        String(parseFloat(costs.UserPrice[0]))
      );

      return {
        reservationId: reservationData.ReservationID[0],
        status: statusObject ? statusObject.value : "Unknown",
        propertyId: stayInfo.PropertyID[0],
        dateFrom: stayInfo.DateFrom[0],
        dateTo: stayInfo.DateTo[0],
        numberOfGuests: stayInfo.NumberOfGuests[0],
        ruPrice: costs.RUPrice[0],
        clientPrice: String(pricePaid / 1000),
        images,
        propertyName: propertyName[0].name,
      };
    });

    listMapped = await Promise.all(promises);

    return res.status(200).json({ listMapped: listMapped.flat() });
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
