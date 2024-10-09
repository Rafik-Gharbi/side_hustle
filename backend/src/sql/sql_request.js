const { Op } = require("sequelize");
const { sequelize } = require("../../db.config");
const {
  getTaskCondidatesNumber,
  getServiceCondidatesNumber,
  shuffleArray,
} = require("../helper/helpers");
const { Reservation } = require("../models/reservation_model");
const { Boost } = require("../models/boost_model");
const { Service } = require("../models/service_model");
const { Store } = require("../models/store_model");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const { Task } = require("../models/task_model");
const { User } = require("../models/user_model");
const { Booking } = require("../models/booking_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");

//function to get name and id from a given ids and table
const fetchNames = async (ids, tableName) => {
  const query = `
    SELECT id, name
    FROM ${tableName}
    WHERE id IN (:ids)
  `;
  const results = await sequelize.query(query, {
    replacements: { ids: ids ? ids : null },
    type: sequelize.QueryTypes.SELECT,
  });
  return results.map((result) => ({
    id: result.id,
    name: result.name,
  }));
};

const fetchNamesAndCount = async (ids, tableName) => {
  const query = `
    SELECT id, name
    FROM ${tableName}
    WHERE id IN (:ids)
  `;
  const results = await sequelize.query(query, {
    replacements: { ids: ids ? ids : null },
    type: sequelize.QueryTypes.SELECT,
  });

  const idCounts = {};
  if (ids) {
    ids.forEach((id) => {
      idCounts[id] = (idCounts[id] || 0) + 1;
    });
  }
  return results.map((result) => ({
    id: result.id,
    name: result.name,
    count: idCounts[result.id] || 0,
  }));
};

const getServiceOwner = async (serviceId) => {
  const query = `
    SELECT user.*
    FROM user
    LEFT JOIN store ON store.owner_id = user.id
    LEFT JOIN service ON service.store_id = store.id
    WHERE service.id = :serviceId
  `;
  const results = await sequelize.query(query, {
    replacements: { serviceId: serviceId },
    type: sequelize.QueryTypes.SELECT,
  });

  return results[0];
};

const getNotSeenMessages = async (discussionId, connected) => {
  const query = `
    SELECT Count(*) as notSeen
    FROM chat
    WHERE discussion_id = :discussionId AND seen = false AND reciever_id = :connectedId
  `;
  const results = await sequelize.query(query, {
    replacements: { discussionId: discussionId, connectedId: connected },
    type: sequelize.QueryTypes.SELECT,
  });

  return results[0]["notSeen"];
};

