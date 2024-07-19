// const sharp = require("sharp");
// const {
//   createOrUpdateEntity,
//   getDate,
//   updateRoleUser,
//   correctString,
//   getIdLanguage,
//   transformStringToJson,
//   generateJWT,
//   fromCoordinateToDouble,
// } = require("../helper/helpers");
// const { Client } = require("../models/user_model");
// const { Location } = require("../models/governorate_model");
// const { PropertyImage } = require("../models/property_image_model");
// const { Property } = require("../models/property_model");
// const { PropertyPrice } = require("../models/property_price_model");
// const { PropertyAmenity } = require("../models/property_amenity_model");
// const { PropertyRoom } = require("../models/property_room_model");
// const { PropertyPaiement } = require("../models/property_paiement_model");
// const { Description } = require("../models/description_model");
// const { sequelize } = require("../../db.config");
// const { getReverseLocation } = require("../helper/retanls_united");
// const { getAvgReviewAndCount } = require("../sql/sql_request");
// const { getJoinTableProperty } = require("../sql/property_sql");
// const { Amenity } = require("../models/amenity_model");
// const {
//   translateToAllLanguages,
//   translateTo,
//   languageMap,
// } = require("../helper/deeplL");

// exports.addProperty = async (req, res) => {
//   const transaction = await sequelize.transaction();

//   try {
//     const {
//       nameProperty,
//       street,
//       cleaning_price,
//       space,
//       standard_guests,
//       can_sleep_max,
//       zip_code,
//       floor,
//       preparation_time_before_arrival,
//       preparation_time_before_arrival_in_hours,
//       longitude,
//       latitude,
//       cancellation_policies,
//       check_in_out,
//       deposit_value,
//       type_property_id,
//       deposit_id,
//       amenityProperty, // this should be a list
//       roomProperty, // this should be a list
//       paiementProperty, // this should be a list
//       descriptionProperty, // this should be a list
//       priceProperty, // this should be a list
//     } = req.body;

//     // Check for required fields
//     if (
//       !nameProperty ||
//       !cleaning_price ||
//       !space ||
//       !standard_guests ||
//       !can_sleep_max ||
//       !type_property_id ||
//       !longitude ||
//       !latitude ||
//       !check_in_out ||
//       !preparation_time_before_arrival ||
//       !preparation_time_before_arrival_in_hours ||
//       !amenityProperty ||
//       !roomProperty ||
//       !paiementProperty ||
//       !descriptionProperty ||
//       !priceProperty
//     ) {
//       return res.status(400).json({ message: "missing" });
//     }

//     // Find the client
//     const foundClient = await Client.findByPk(req.decoded.id);
//     if (!foundClient) {
//       return res.status(404).json({ message: "owner_not_found" });
//     }

//     // Get location details
//     const lastLocation = await getReverseLocation(latitude, longitude);
//     if (!lastLocation) {
//       return res.status(404).json({ message: "location_not_found" });
//     }

//     // Create or update location
//     const location = await createOrUpdateEntity(
//       Location,
//       lastLocation,
//       null,
//       transaction
//     );

//     // Create property
//     const propertyCreated = await Property.create(
//       {
//         id: String(Date.now()),
//         name: nameProperty,
//         street,
//         cleaning_price,
//         space,
//         standard_guests,
//         can_sleep_max,
//         zip_code,
//         floor,
//         last_modified: getDate(),
//         date_created: getDate(),
//         preparation_time_before_arrival,
//         preparation_time_before_arrival_in_hours,
//         coordinates: {
//           Latitude: [String(latitude)],
//           Longitude: [String(longitude)],
//         },
//         cancellation_policies,
//         check_in_out:
//           typeof check_in_out == "string"
//             ? transformStringToJson(check_in_out)
//             : check_in_out,
//         deposit_value,
//         type_property_id,
//         location_id: location.id,
//         deposit_id,
//         owner_id: foundClient.id,
//         isThelandlord: true,
//         is_active: "false",
//         is_archived: "false",
//       },
//       { transaction }
//     );

