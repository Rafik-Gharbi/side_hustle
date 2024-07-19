// const xml2js = require("xml2js");
const path = require("path");
const { prefixPatterns } = require("../helper/constants");
const jwt = require("jsonwebtoken");

function addAuthentication(body, targetProperty) {
  const targetObject = body[targetProperty];

  const authentication = {
    UserName: process.env.RENTALS_UNITED_LOGIN,
    Password: process.env.RENTALS_UNITED_PASS,
  };
  targetObject.Authentication = authentication;

  return body;
}
// function convertJsonToXml(jsonObj, root = "root") {
//   const builder = new xml2js.Builder({ headless: true });

//   const xml = builder.buildObject(jsonObj, root);
//   return xml;
// }
// function convertXmlToJson(xmlData) {
//   const parser = new xml2js.Parser();
//   return new Promise((resolve, reject) => {
//     parser.parseString(xmlData, (err, jsonData) => {
//       if (err) {
//         reject(err);
//       } else {
//         resolve(jsonData);
//       }
//     });
//   });
// }

// async function getRentalsResponse(body, xmlRoot) {
//   const xmlData = convertJsonToXml(body, xmlRoot);
//   const responseRentalsXml = await axios.post(
//     process.env.RENTALS_UNITED_LINK,
//     xmlData
//   );
//   return await convertXmlToJson(responseRentalsXml.data);
// }
// async function getDetailedProperties(propertyList) {
//   const listDetailProperties = [];
//   const listPropAmenity = [];
//   const listRoomProp = [];
//   const listImageProperty = [];
//   const listPaiementProperty = [];
//   const listDescriptionProperty = [];
//   const listPriceProperty = [];

//   for (const [index, property] of propertyList.entries()) {
//     const ID = property.id;
//     if (index % 25 == 0)
//       console.log(`${index} property treated out of ${propertyList.length}`);

//     const body = {
//       Pull_ListSpecProp_RQ: {
//         Authentication: {
//           UserName: process.env.RENTALS_UNITED_LOGIN,
//           Password: process.env.RENTALS_UNITED_PASS,
//         },
//         PropertyID: ID,
//       },
//     };
//     const bodyPrice = {
//       Pull_ListPropertyPrices_RQ: {
//         Authentication: {
//           UserName: process.env.RENTALS_UNITED_LOGIN,
//           Password: process.env.RENTALS_UNITED_PASS,
//         },
//         PropertyID: ID,
//         DateFrom: getDate(0, "years"),
//         DateTo: getDate(1, "years"),
//       },
//     };

//     try {
//       const jsonResult = await getRentalsResponse(body, "Pull_ListSpecProp_RQ");
//       const mappedProperties = jsonResult.Pull_ListSpecProp_RS.Property.map(
//         (property) => {
//           const cleaningPrice = property.CleaningPrice[0];
//           const additionalFees =
//             property.AdditionalFees?.[0]?.AdditionalFee?.[0]?.Value[0];
//           const finalCleaningPrice =
//             cleaningPrice === "0.0000" ? additionalFees || "0" : cleaningPrice;
//           return {
//             id: property.ID[0]["_"],
//             owner_id: 1,
//             name: property.Name[0],
//             location_id: property.DetailedLocationID[0]["_"],
//             last_modified: property.LastMod[0]["_"],
//             date_created: property.DateCreated[0],
//             cleaning_price: finalCleaningPrice,
//             space: property.Space[0],
//             standard_guests: property.StandardGuests[0],
//             can_sleep_max: property.CanSleepMax[0],
//             type_property_id: property.ObjectTypeID[0],
//             objectType_id: property.ObjectTypeID[0],
//             floor: property.Floor[0],
//             street: property.Street[0],
//             zip_code: property.ZipCode[0],
//             coordinates: property.Coordinates[0],
//             check_in_out: property.CheckInOut[0],
//             deposit_id: property.Deposit[0]["$"].DepositTypeID,
//             deposit_value: property.Deposit[0]["_"],
//             preparation_time_before_arrival:
//               property.ArrivalInstructions[0].DaysBeforeArrival[0],
//             preparation_time_before_arrival_in_hours:
//               property.CheckInOut[0].CheckInTo[0],
//             is_active: property.IsActive[0],
//             is_archived: property.IsArchived[0],
//             cancellation_policies:
//               property.CancellationPolicies[0].CancellationPolicy?.map(
//                 (cancellationPolicy) => ({
//                   value: cancellationPolicy["_"],
//                   validFrom: cancellationPolicy["$"].ValidFrom,
//                   validTo: cancellationPolicy["$"].ValidTo,
//                 })
//               ),
//           };
//         }
//       );

