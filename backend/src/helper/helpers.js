// const xml2js = require("xml2js");
const path = require("path");
const { prefixPatterns } = require("../helper/constants");
const jwt = require("jsonwebtoken");
const { Task } = require("../models/task_model");
const { Reservation } = require("../models/reservation_model");
const { Service } = require("../models/service_model");
const { User } = require("../models/user_model");
const { sequelize } = require("../../db.config");
const { Op, Sequelize } = require("sequelize");
const { Transaction } = require("../models/transaction_model");
const { CoinPack } = require("../models/coin_pack_model");
const { CoinPackPurchase } = require("../models/coin_pack_purchase_model");
const { Referral } = require("../models/referral_model");
const {
  notificationService,
  NotificationType,
} = require("./notification_service");

function adjustString(inputString) {
  const ext = path.extname(inputString).toLowerCase();
  if (
    ![
      ".jpg",
      ".jpeg",
      ".png",
      ".gif",
      ".webp",
      ".pdf",
      ".doc",
      ".docx",
    ].includes(ext)
  ) {
    const error = new Error("Extension not allowed");
    error.status = 415;
    return cb(error);
  }

  let sanitizedString = inputString.toLowerCase();
  // Remove the provided extension if it exists at the end of the string
  if (sanitizedString.endsWith(ext.toLowerCase())) {
    sanitizedString = sanitizedString.slice(0, -ext.length);
  }
  // Remove special characters and spaces
  sanitizedString = sanitizedString.replace(/[^\w\s]/gi, ""); // Remove special characters
  sanitizedString = sanitizedString.replace(/\s+/g, ""); // Remove spaces

  return sanitizedString;
}

function isUUID(str) {
  const uuidRegex =
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return uuidRegex.test(str);
}

async function verifyToken(token) {
  let checkBearer = "Bearer ";
  if (token.startsWith(checkBearer)) {
    token = token.slice(checkBearer.length, token.length);
  }

  return await new Promise((resolve, reject) => {
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        console.error(`Error in verifyToken: ${err}`);
        reject(err);
      } else {
        resolve(decoded);
      }
    });
  });
}

function addAuthentication(body, targetProperty) {
  const targetObject = body[targetProperty];

  const authentication = {
    UserName: process.env.RENTALS_UNITED_LOGIN,
    Password: process.env.RENTALS_UNITED_PASS,
  };
  targetObject.Authentication = authentication;

  return body;
}

async function getTaskCondidatesNumber(taskId) {
  let taskFound = await Task.findByPk(taskId);
  if (!taskFound) {
    return "task_not_found";
  }
  let confirmedReservation = await Reservation.findOne({
    where: {
      task_id: taskId,
      status: "confirmed",
    },
  });
  let finishedReservation = await Reservation.findOne({
    where: {
      task_id: taskId,
      status: "finished",
    },
  });
  if (confirmedReservation || finishedReservation) {
    return -1;
  } else {
    let reservationList = await Reservation.findAll({
      where: {
        task_id: taskFound.id,
        status: "pending",
      },
    });

    return reservationList.length;
  }
}

async function getServiceCondidatesNumber(serviceId) {
  let serviceFound = await Service.findByPk(serviceId);
  if (!serviceFound) {
    return "service_not_found";
  }
  let bookingList = await Reservation.findAll({
    where: {
      service_id: serviceFound.id,
      [Op.or]: [{ status: "pending" }, { status: "confirmed" }],
    },
  });

  return bookingList.length;
}

async function checkStoreFavorite(store, currentUserId) {
  let userFavorites = [];
  if (!currentUserId) return false;
  const userFound = await User.findByPk(currentUserId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  } else {
    const query = `
    SELECT store_id
    FROM favorite_store
    WHERE user_id = :userId
  `;
    userFavorites = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: { userId: currentUserId },
    });
  }
  return userFavorites.length > 0
    ? userFavorites.some((e) => e.store_id == store.id)
    : false;
}