//     // Handle image uploads
//     if (req.files && req.files.gallery) {
//       const imagePromises = req.files.gallery.map(async (imageProp) => {
//         if (imageProp) {
//           try {
//             const originalPath = imageProp.path;
//             const uniqueId = `${Date.now()}-${Math.floor(
//               Math.random() * 10000
//             )}`;
//             const thumbnailPath = `public/properties/${imageProp.filename}`;
//             await sharp(originalPath).resize(200, 200).toFile(thumbnailPath);

//             await PropertyImage.create(
//               {
//                 id: uniqueId,
//                 url: imageProp.filename,
//                 property_id: propertyCreated.id,
//                 thumbnail: imageProp.filename,
//                 type: 2,
//               },
//               { transaction }
//             );
//           } catch (error) {
//             throw new Error(
//               `Error processing image ${imageProp.originalname}: ${error.message}`
//             );
//           }
//         }
//       });

//       await Promise.all(imagePromises);
//     }

//     // Create related property details
//     for (const price of correctString(priceProperty)) {
//       await PropertyPrice.create(
//         {
//           price: price.price,
//           date_from: price.date_from.replace(/\s/g, ""),
//           date_to: price.date_to.replace(/\s/g, ""),
//           property_id: propertyCreated.id,
//         },
//         { transaction }
//       );
//     }
//     for (const propAme of correctString(amenityProperty)) {
//       await PropertyAmenity.create(
//         {
//           // ...propAme,
//           count: 1,
//           amenity_id: parseInt(propAme.amenity_id),
//           property_id: propertyCreated.id,
//         },
//         { transaction }
//       );
//     }
//     for (const propRoom of correctString(roomProperty)) {
//       await PropertyRoom.create(
//         {
//           ...propRoom,
//           property_id: propertyCreated.id,
//         },
//         { transaction }
//       );
//     }
//     for (const payement of correctString(paiementProperty)) {
//       await PropertyPaiement.create(
//         {
//           ...payement,
//           property_id: propertyCreated.id,
//         },
//         { transaction }
//       );
//     }
//     for (const description of correctString(descriptionProperty)) {
//       for (const languageId in languageMap) {
//         const translatedName = await translateTo(nameProperty, languageId);
//         const translatedStreet = await translateTo(street, languageId);
//         const translatedDescription = await translateTo(
//           description.text,
//           languageId
//         );

//         await Description.create(
//           {
//             name: translatedName,
//             street: translatedStreet,
//             text: translatedDescription,
//             language_id: languageId,
//             property_id: propertyCreated.id,
//           },
//           { transaction }
//         );
//       }
//     }
//     // Update user role and generate JWT
//     await updateRoleUser("owner", foundClient, true, transaction);
//     const jwt = await generateJWT(foundClient);

//     // Commit the transaction
//     await transaction.commit();

//     return res.status(200).json({ message: jwt });
//   } catch (error) {
//     // Rollback the transaction in case of error
//     if (transaction) await transaction.rollback();

//     console.error(`Error at ${req.route.path}`, error);
//     console.log(`Error at ${req.route.path}`);
//     console.error("\x1b[31m%s\x1b[0m", error);
//     return res.status(500).json({ message: error });
//   }
// };

// exports.updateProperty = async (req, res) => {
//   const transaction = await sequelize.transaction();
//   const id = req.params.id;
//   try {
//     const {
//       nameProperty,
//       street,
//       cleaning_price,
//       space,
//       standard_guests,
//       can_sleep_max,
//       zip_code,
//       floor,
//       preparation_time_before_arrival,
//       preparation_time_before_arrival_in_hours,
//       longitude,
//       latitude,
//       cancellation_policies,
//       check_in_out,
//       deposit_value,
//       type_property_id,
//       images,
//       deposit_id,
//       amenityProperty, // this should be a list
//       roomProperty, // this should be a list
//       paiementProperty, // this should be a list
//       descriptionProperty, // this should be a list
//       priceProperty, // this should be a list
//     } = req.body;