//       if (mappedProperties[0].is_active === "true") {
//         const jsonResultPrice = await getRentalsResponse(
//           bodyPrice,
//           "Pull_ListPropertyPrices_RQ"
//         );

//         const mappedAmenityPromises =
//           jsonResult.Pull_ListSpecProp_RS.Property[0].Amenities?.[0]?.Amenity?.map(
//             async (amenity) => {
//               const foundAmenity = await Amenity.findByPk(amenity["_"]);
//               if (
//                 foundAmenity &&
//                 foundAmenity.name_fr &&
//                 foundAmenity.name_es &&
//                 foundAmenity.name_ar
//               ) {
//                 return foundAmenity;
//               } else {
//                 const amenityName = rentalsAmenities.find(
//                   (item) => item.id == amenity["_"]
//                 ).name;
//                 const translations = {
//                   name_fr: await translateTo(amenityName, 4),
//                   name_es: await translateTo(amenityName, 5),
//                   name_ar: await translateTo(amenityName, 13),
//                 };

//                 return {
//                   id: amenity["_"],
//                   name: amenityName,
//                   ...translations,
//                 };
//               }
//             }
//           );

//         const mappedPriceProperty =
//           jsonResultPrice.Pull_ListPropertyPrices_RS.Prices?.[0]?.Season?.map(
//             (season) => ({
//               property_id: ID,
//               price: season.Price[0],
//               date_from: season["$"].DateFrom,
//               date_to: season["$"].DateTo,
//             })
//           );

//         const mappedPropAmenity =
//           jsonResult.Pull_ListSpecProp_RS.Property[0].Amenities?.[0]?.Amenity?.map(
//             (amenity) => ({
//               property_id: ID,
//               amenity_id: amenity["_"],
//               count: amenity["$"].Count,
//             })
//           );

//         const mappedPropRoom =
//           jsonResult.Pull_ListSpecProp_RS.Property[0].CompositionRoomsAmenities?.[0]?.CompositionRoomAmenities?.map(
//             (room) => ({
//               property_id: ID,
//               room_id: room["$"].CompositionRoomID,
//             })
//           );

//         const mappedImagePromises = await resizeImageFromRentals(
//           jsonResult.Pull_ListSpecProp_RS.Property[0].Images?.[0]?.Image,
//           ID
//         );

//         const mappedImagePropNullable = await Promise.all(mappedImagePromises);
//         const mappedImageProp = mappedImagePropNullable.filter(
//           (obj) => Object.keys(obj).length !== 0
//         );

//         const mappedPaiementProperty =
//           jsonResult.Pull_ListSpecProp_RS.Property[0].PaymentMethods?.[0]?.PaymentMethod?.map(
//             (paiement) => ({
//               property_id: ID,
//               payement_id: paiement["$"].PaymentMethodID,
//             })
//           );

//         const descriptionPromises =
//           jsonResult.Pull_ListSpecProp_RS.Property[0].Descriptions?.[0]?.Description?.map(
//             async (description) => {
//               // Fetch all existing descriptions for the property
//               const foundDescriptions = await getJoinTableProperty(
//                 ID,
//                 Description
//               );

//               // Check if the current description exists in the found descriptions
//               const existingDescription = foundDescriptions.find(
//                 (desc) =>
//                   desc.language_id === parseInt(description["$"].LanguageID)
//               );

//               // Determine whether to translate name and street
//               let nameTranslated, streetTranslated;
//               if (existingDescription) {
//                 // Use existing values if they are not null
//                 nameTranslated =
//                   existingDescription.name ||
//                   (await translateTo(
//                     mappedProperties[0].name,
//                     description["$"].LanguageID
//                   ));
//                 streetTranslated =
//                   existingDescription.street ||
//                   (await translateTo(
//                     mappedProperties[0].street,
//                     description["$"].LanguageID
//                   ));
//               } else {
//                 // Translate if no existing description is found
//                 nameTranslated = await translateTo(
//                   mappedProperties[0].name,
//                   description["$"].LanguageID
//                 );
//                 streetTranslated = await translateTo(
//                   mappedProperties[0].street,
//                   description["$"].LanguageID
//                 );
//               }

//               return {
//                 property_id: ID,
//                 name: nameTranslated,
//                 street: streetTranslated,
//                 language_id: description["$"].LanguageID,
//                 text: description.Text[0],
//                 house_rules:
//                   description?.HouseRules != null
//                     ? description.HouseRules[0]
//                     : "",
//               };
//             }
//           );

//         const mappedDescription = await Promise.all(descriptionPromises);

//         const mappedAmenities = await Promise.all(mappedAmenityPromises);
//         const filteredAmenities = mappedAmenities.filter(
//           (amenity) => amenity !== null
//         );