function getFullTimeDate() {
  var d = new Date();
  var date_format_str =
    d.getFullYear().toString() +
    "-" +
    ((d.getMonth() + 1).toString().length == 2
      ? (d.getMonth() + 1).toString()
      : "0" + (d.getMonth() + 1).toString()) +
    "-" +
    (d.getDate().toString().length == 2
      ? d.getDate().toString()
      : "0" + d.getDate().toString()) +
    " " +
    (d.getHours().toString().length == 2
      ? d.getHours().toString()
      : "0" + d.getHours().toString()) +
    ":" +
    (d.getMinutes().toString().length == 2
      ? d.getMinutes().toString()
      : "0" + d.getMinutes().toString()) +
    ":" +
    (d.getSeconds().toString().length == 2
      ? d.getSeconds().toString()
      : "0" + d.getSeconds().toString());
  return date_format_str;
}

function getDate(num = 0, unit = "days", operator = "+", dateString = "") {
  if (dateString) {
    if (!/\d{4}-\d{2}-\d{2}/.test(dateString)) {
      throw new Error('Invalid date format. Use "YYYY-MM-DD".');
    }
  }

  // Handle operator validation and calculation as before:

  // Use today's date if no dateString is provided:
  const date = dateString ? new Date(dateString) : new Date();

  if (unit === "days") {
    date.setDate(date.getDate() + (operator === "+" ? num : -num));
  } else if (unit === "months") {
    date.setMonth(date.getMonth() + (operator === "+" ? num : -num));
  } else if (unit === "years") {
    date.setFullYear(date.getFullYear() + (operator === "+" ? num : -num));
  } else {
    throw new Error('Invalid unit. Use "days", "months", or "years".');
  }

  const formattedDate = date.toISOString().slice(0, 10);
  return formattedDate;
}

function getIdLanguage(locale) {
  return locale === "en" ? 1 : locale === "fr" ? 4 : locale === "es" ? 5 : 4;
}