//     // Check for required fields
//     if (!id) {
//       return res.status(400).json({ message: "missing_property_id" });
//     }

//     const property = await Property.findByPk(id);
//     if (!property) {
//       return res.status(404).json({ message: "property_not_found" });
//     }

//     // Find the client
//     const foundClient = await Client.findByPk(req.decoded.id);
//     if (!foundClient) {
//       return res.status(404).json({ message: "owner_not_found" });
//     }

//     // Get location details
//     const lastLocation = await getReverseLocation(latitude, longitude);
//     if (!lastLocation) {
//       return res.status(404).json({ message: "location_not_found" });
//     }

//     // Update or create location
//     const location = await createOrUpdateEntity(
//       Location,
//       lastLocation,
//       null,
//       transaction
//     );

//     // Update property
//     await property.update(
//       {
//         name: nameProperty,
//         street,
//         cleaning_price,
//         space,
//         standard_guests,
//         can_sleep_max,
//         zip_code,
//         floor,
//         last_modified: getDate(),
//         preparation_time_before_arrival,
//         preparation_time_before_arrival_in_hours,
//         coordinates: {
//           Latitude: [String(latitude)],
//           Longitude: [String(longitude)],
//         },
//         cancellation_policies,
//         check_in_out:
//           typeof check_in_out == "string"
//             ? transformStringToJson(check_in_out)
//             : check_in_out,
//         deposit_value,
//         type_property_id,
//         location_id: location.id,
//         deposit_id,
//         owner_id: foundClient.id,
//         is_active: "false",
//         is_archived: "false",
//       },
//       { transaction }
//     );

//     // Parse the images string from the request body
//     // const updatedImages = JSON.parse(images);

//     // Find existing images and determine which ones to delete
//     const existingImages = await PropertyImage.findAll({
//       where: { property_id: id },
//     });
//     const imagesToDelete = existingImages.filter(
//       (img) => !images.some((updatedImg) => updatedImg.url === img.url)
//     );
//     for (const img of imagesToDelete) {
//       await PropertyImage.destroy({ where: { id: img.id }, transaction });
//     }
//     // Handle image uploads
//     if (req.files && req.files.gallery) {
//       const imagePromises = req.files.gallery.map(async (imageProp) => {
//         if (imageProp) {
//           try {
//             const originalPath = imageProp.path;
//             const uniqueId = `${Date.now()}-${Math.floor(
//               Math.random() * 10000
//             )}`;
//             const thumbnailPath = `public/properties/${imageProp.filename}`;
//             await sharp(originalPath).resize(200, 200).toFile(thumbnailPath);

//             await PropertyImage.create(
//               {
//                 id: uniqueId,
//                 url: imageProp.filename,
//                 property_id: property.id,
//                 thumbnail: imageProp.filename,
//                 type: 2,
//               },
//               { transaction }
//             );
//           } catch (error) {
//             throw new Error(
//               `Error processing image ${imageProp.originalname}: ${error.message}`
//             );
//           }
//         }
//       });

//       await Promise.all(imagePromises);
//     }

//     // Update related property details
//     await PropertyPrice.destroy({
//       where: { property_id: property.id },
//       transaction,
//     });
//     for (const price of typeof priceProperty == "string"
//       ? correctString(priceProperty)
//       : priceProperty) {
//       await PropertyPrice.create(
//         {
//           price: price.price,
//           date_from: price.date_from.replace(/\s/g, ""),
//           date_to: price.date_to.replace(/\s/g, ""),
//           property_id: property.id,
//         },
//         { transaction }
//       );
//     }