//         if (filteredAmenities.length > 0) {
//           for (const amenity of filteredAmenities) {
//             await createOrUpdateEntity(Amenity, amenity);
//           }
//         }
//         if (mappedPropAmenity) listPropAmenity.push(mappedPropAmenity);
//         if (mappedPropRoom) listRoomProp.push(mappedPropRoom);
//         if (mappedProperties) listDetailProperties.push(mappedProperties[0]);
//         if (mappedImageProp) listImageProperty.push(mappedImageProp);
//         if (mappedPaiementProperty)
//           listPaiementProperty.push(mappedPaiementProperty);
//         if (mappedDescription) listDescriptionProperty.push(mappedDescription);
//         if (mappedPriceProperty) listPriceProperty.push(mappedPriceProperty);
//       }
//     } catch (error) {
//       console.error(`Error fetching details for property ${ID}`, error);
//     }
//   }
//   return {
//     listDetailProperties,
//     listPropAmenity,
//     listRoomProp,
//     listImageProperty,
//     listPaiementProperty,
//     listDescriptionProperty,
//     listPriceProperty,
//   };
// }

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

// function resizeImageFromRentals(list, ID) {
//   // Directly filter images within the map function for conciseness

//   if (list)
//     return list.map(async (image, index) => {
//       const imageUrl = image["_"];
//       // Only process images matching the specified URL pattern
//       const imageName = `${ID}_${index}.jpg`;
//       try {
//         const founedProperty = await PropertyImage.findByPk(imageUrl);
//         if (!founedProperty) {
//           const imageBuffer = await downloadImage(imageUrl);
//           await saveImage(imageName, imageBuffer, "properties");
//           await saveImage(imageName, imageBuffer, "properties/hd", false);
//         }
//       } catch (error) {
//         return {};
//       }

//       return {
//         id: imageUrl,
//         url: imageName,
//         property_id: ID,
//         thumbnail: imageName,
//         type: image["$"].ImageTypeID,
//       };
//     });
// }

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

// async function getFeesAndDevise(idProperty) {
//   const foundLocation = await Property.findByPk(idProperty, {
//     include: [
//       {
//         model: Location,
//       },
//     ],
//   });
//   let fees;
//   let devise;

//   if (foundLocation && foundLocation.location) {
//     switch (foundLocation.location.timezone) {
//       case "Africa/Tunis":
//         fees = 5.95;
//         devise = 3.15;
//         break;
//       case "Europe/Paris":
//         fees = 15;
//         devise = 3.4;
//         break;
//       default:
//         if (foundLocation.location.parentLocationID) {
//           switch (foundLocation.location.parentLocationID) {
//             case 20:
//               fees = 15;
//               devise = 3.4;
//               break;
//             case 9502:
//               fees = 5.95;
//               devise = 3.15;
//               break;
//             default:
//               fees = 0;
//               break;
//           }
//         } else {
//           fees = 0;
//         }
//         break;
//     }
//   } else {
//     fees = 0;
//   }
//   return { fees, devise };
// }

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

const getOneMinuteBeforeMidnight = () => {
  const now = new Date();
  const endOfDay = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate(),
    23,
    59,
    0,
    0
  );
  return endOfDay;
};

function isDate(str) {
  const datePattern = /\b\d{4}-\d{2}-\d{2}\b/;
  return datePattern.test(str);
}
async function generateJWT(response, isRefresh) {
  return (token = jwt.sign(
    {
      id: response.id,
      picture: response.picture,
      name: response.name,
      role: response.role,
      isVerified: response.isVerified,
      isMailVerified: response.isMailVerified,
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

// Function to check properties existence and return their IDs
// const checkProperties = async (properties) => {
//   const checks = properties.map(async (property) => {
//     const foundProperty = await Property.findByPk(property.id);
//     return foundProperty ? property.id : null;
//   });
//   return (await Promise.all(checks)).filter((id) => id !== null);
// };

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

module.exports = {
  fromCoordinateToDouble,
  checkUnitDinar,
  percentageFormatted,
  addAuthentication,
  // convertJsonToXml,
  // convertXmlToJson,
  // getDetailedProperties,
  getDate,
  calculateDateDifference,
  // getRentalsResponse,
  verifyPhoneNumber,
  // getFeesAndDevise,
  isDate,
  createOrUpdateEntity,
  removeSpacesFromPhoneNumber,
  getFullTimeDate,
  generateJWT,
  // calculateCouponIfExist,
  // checkProperties,
  getIdLanguage,
  updateRoleUser,
  correctString,
  transformStringToJson,
  getOneMinuteBeforeMidnight,
  getFileType,
};