const getMyRequestRequiredActionsCount = async (userId) => {
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
  ;`;
  const tasks = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: {
      userId: userId,
    },
  });
  let result = 0;
  await Promise.all(
    tasks.map(async (row) => {
      let existReservation = await Reservation.findOne({
        where: { task_id: row.id },
      });
      const count = await getTaskCondidatesNumber(row.id);
      if (count != -1) result += count;
      if (existReservation && existReservation.status === "confirmed") result++;
    })
  );
  return result;
};

const getServiceHistoryRequiredActionsCount = async (userId) => {
  let bookingList = await Booking.findAll({
    where: {
      user_id: userId,
    },
  });

  let result = 0;
  await Promise.all(
    bookingList.map(async (row) => {
      if (row.status === "pending" || row.status === "confirmed") result++;
    })
  );
  return result;
};

const getTaskHistoryRequiredActionsCount = async (userId) => {
  let reservationList = await Reservation.findAll({
    where: {
      user_id: userId,
    },
  });

  let result = 0;
  await Promise.all(
    reservationList.map(async (row) => {
      if (row.status === "pending" || row.status === "confirmed") result++;
    })
  );
  return result;
};

const getMyStoreRequiredActionsCount = async (userId) => {
  const existStore = await Store.findOne({
    where: { owner_id: userId },
  });
  if (!existStore) {
    return 0;
  }
  const foundServices = await Service.findAll({
    where: { store_id: existStore.id },
  });

  let result = 0;
  await Promise.all(
    foundServices.map(async (service) => {
      const requests = await getServiceCondidatesNumber(service.id);
      result += requests;
    })
  );
  return result;
};

const getApproveUsersRequiredActionsCount = async (userId) => {
  const approveUsers = await User.findAll({
    where: { isVerified: "pending" },
  });

  return approveUsers.length;
};

async function fetchUserBooking(userId) {
  let userFound = await User.findByPk(userId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  }

  // Check user service bookings
  let bookingList = await Booking.findAll({
    where: {
      user_id: userFound.id,
    },
  });
  let formattedList = await Promise.all(
    bookingList.map(async (row) => {
      let foundService = await Service.findByPk(row.service_id);
      let service = await populateOneService(foundService, userFound.id);
      let serviceAttachments = await ServiceGalleryModel.findAll({
        where: { service_id: row.service_id },
      });

      return {
        id: row.id,
        user: userFound,
        date: row.createdAt,
        service: service,
        totalPrice: row.total_price,
        coupon: row.coupon,
        note: row.note,
        status: row.status,
        serviceAttachments,
      };
    })
  );

  return formattedList;
}

async function fetchUserOngoingBooking(userId) {
  let userFound = await User.findByPk(userId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  }

  // Check user store service bookings
  let formattedList = [];
  const userStore = await Store.findOne({ where: { owner_id: userId } });
  if (userStore) {
    const storeServices = await Service.findAll({
      where: { store_id: userStore.id },
    });
    if (storeServices.length > 0) {
      await Promise.all(
        storeServices.map(async (service) => {
          let bookingList = await Booking.findAll({
            where: {
              [Op.or]: [{ status: "pending" }, { status: "confirmed" }],
              service_id: service.id,
            },
          });
          if (bookingList.length > 0) {
            formattedList = await Promise.all(
              bookingList.map(async (row) => {
                let populatedService = await populateOneService(
                  service,
                  userFound.id
                );
                let serviceAttachments = await ServiceGalleryModel.findAll({
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
                  serviceAttachments,
                };
              })
            );
          }
        })
      );
    }
  }
  return formattedList;
}

async function fetchUserOngoingReservation(userId) {
  let userFound = await User.findByPk(userId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  }

  let formattedList = [];
  const userTasks = await Task.findAll({ where: { owner_id: userId } });
  if (userTasks.length > 0) {
    await Promise.all(
      userTasks.map(async (task) => {
        let reservationList = await Reservation.findAll({
          where: {
            [Op.or]: [{ status: "pending" }, { status: "confirmed" }],
            task_id: task.id,
          },
        });
        if (reservationList.length > 0) {
          formattedList = await Promise.all(
            reservationList.map(async (row) => {
              let foundTask = await Task.findByPk(row.task_id);
              let task = await populateOneTask(foundTask, userFound.id);
              let taskAttachments = await TaskAttachmentModel.findAll({
                where: { task_id: row.task_id },
              });

              return {
                id: row.id,
                user: userFound,
                date: row.createdAt,
                task: task,
                totalPrice: row.total_price,
                proposedPrice: row.proposed_price,
                coupon: row.coupon,
                note: row.note,
                status: row.status,
                taskAttachments,
              };
            })
          );
        }
      })
    );
  }

  return formattedList;
}

async function fetchUserReservation(userId) {
  let userFound = await User.findByPk(userId);
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
      let task = await populateOneTask(foundTask, userFound.id);
      let taskAttachments = await TaskAttachmentModel.findAll({
        where: { task_id: row.task_id },
      });

      return {
        id: row.id,
        user: userFound,
        date: row.createdAt,
        task: task,
        totalPrice: row.total_price,
        proposedPrice: row.proposed_price,
        coupon: row.coupon,
        note: row.note,
        status: row.status,
        taskAttachments,
      };
    })
  );
  return formattedList;
}

async function fetchAndSortNearbyTasks(user, limit = 10, offset = 0) {
  let userLongitude, userLatitude;
  if (user && user.coordinates) {
    [userLongitude, userLatitude] = user?.coordinates?.split(",").map(Number);
  }
  const query = `SELECT
        id,
        title,
        description,
        price,
        delivrables,
        coordinates,
        due_date,
        owner_id,
        governorate_id,
        category_id
        ${
          userLongitude && userLatitude
            ? `, (ST_Distance(
                ST_GeomFromText(
                    CONCAT('POINT(',
                        CAST(SUBSTRING_INDEX(coordinates, ',', 1) AS DECIMAL(10, 6)), ' ',
                        CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)), 
                    ')'), 4326
                ),
                ST_GeomFromText(
                    CONCAT('POINT(', :userLongitude, ' ', :userLatitude, ')'), 4326
                )
            )) AS distance`
            : ``
        }
        FROM
        task
        WHERE
        task.archived = false AND 
        ${
          userLongitude && userLatitude
            ? `coordinates IS NOT NULL`
            : `governorate_id = :userGovernorateId`
        }
        ${userLongitude && userLatitude ? `ORDER BY distance ASC` : ``}
      `;
  const tasks = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: {
      userLongitude,
      userLatitude,
      userGovernorateId: user && user.governorate_id ? user.governorate_id : 1,
    },
  });

  // Shuffle the tasks array
  shuffleArray(tasks);

  // Apply limit and offset to the shuffled array
  const limitedTasks = tasks.slice(offset, offset + limit);

  const nearbyTasks = await populateTasks(limitedTasks, user?.id);

  return nearbyTasks;
}

async function getRandomHotTasks(user, limit = 10, offset = 0) {
  // get hot tasks
  const activeBoost = await Boost.findAll({
    where: {
      isTask: true,
      isActive: true,
      endDate: { [Op.gt]: new Date() }, // grater than today
    },
  });
  const tasks = await Promise.all(
    activeBoost.map(async (row) => {
      const task = await Task.findOne({ where: { id: row.task_service_id } });
      return await populateOneTask(task, user?.id);
    })
  );

  // Shuffle the tasks array
  shuffleArray(tasks);

  // Apply limit and offset to the shuffled array
  const hotTasks = tasks.slice(offset, offset + limit);

  return hotTasks;
}

async function populateTasks(fetchedTasks, currentUserId) {
  const tasks = await Promise.all(
    fetchedTasks.map(async (row) => {
      return await populateOneTask(row, currentUserId);
    })
  );

  return tasks;
}

async function populateOneTask(task, currentUserId) {
  let userFavorites = [];
  if (currentUserId) {
    userFavorites = await getFavoriteTaskByUserId(currentUserId);
  }
  const owner = await User.findOne({ where: { id: task.owner_id ?? task.owner.id } });
  let taskAttachments = [];
  taskAttachments = await TaskAttachmentModel.findAll({
    where: { task_id: task.id },
  });

  return {
    id: task.id,
    price: task.price,
    title: task.title,
    description: task.description,
    delivrables: task.delivrables,
    governorate_id: task.governorate_id,
    category_id: task.category_id,
    coordinates: task.coordinates,
    owner: owner,
    attachments: taskAttachments.length == 0 ? [] : taskAttachments,
    isFavorite:
      currentUserId && userFavorites.length > 0
        ? userFavorites.some((e) => e.task_id == task.id)
        : false,
    distance: task.distance,
  };
}

async function populateServices(fetchedServices) {
  const tasks = await Promise.all(
    fetchedServices.map(async (row) => {
      return await populateOneService(row);
    })
  );

  return tasks;
}

async function populateOneService(service) {
  let gallery = [];
  gallery = await ServiceGalleryModel.findAll({
    where: { service_id: service.id },
  });

  const requests = await getServiceCondidatesNumber(service.id);
  return {
    id: service.id,
    price: service.price,
    name: service.name,
    description: service.description,
    category_id: service.category_id,
    gallery,
    requests,
    included: service.included,
    notIncluded: service.notIncluded,
    notes: service.notes,
    timeEstimationFrom: service.timeEstimationFrom,
    timeEstimationTo: service.timeEstimationTo,
  };
}

const getFavoriteTaskByUserId = async (userId) => {
  const query = `
    SELECT task_id
    FROM favorite_task
    WHERE user_id = :userId
  `;
  const result = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: { userId: userId },
  });

  return result;
};

const getFavoriteStoreByUserId = async (userId) => {
  const query = `
    SELECT store_id
    FROM favorite_store
    WHERE user_id = :userId
  `;
  const result = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: { userId: userId },
  });

  return result;
};

const getFavoriteClientPropertyId = async (propertyId, clientId) => {
  if (!clientId) {
    return 0;
  }
  const query = `
      SELECT
          CASE WHEN favorite.id IS NOT NULL THEN TRUE ELSE FALSE END AS favorite
      FROM favorite
      where favorite.property_id = :propertyId AND favorite.client_id = :clientId
  `;
  const [result] = await sequelize.query(query, {
    replacements: { propertyId: propertyId, clientId: clientId },
    type: sequelize.QueryTypes.SELECT,
  });

  if (result) {
    return { favorite: result.favorite ? 1 : 0 };
  } else {
    return 0; // or any default value you prefer when no favorite is found
  }
};

const getLocationById = async (id, language) => {
  let nameField;
  let timezoneField;

  switch (language) {
    case "4":
      nameField = "name_fr";
      timezoneField = "timezone_fr";
      break;
    case "5":
      nameField = "name_es";
      timezoneField = "timezone_es";
      break;
    case "13":
      nameField = "name_ar";
      timezoneField = "timezone_ar";
      break;
    default:
      nameField = "name";
      timezoneField = "timezone";
      break;
  }

  const query = `
      SELECT ${nameField} AS city, id, ${timezoneField} AS country
      FROM location
      WHERE id = :id
  `;

  const [results] = await sequelize.query(query, {
    replacements: { id: id },
    type: sequelize.QueryTypes.SELECT,
  });

  if (results) {
    return results;
  } else {
    return null; // or any default value you prefer when no location is found
  }
};

const getTextByLanguage = async (id, language) => {
  const query = `
    SELECT name, street, text
    FROM description
    WHERE language_id = :language_id AND property_id = :id
  `;
  const result = await sequelize.query(query, {
    replacements: { id: id, language_id: language ? language : 4 },
    type: sequelize.QueryTypes.SELECT,
  });

  if (result && result.length > 0) {
    return result[0]; // return the first object in the result array
  } else {
    return null; // or any default value you prefer when no result is found
  }
};

const getAvgReviewAndCount = async (propertyId) => {
  const query = `
      SELECT
          property.id,
          property.name AS name,
          
          AVG(review.rating) AS avg_rating,
          COUNT(review.id) AS review_count
      FROM property
      LEFT JOIN review ON property.id = review.property_id

      where property.id = :propertyId
      GROUP BY property.id, property.name
  `;
  const [result] = await sequelize.query(query, {
    replacements: { propertyId: propertyId },
    type: sequelize.QueryTypes.SELECT,
  });

  if (result) {
    return { avgRating: result.avg_rating, ratingCount: result.review_count };
  } else {
    return null; // or any default value you prefer when no favorite is found
  }
};

async function getSubDiscussions(discussion_id) {
  let query = `
   select sub_discussion.id, sub_discussion.date_from, sub_discussion.date_to, sub_discussion.price
   from sub_discussion
   left join discussion on sub_discussion.discussion_id = discussion.id
   where discussion.id = :discussion_id
        `;

  const SubDiscussionList = await sequelize.query(query, {
    replacements: {
      discussion_id: discussion_id,
    },
    type: sequelize.QueryTypes.SELECT,
  });
  return SubDiscussionList;
}

async function getDiscussionIdByChatId(idChat) {
  if (idChat == null) return;
  let query = `
      SELECT discussion_id FROM chat
      WHERE chat.id = :idChat
        `;

  const discussion = await sequelize.query(query, {
    replacements: {
      idChat: idChat,
    },
    type: sequelize.QueryTypes.SELECT,
  });
  return discussion[0].id;
}

async function getChat(
  discussionId,
  idChat,
  connected,
  limitQuery = 11,
  pageQuery = 1
) {
  const page = pageQuery;
  const limit = parseInt(limitQuery);
  const offset = (page - 1) * limit;
  if (idChat && !discussionId) {
    discussionId = await getDiscussionIdByChatId(idChat);
  }
  let query = `
        SELECT chat.*
        FROM chat
        ${
          !idChat
            ? "WHERE discussion_id = :discussionId"
            : ` WHERE (sender_id = :connected OR reciever_id = :connected) 
            AND id >= :idChat AND discussion_id = :discussionId`
        } 
        ORDER BY chat.createdAt ${idChat ? "ASC" : "DESC"}
        LIMIT ${idChat ? 4 : ":limit"} OFFSET :offset
        `;
  const chatList = await sequelize.query(query, {
    replacements: {
      limit: limit,
      idChat: idChat,
      discussionId: discussionId,
      connected: connected,
      offset: offset,
    },
    type: sequelize.QueryTypes.SELECT,
  });

  return chatList.reverse();
}

module.exports = {
  fetchNamesAndCount,
  getLocationById,
  fetchNames,
  getFavoriteTaskByUserId,
  getFavoriteStoreByUserId,
  getAvgReviewAndCount,
  getSubDiscussions,
  getChat,
  getDiscussionIdByChatId,
  getFavoriteClientPropertyId,
  getTextByLanguage,
  fetchAndSortNearbyTasks,
  populateTasks,
  fetchUserReservation,
  populateOneTask,
  getNotSeenMessages,
  getMyRequestRequiredActionsCount,
  getTaskHistoryRequiredActionsCount,
  getMyStoreRequiredActionsCount,
  getApproveUsersRequiredActionsCount,
  getServiceHistoryRequiredActionsCount,
  getServiceOwner,
  populateServices,
  populateOneService,
  fetchUserBooking,
  fetchUserOngoingBooking,
  fetchUserOngoingReservation,
  getRandomHotTasks,
};