//     await PropertyAmenity.destroy({
//       where: { property_id: property.id },
//       transaction,
//     });
//     for (const propAme of typeof amenityProperty == "string"
//       ? correctString(amenityProperty)
//       : amenityProperty) {
//       await PropertyAmenity.create(
//         {
//           count: 1,
//           amenity_id: parseInt(propAme.amenity_id),
//           property_id: property.id,
//         },
//         { transaction }
//       );
//     }

//     await PropertyRoom.destroy({
//       where: { property_id: property.id },
//       transaction,
//     });
//     for (const propRoom of typeof roomProperty == "string"
//       ? correctString(roomProperty)
//       : roomProperty) {
//       await PropertyRoom.create(
//         {
//           ...propRoom,
//           property_id: property.id,
//         },
//         { transaction }
//       );
//     }

//     await PropertyPaiement.destroy({
//       where: { property_id: property.id },
//       transaction,
//     });
//     for (const payement of typeof paiementProperty == "string"
//       ? correctString(paiementProperty)
//       : paiementProperty) {
//       await PropertyPaiement.create(
//         {
//           ...payement,
//           property_id: property.id,
//         },
//         { transaction }
//       );
//     }

//     await Description.destroy({
//       where: { property_id: property.id },
//       transaction,
//     });
//     for (const description of typeof descriptionProperty == "string"
//       ? correctString(descriptionProperty)
//       : descriptionProperty) {
//       for (const languageId in languageMap) {
//         const translatedName = await translateTo(nameProperty, languageId);
//         const translatedStreet = await translateTo(street, languageId);
//         const translatedDescription = await translateTo(
//           description.text,
//           languageId
//         );

//         await Description.create(
//           {
//             name: translatedName,
//             street: translatedStreet,
//             text: translatedDescription,
//             language_id: languageId,
//             property_id: id,
//           },
//           { transaction }
//         );
//       }
//     }

//     // Commit the transaction
//     await transaction.commit();

//     return res.status(200).json({ message: true });
//   } catch (error) {
//     // Rollback the transaction in case of error
//     if (transaction) await transaction.rollback();

//     console.log(`Error at ${req.route.path}`);
//     console.error("\x1b[31m%s\x1b[0m", error);
//     return res.status(500).json({ message: error.message });
//   }
// };

// exports.getAllProperties = async (req, res) => {
//   try {
//     const page = req.query.pageQuery ? req.query.pageQuery : 1;
//     const limit = req.query.limitQuery ? parseInt(req.query.limitQuery) : 9;
//     const offset = (page - 1) * limit;
//     const ownerId = req.decoded.id;
//     const isAdmin = req.decoded.role.includes("admin");
//     const search = req.query.search;
//     const query = `
//       SELECT
//         property.id,
//         property.isThelandlord,
//         property.name AS name,
//         property.cleaning_price,
//         property.is_active,
//         (SELECT COUNT(*) FROM property_room WHERE room_id = 81 and property.id = property_room.property_id) AS wc_count,
//         (SELECT COUNT(*) FROM property_room WHERE room_id = 257 and property.id = property_room.property_id) AS bedroom_count,
//         SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT CASE WHEN property_image.type = 2 THEN property_image.thumbnail ELSE NULL END ORDER BY property_image.id ASC SEPARATOR ','), ',', 3) AS image_urls,
//         property.can_sleep_max,
//         property.standard_guests,
//         property.location_id AS location,
//         property.coordinates,
//         property_price.price
//         FROM property
//          LEFT JOIN property_price ON property.id = property_price.property_id
//         JOIN property_image ON property.id = property_image.property_id
//         ${isAdmin ? "Where true" : " WHERE property.owner_id = :ownerId  "}
//         ${search ? "AND property.name like :search" : ""}
//         GROUP BY property.id, property.name
//         LIMIT :limit OFFSET :offset
// `;