function calculateDateDifference(
  date1Str,
  date2Str,
  unit = "days",
  isAbs = true
) {
  const date1 = new Date(date1Str);
  const date2 = new Date(date2Str);

  if (isNaN(date1.getTime()) || isNaN(date2.getTime())) {
    throw new Error("Invalid date format. Please use YYYY-MM-DD.");
  }

  const differenceInMilliseconds = isAbs
    ? Math.abs(date2.getTime() - date1.getTime())
    : date2.getTime() - date1.getTime();

  switch (unit) {
    case "secondes":
      return Math.round(differenceInMilliseconds / 1000);
    case "minutes":
      return Math.round(differenceInMilliseconds / (1000 * 60));
    case "hours":
      return Math.round(differenceInMilliseconds / (1000 * 60 * 60));
    case "days":
      return Math.round(differenceInMilliseconds / (1000 * 60 * 60 * 24));
    case "weeks":
      return Math.round(differenceInMilliseconds / (1000 * 60 * 60 * 24 * 7));
    case "months":
      const monthDifference =
        date2.getFullYear() * 12 +
        date2.getMonth() -
        (date1.getFullYear() * 12 + date1.getMonth());
      return monthDifference;
    case "years":
      return date2.getFullYear() - date1.getFullYear();
    default:
      throw new Error(
        "Invalid unit. Use 'seconds', 'minutes', 'hours', 'days', 'weeks', 'months', or 'years'."
      );
  }
}
async function updateRoleUser(role, user, add = true, transaction = null) {
  const correctedString = user.role.replace(/(\w+)/g, '"$1"');
  const rolesArray = JSON.parse(correctedString);

  // Add or remove the role based on the 'add' parameter
  if (add) {
    // Only add if the role isn't already present
    if (!rolesArray.includes(role)) {
      rolesArray.push(role);
    }
  } else {
    // Remove the role; filter out the role from the array
    const index = rolesArray.indexOf(role);
    if (index > -1) {
      rolesArray.splice(index, 1);
    }
  }

  // Convert the updated array back to a string
  user.role = JSON.stringify(rolesArray).replace(/"/g, "");

  // Save the updated user with transaction if provided
  await user.save({ transaction });
}

function correctString(dataString, removeWhiteSpace = true) {
  // First, add quotes around keys and remove whitespace
  let keysCorrected;
  if (removeWhiteSpace) {
    keysCorrected = dataString.replace(/\s*(\w+)\s*:/g, '"$1":');
  } else {
    keysCorrected = dataString;
  }

  // Next, add quotes around values that are not already quoted, not numerical, and remove whitespace
  // This regex targets values after the colon that aren't wrapped in quotes or don't start with a number
  const fullyCorrected = keysCorrected.replace(
    /:\s*([^"\d\[\{][^,}\]]*)/g,
    ': "$1"'
  );

  // Remove any remaining whitespace
  const noWhiteSpace = fullyCorrected.replace(/\s/g, "");

  return JSON.parse(noWhiteSpace);
}
function transformStringToJson(dataString) {
  // Add double quotes around keys
  const keysCorrected = dataString.replace(/([A-Za-z]+):/g, '"$1":');

  // Correct non-quoted values that should be strings and arrays
  const valuesCorrected = keysCorrected.replace(
    /:\s*\[([^"\]]+)\]/g,
    (match, p1) => {
      // Split multiple items inside brackets if needed (not needed for your example, but useful for flexibility)
      const items = p1.split(",").map((item) => item.trim());
      const quotedItems = items.map((item) => `"${item}"`);
      return `: [${quotedItems.join(", ")}]`;
    }
  );

  // Convert the corrected JSON string to a JSON object
  return JSON.parse(valuesCorrected);
}

function removeSpacesFromPhoneNumber(phoneNumber) {
  if (!phoneNumber) {
    return phoneNumber; // Return as is if phoneNumber is undefined, null, or falsy
  }
  return phoneNumber.replace(/\s/g, "");
}

function verifyPhoneNumber(phoneNumber) {
  // Define a list of prefixes and their corresponding patterns
  const prefixPatternsValidation = prefixPatterns;

  // Iterate through the list of prefix patterns
  for (let i = 0; i < prefixPatternsValidation.length; i++) {
    const { prefix, pattern } = prefixPatterns[i];
    if (phoneNumber.startsWith(prefix) && pattern.test(phoneNumber)) {
      return true; // Phone number matches the prefix pattern
    }
  }

  return false; // Phone number doesn't match any of the specified prefixes
}

function checkUnitDinar(montant) {
  // Vérifier si le montant est en dinars (cherche les points ou virgules suivis de 1 à 3 chiffres)
  const regexDinars = /\d{1,3}([.,]\d{1,3})?$/;
  if (regexDinars.test(montant)) {
    return Math.round(montant * 1000); //DT
  } else {
    const regexMillimes = /^\d+$/;
    if (regexMillimes.test(montant)) {
      return parseInt(montant); // MILLIME
    }
  }
  return null;
}

async function createOrUpdateEntity(
  Model,
  entity,
  condition,
  transaction = null
) {
  try {
    const existingEntity = await Model.findOne({
      where: condition ? condition : { id: entity.id },
      transaction, // Pass the transaction if provided
    });
    if (existingEntity) {
      return await existingEntity.update(entity, { transaction }); // Pass the transaction if provided
    } else {
      return await Model.create(entity, { transaction }); // Pass the transaction if provided
    }
  } catch (error) {
    console.error("create or update entity problem", error);
    throw error; // Re-throw the error to handle it outside
  }
}

function isDate(str) {
  const datePattern = /\b\d{4}-\d{2}-\d{2}\b/;
  return datePattern.test(str);
}

function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
}

async function generateJWT(response, isRefresh) {
  const availablePurchasedCoins = await calculateAvailablePurchasedCoins(
    response.id
  );
  return (token = jwt.sign(
    {
      id: response.id,
      picture: response.picture,
      name: response.name,
      role: response.role,
      balance: response.balance,
      coins: response.coins,
      availableCoins: response.availableCoins,
      referral_code: response.referral_code,
      availablePurchasedCoins: availablePurchasedCoins,
      governorate_id: response.governorate_id,
      isVerified: response.isVerified,
      isMailVerified: response.isMailVerified,
      hasSharedPosition: response.hasSharedPosition,
      isArchived: response.isArchived,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: isRefresh
        ? process.env.JWT_REFRESH_EXPIRATION
        : process.env.JWT_EXPIRATION,
    }
  ));
}

// async function calculateCouponIfExist(coupon, finalPrice, idProperty) {
//   let message = null;
//   let priceAfterCoupon = null;
//   const couponFound = await Coupon.findOne({
//     where: { name: coupon },
//   });

//   if (couponFound) {
//     const excludedProperty = couponFound.exclude
//       ? couponFound.exclude.split(",")
//       : null;
//     const includeProperty = couponFound.include
//       ? couponFound.include.split(",")
//       : null;

//     if (excludedProperty && excludedProperty.includes(idProperty)) {
//       message = "coupon_house";
//     } else if (includeProperty && !includeProperty.includes(idProperty)) {
//       message = "coupon_house";
//     } else {
//       const daysDiff = calculateDateDifference(
//         getDate(),
//         couponFound.dateTo,
//         "days",
//         false
//       );

//       if (daysDiff < 0 || !couponFound.active) {
//         message = "coupon_expired";
//       } else {
//         couponPrice = -(finalPrice * couponFound.percentage);
//         priceAfterCoupon = finalPrice + couponPrice;
//       }
//     }
//   } else {
//     message = "invalid_expired";
//   }

//   return { message, priceAfterCoupon };
// }

function percentageFormatted(percentage) {
  return percentage > 1 ? percentage / 100 : percentage;
}

function getFileType(file) {
  const ext = path.extname(file.originalname).toLowerCase();
  if ([".jpg", ".jpeg", ".png", ".gif", ".webp"].includes(ext)) {
    return "image";
  } else {
    return "file";
  }
}

function fromCoordinateToDouble(coordinates) {
  let coordinatesObj = {};
  if (typeof coordinates === "string") {
    try {
      coordinatesObj = JSON.parse(coordinates);
    } catch (error) {
      console.error("Error parsing coordinates JSON:", error);
    }
  } else if (typeof coordinates === "object") {
    coordinatesObj = coordinates;
  }

  // Extract latitude and longitude
  const latitude = coordinatesObj.Latitude?.[0] || 0;
  const longitude = coordinatesObj.Longitude?.[0] || 0;
  return { latitude, longitude };
}

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0"); // getMonth() is zero-based, so add 1
  const day = String(date.getDate()).padStart(2, "0"); // pad single digits with 0

  return `${year}-${month}-${day}`;
}

function calculateTaskCoinsPrice(taskPrice) {
  const baseCoins = 5;
  const basePriceThreshold = 50;

  if (taskPrice <= basePriceThreshold) {
    return baseCoins;
  }

  const additionalCoins = Math.ceil(
    Math.max(0, taskPrice - basePriceThreshold) / basePriceThreshold
  );
  return baseCoins + additionalCoins;
}

async function calculateAvailablePurchasedCoins(userId) {
  let available = 0;
  const transactions = await Transaction.findAll({
    where: {
      user_id: userId,
    },
    include: [
      {
        model: CoinPackPurchase,
        required: true,
        include: [
          { model: CoinPack, where: { validMonths: { [Op.ne]: null } } },
        ],
      },
    ],
  });
  const now = new Date();
  const purchaseTransactions = transactions
    .filter((transaction) => {
      const { validMonths } = transaction.coin_pack_purchase.coin_pack;
      const expirationDate = new Date(transaction.createdAt);
      expirationDate.setMonth(expirationDate.getMonth() + validMonths);
      return expirationDate >= now;
    })
    .sort((a, b) => {
      const aExpirationDate = new Date(a.createdAt);
      const bExpirationDate = new Date(b.createdAt);
      aExpirationDate.setMonth(
        aExpirationDate.getMonth() + a.coin_pack_purchase.coin_pack.validMonths
      );
      bExpirationDate.setMonth(
        bExpirationDate.getMonth() + b.coin_pack_purchase.coin_pack.validMonths
      );
      return aExpirationDate - bExpirationDate;
    });

  for (let index = 0; index < purchaseTransactions.length; index++) {
    const transaction = purchaseTransactions[index];
    if (transaction.type === "purchase") {
      available += transaction.coins;
    } else if (
      (transaction.type === "proposal" && transaction.status !== "refunded") ||
      transaction.type === "request"
    ) {
      available -= transaction.coins;
    }
  }
  return available;
}

async function fetchPurchasedCoinsTransactions(userId) {
  const transactions = await Transaction.findAll({
    where: {
      user_id: userId,
      type: "purchase",
    },
    include: [
      {
        model: CoinPackPurchase,
        required: true,
        include: [
          { model: CoinPack, where: { validMonths: { [Op.ne]: null } } },
        ],
      },
    ],
  });
  const now = new Date();
  const purchaseTransactions = transactions
    .filter((transaction) => {
      const { validMonths } = transaction.coin_pack_purchase.coin_pack;
      const expirationDate = new Date(transaction.createdAt);
      expirationDate.setMonth(expirationDate.getMonth() + validMonths);
      return expirationDate >= now;
    })
    .sort((a, b) => {
      const aExpirationDate = new Date(a.createdAt);
      const bExpirationDate = new Date(b.createdAt);
      aExpirationDate.setMonth(
        aExpirationDate.getMonth() + a.coin_pack_purchase.coin_pack.validMonths
      );
      bExpirationDate.setMonth(
        bExpirationDate.getMonth() + b.coin_pack_purchase.coin_pack.validMonths
      );
      return aExpirationDate - bExpirationDate;
    });
  const calculateAvailable = await Promise.all(
    purchaseTransactions.map(async (row) => {
      let available = 0;
      const coinPackTransactions = await Transaction.findAll({
        where: {
          user_id: userId,
          coin_pack_id: row.coin_pack_id,
        },
        include: [
          {
            model: CoinPackPurchase,
            required: true,
            include: [
              {
                model: CoinPack,
                required: true,
                where: {
                  validMonths: { [Op.ne]: null }, // Ensure CoinPack has a validMonths field
                },
              },
            ],
          },
        ],
      });

      for (let index = 0; index < coinPackTransactions.length; index++) {
        const transaction = coinPackTransactions[index];
        if (transaction.type === "purchase") {
          available += transaction.coins;
        } else if (
          (transaction.type === "proposal" &&
            transaction.status !== "refunded") ||
          transaction.type === "request"
        ) {
          available -= transaction.coins;
        }
      }
      return {
        id: row.id,
        coins: row.coins,
        type: row.type,
        status: row.status,
        coin_pack_id: row.coin_pack_id,
        coin_pack_purchase: row.coin_pack_purchase,
        service_id: row.service_id,
        task_id: row.task_id,
        createdAt: row.createdAt,
        available: available,
      };
    })
  );

  return calculateAvailable;
}

async function generateUniqueReferralCode() {
  const codeLength = 14;
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let referralCode = "";
  let unique = false;

  while (!unique) {
    for (let i = 0; i < codeLength; i++) {
      const randomIndex = Math.floor(Math.random() * characters.length);
      referralCode += characters[randomIndex];
    }
    const user = await User.findOne({ where: { referral_code: referralCode } });
    if (!user) unique = true;
  }

  return referralCode;
}

async function checkReferralActiveUserRewards(userId) {
  const referee = await User.findByPk(userId);
  if (referee) {
    const completedTransactions = await Transaction.findAll({
      where: {
        [Op.or]: [{ type: "proposal" }, { type: "request" }],
        status: "completed",
        user_id: referee.id,
      },
    });
    if (completedTransactions.length > 0) {
      const referral = await Referral.findOne({
        where: { referred_user_id: referee.id },
      });
      if (referral && referral.reward_coins != 10) {
        const referrer = await User.findByPk(referral.referrer_id);
        referral.update({
          reward_coins: 10,
          transaction_date: new Date(),
          status: "activated",
        });
        referrer.coins += 5;
        referrer.availableCoins += 5;
        referrer.save();
        notificationService.sendNotification(
          referrer.id,
          "🎉 You Earned a Referral Reward!",
          "Your friend completed their first transaction! You've earned more base coins. Keep referring and keep earning!",
          NotificationType.REWARDS,
          { baseCoins: referrer.coins }
        );
      }
    }
  }
}

module.exports = {
  fromCoordinateToDouble,
  checkUnitDinar,
  percentageFormatted,
  addAuthentication,
  getDate,
  calculateDateDifference,
  verifyPhoneNumber,
  isDate,
  createOrUpdateEntity,
  removeSpacesFromPhoneNumber,
  getFullTimeDate,
  generateJWT,
  getIdLanguage,
  updateRoleUser,
  correctString,
  transformStringToJson,
  getFileType,
  getTaskCondidatesNumber,
  getServiceCondidatesNumber,
  checkStoreFavorite,
  adjustString,
  shuffleArray,
  isUUID,
  formatDate,
  calculateTaskCoinsPrice,
  calculateAvailablePurchasedCoins,
  fetchPurchasedCoinsTransactions,
  generateUniqueReferralCode,
  checkReferralActiveUserRewards,
  verifyToken,
};