//     const properties = await sequelize.query(query, {
//       type: sequelize.QueryTypes.SELECT,
//       replacements: {
//         ownerId: ownerId,
//         search: search ? `%${search}%` : null,
//         limit: limit,
//         offset: offset,
//       },
//     });
//     const formattedList = await Promise.all(
//       properties.map(async (row) => {
//         const { avgRating, ratingCount } = await getAvgReviewAndCount(row.id);
//         const { latitude, longitude } = fromCoordinateToDouble(row.coordinates);
//         return {
//           beds: row.bedroom_count,
//           guests: row.can_sleep_max,
//           ratingCount: ratingCount,
//           avgRating: avgRating,
//           id: row.id,
//           name: row.name,
//           price: row.price ? String(parseInt(row.price)) : null,
//           location: row.location,
//           coordinates: { latitude, longitude }, // Construct coordinates object
//           images: row.image_urls ? row.image_urls.split(",") : [],
//           houseRules: row.house_rules,
//           description: row.text,
//           wcCount: row.wc_count,
//           is_active: row.is_active,
//         };
//       })
//     );

//     return res.status(200).json({ formattedList });
//   } catch (error) {
//     console.log(`Error at ${req.route.path}`);
//     console.error("\x1b[31m%s\x1b[0m", error);
//     return res.status(500).json({ message: error });
//   }
// };
// exports.validateProperty = async (req, res) => {
//   try {
//     const foundProperty = await Property.findByPk(req.params.id);
//     const value = req.body.active;
//     if (!foundProperty) {
//       return res.status(404).json({ message: "property_not_found" });
//     }
//     foundProperty.is_active = value == true ? "true" : "false";
//     await foundProperty.save();
//     return res.status(200).json({ active: foundProperty.is_active });
//   } catch (error) {
//     console.log(`Error at ${req.route.path}`);
//     console.error("\x1b[31m%s\x1b[0m", error);
//     return res.status(500).json({ message: error });
//   }
// };

// exports.getDetail = async (req, res) => {
//   try {
//     const idHouse = req.params.id;
//     const foundProperty = await Property.findByPk(idHouse);
//     const images = await getJoinTableProperty(idHouse, PropertyImage);
//     const amenities = await getJoinTableProperty(idHouse, PropertyAmenity);
//     const prices = await getJoinTableProperty(idHouse, PropertyPrice);
//     const rooms = await getJoinTableProperty(idHouse, PropertyRoom);
//     const paiement = await getJoinTableProperty(idHouse, PropertyPaiement);
//     const description = await getJoinTableProperty(idHouse, Description);

//     return res.status(200).json({
//       foundProperty: {
//         cleaning_price: foundProperty.cleaning_price,
//         space: foundProperty.space,
//         standard_guests: foundProperty.standard_guests,
//         can_sleep_max: foundProperty.can_sleep_max,
//         zip_code: foundProperty.zip_code,
//         floor: foundProperty.floor,
//         preparation_time_before_arrival:
//           foundProperty.preparation_time_before_arrival,
//         preparation_time_before_arrival_in_hours:
//           foundProperty.preparation_time_before_arrival_in_hours,
//         check_in_out: JSON.parse(foundProperty.check_in_out),
//         type_property_id: foundProperty.type_property_id,
//         deposit_id: foundProperty.depositId,
//         latitude: JSON.parse(foundProperty.coordinates).Latitude[0],
//         longitude: JSON.parse(foundProperty.coordinates).Longitude[0],
//         nameProperty: foundProperty.name,
//         street: foundProperty.street,
//         images: images,
//         amenityProperty: amenities,
//         roomProperty: rooms,
//         paiementProperty: paiement,
//         descriptionProperty: description,
//         priceProperty: prices,
//       },
//     });
//   } catch (error) {
//     console.log(`Error at ${req.route.path}`);
//     console.error("\x1b[31m%s\x1b[0m", error);
//     return res.status(500).json({ message: error });
//   }
// };
