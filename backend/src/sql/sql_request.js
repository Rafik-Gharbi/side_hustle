const { Op } = require("sequelize");
const { sequelize } = require("../../db.config");
const {
  getTaskCondidatesNumber,
  getServiceCondidatesNumber,
  shuffleArray,
  calculateTaskCoinsPrice,
} = require("../helper/helpers");
const { Reservation } = require("../models/reservation_model");
const { Boost } = require("../models/boost_model");
const { Service } = require("../models/service_model");
const { Store } = require("../models/store_model");
const { TaskAttachmentModel } = require("../models/task_attachment_model");
const { Task } = require("../models/task_model");
const { User } = require("../models/user_model");
const { ServiceGalleryModel } = require("../models/service_gallery_model");
const { Contract } = require("../models/contract_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");
const { Report } = require("../models/report_model");
const { Feedback } = require("../models/feedback_model");
const { SupportTicket } = require("../models/support_ticket");
const {
  SupportAttachmentModel,
} = require("../models/support_attachment_model");
const { Category } = require("../models/category_model");

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

const getTaskHistoryRequiredActionsCount = async (userId) => {
  let reservationList = await Reservation.findAll({
    where: {
      provider_id: userId,
      task_id: { [Op.ne]: null },
      status: { [Op.ne]: "pending" },
    },
  });

  const result = reservationList.length;
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

const getApproveUsersRequiredActionsCount = async () => {
  const approveUsers = await User.findAll({
    where: { isVerified: "pending" },
  });

  return approveUsers.length;
};

const getBalanceTransactionsRequiredActionsCount = async () => {
  const transactions = await BalanceTransaction.findAll({
    where: { status: "pending" },
  });

  return transactions.length;
};

const getUserReportsRequiredActionsCount = async () => {
  const reports = await Report.findAll();

  return reports.length;
};

const getUserFeedbacksRequiredActionsCount = async () => {
  const feedbacks = await Feedback.findAll();

  return feedbacks.length;
};

const getUserSupportRequiredActionsCount = async () => {
  const tickets = await SupportTicket.findAll({
    where: { status: { [Op.not]: "closed" } },
  });

  return tickets.length;
};

async function fetchUserBooking(userId, status = undefined) {
  let userFound = await User.findByPk(userId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  }

  // Check user service bookings
  let bookingList = await Reservation.findAll({
    where: {
      [Op.or]: [{ user_id: userFound.id }, { provider_id: userFound.id }],
      status: status ?? "pending",
      service_id: { [Op.ne]: null },
    },
  });
  let formattedList = await Promise.all(
    bookingList.map(async (row) => {
      let foundService = await Service.findByPk(row.service_id);
      let service = await populateOneService(foundService, userFound.id);
      let serviceAttachments = await ServiceGalleryModel.findAll({
        where: { service_id: row.service_id },
      });
      const providerFound = await User.findOne({
        where: { id: row.provider_id },
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
        provider: providerFound,
      };
    })
  );

  return formattedList;
}

async function fetchUserReservation(userId, status = undefined) {
  let userFound = await User.findByPk(userId);
  if (!userFound) {
    return res.status(404).json({ message: "user_not_found" });
  }

  let reservationList = await Reservation.findAll({
    where: {
      [Op.or]: [{ user_id: userFound.id }, { provider_id: userFound.id }],
      status: status ?? null,
      task_id: { [Op.ne]: null },
    },
  });
  const formattedList = await Promise.all(
    reservationList.map(async (row) => {
      let taskAttachments;
      let task;
      if (row.task_id) {
        const foundTask = await Task.findByPk(row.task_id);
        taskAttachments = await TaskAttachmentModel.findAll({
          where: { task_id: row.task_id },
        });
        task = await populateOneTask(foundTask, userFound.id);
      }
      const providerFound = await User.findOne({
        where: { id: row.provider_id },
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
        provider: providerFound,
      };
    })
  );
  return formattedList;
}

async function fetchAndSortNearbyTasks(
  user,
  governorateId,
  limit = 10,
  offset = 0,
  searchQuery = "",
  categoryId = undefined,
  priceMin = undefined,
  priceMax = undefined,
  taskId = undefined
) {
  let userLongitude, userLatitude;
  if (user && user.coordinates) {
    [userLongitude, userLatitude] = user?.coordinates?.split(",").map(Number);
  }
  let childCategoryIds;
  if (categoryId) {
    const foundCategory = await Category.findByPk(categoryId);
    // if is parent category fetch all child categories id to compare with it
    if (foundCategory.parentId == -1) {
      const childCategories = await Category.findAll({
        where: { parentId: categoryId },
        attributes: ["id"],
      });
      childCategoryIds = childCategories.map((category) => category.id);
    }
  }
  const query = `SELECT
        id,
        title,
        description,
        price,
        priceMax,
        delivrables,
        coordinates,
        due_date,
        owner_id,
        governorate_id,
        category_id
        ${
          userLongitude && userLatitude
            ? `, (
                6371e3 * 2 * ATAN2(
                  SQRT(
                    SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)) - :userLatitude) / 2) * SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)) - :userLatitude) / 2) +
                    COS(RADIANS(:userLatitude)) * COS(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)))) *
                    SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', 1) AS DECIMAL(10, 6)) - :userLongitude) / 2) * SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', 1) AS DECIMAL(10, 6)) - :userLongitude) / 2)
                  ),
                  SQRT(
                    1 - (
                      SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)) - :userLatitude) / 2) * SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)) - :userLatitude) / 2) +
                      COS(RADIANS(:userLatitude)) * COS(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', -1) AS DECIMAL(10, 6)))) *
                      SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', 1) AS DECIMAL(10, 6)) - :userLongitude) / 2) * SIN(RADIANS(CAST(SUBSTRING_INDEX(coordinates, ',', 1) AS DECIMAL(10, 6)) - :userLongitude) / 2)
                    )
                  )
                )
              ) AS distance`
            : ``
        }
        FROM
        task
        WHERE
        task.archived = false AND (task.title LIKE :searchQuery OR task.description LIKE :searchQuery) 
        ${userLongitude && userLatitude ? ` AND coordinates IS NOT NULL` : ""}
        ${
          governorateId && governorateId === 1
            ? ""
            : governorateId ||
              (user && user.governorate_id && user.governorate_id !== 1)
            ? ` AND governorate_id = :userGovernorateId`
            : ``
        }
        ${
          childCategoryIds && childCategoryIds.length > 0
            ? `AND task.category_id IN (:childCategoryIds)`
            : categoryId
            ? `AND task.category_id = :categoryId`
            : ``
        }        
        ${priceMin ? ` AND task.price >= :priceMin` : ``}
        ${priceMax ? ` AND task.price <= :priceMax` : ``}
        ${userLongitude && userLatitude ? ` ORDER BY distance ASC` : ``}
      `;
  const tasks = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: {
      searchQuery: `%${searchQuery}%`,
      categoryId: categoryId,
      childCategoryIds: childCategoryIds,
      priceMin: priceMin,
      priceMax: priceMax,
      taskId: taskId,
      userLongitude,
      userLatitude,
      userGovernorateId:
        (governorateId && governorateId !== 1 ? governorateId : undefined) ??
        (user && user.governorate_id ? user.governorate_id : 1),
    },
  });

  // Filter tasks with distance less than 100 kilometers (100,000 meters)
  let filteredTasks = [];
  if (userLongitude && userLatitude) {
    filteredTasks = tasks.filter((task) => task.distance < 100000);
  } else {
    filteredTasks = tasks;
  }
  // Shuffle the tasks array
  shuffleArray(filteredTasks);
  // Apply limit and offset to the shuffled array
  // const limitedTasks = filteredTasks.slice(offset, offset + limit);

  const nearbyTasks = await populateTasks(filteredTasks, user?.id);

  return nearbyTasks;
}

async function fetchAndSortGovernorateTasks(
  user,
  governorateId,
  limit = 10,
  offset = 0,
  searchQuery = "",
  categoryId = undefined,
  priceMin = undefined,
  priceMax = undefined,
  taskId = undefined
) {
  let childCategoryIds;
  if (categoryId) {
    const foundCategory = await Category.findByPk(categoryId);
    // if is parent category fetch all child categories id to compare with it
    if (foundCategory.parentId == -1) {
      const childCategories = await Category.findAll({
        where: { parentId: categoryId },
        attributes: ["id"],
      });
      childCategoryIds = childCategories.map((category) => category.id);
    }
  }
  const query = `SELECT
        id,
        title,
        description,
        price,
        priceMax,
        delivrables,
        coordinates,
        due_date,
        owner_id,
        governorate_id,
        category_id
        FROM
        task
        WHERE
        task.archived = false AND (task.title LIKE :searchQuery OR task.description LIKE :searchQuery)
        ${
          governorateId && governorateId === 1
            ? ""
            : governorateId ||
              (user && user.governorate_id && user.governorate_id !== 1)
            ? ` AND governorate_id = :userGovernorateId`
            : ``
        }
        ${
          childCategoryIds && childCategoryIds.length > 0
            ? `AND task.category_id IN (:childCategoryIds)`
            : categoryId
            ? `AND task.category_id = :categoryId`
            : ``
        }
        ${taskId ? `AND task.id = :taskId` : ``}
        ${priceMin ? ` AND task.price >= :priceMin` : ``}
        ${priceMax ? ` AND task.price <= :priceMax` : ``}
      `;
  const tasks = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: {
      searchQuery: `%${searchQuery}%`,
      categoryId: categoryId,
      childCategoryIds: childCategoryIds,
      priceMin: priceMin,
      priceMax: priceMax,
      taskId: taskId,
      userGovernorateId:
        (governorateId && governorateId !== 1 ? governorateId : undefined) ??
        (user && user.governorate_id ? user.governorate_id : 1),
    },
  });

  // Shuffle the tasks array
  shuffleArray(tasks);

  // Apply limit and offset to the shuffled array
  const limitedTasks = tasks.slice(offset, offset + limit);

  const nearbyTasks = await populateTasks(limitedTasks, user?.id);

  return nearbyTasks;
}

async function getRandomHotTasks(user, governorateId, limit = 10, offset = 0) {
  if (typeof governorateId === "string") {
    governorateId = parseInt(governorateId, 10);
  }
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

  // Filter tasks by governorateId if available, else by user governorate
  const filteredTasks = tasks.filter((task) => {
    if (governorateId) {
      return task.governorate_id === governorateId;
    } else if (user && user.governorate_id) {
      return task.governorate_id === user.governorate_id;
    }
    return true;
  });

  // Shuffle the tasks array
  shuffleArray(filteredTasks);

  // Apply limit and offset to the shuffled array
  const hotTasks = filteredTasks.slice(offset, offset + limit);

  return hotTasks;
}

async function fetchPopularCategories(searchMode, user) {
  const query = `
    SELECT c.id, c.name, COUNT(t.id) AS task_count
    FROM category c
    JOIN task t ON c.id = t.category_id
    ${
      searchMode !== "national"
        ? `WHERE t.governorate_id = :userGovernorateId`
        : ""
    }
    GROUP BY c.id, c.name
    ORDER BY task_count DESC
    LIMIT 4;
  `;
  const result = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
    replacements: {
      userGovernorateId: user && user.governorate_id ? user.governorate_id : 1,
    },
  });
  return result;
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
  const owner = await User.findOne({
    where: { id: task.owner_id ?? task.owner.id },
  });
  let taskAttachments = [];
  taskAttachments = await TaskAttachmentModel.findAll({
    where: { task_id: task.id },
  });

  return {
    id: task.id,
    price: task.price,
    priceMax: task.priceMax,
    deducted_coins: task.deducted_coins,
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
    coins: calculateTaskCoinsPrice(task.price),
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
  const store = await Store.findOne({ where: { id: service.store_id } });
  const owner = await User.findOne({ where: { id: store.owner_id } });

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
    coins: calculateTaskCoinsPrice(service.price),
    owner: owner,
  };
}

async function populateSupportTickets(fetchedTickets) {
  const tickets = await Promise.all(
    fetchedTickets.map(async (row) => {
      return await populateOneSupportTicket(row);
    })
  );

  return tickets;
}

async function populateOneSupportTicket(ticket) {
  let attachments = [];
  attachments = await SupportAttachmentModel.findAll({
    where: { ticket_id: ticket.id },
  });
  let logFile;
  if (attachments && attachments.length > 0) {
    logFile =
      attachments.find(
        (attachment) =>
          attachment.type === "file" && attachment.url.endsWith(".txt")
      ) || null;
    attachments = attachments.filter(
      (attachment) => attachment.id !== logFile.id
    );
  }

  return {
    id: ticket.id,
    category: ticket.category,
    subject: ticket.subject,
    description: ticket.description,
    status: ticket.status,
    priority: ticket.priority,
    user: ticket.user,
    user_id: ticket.user_id,
    assigned: ticket.assigned,
    assigned_to: ticket.assigned_to,
    attachments,
    logFile,
    createdAt: ticket.createdAt,
    updatedAt: ticket.updatedAt,
  };
}

async function populateSupportMessages(fetchedMessagess) {
  const messages = await Promise.all(
    fetchedMessagess.map(async (row) => {
      return await populateOneSupportMessage(row);
    })
  );

  return messages;
}

async function populateOneSupportMessage(message) {
  let attachment;
  attachment = await SupportAttachmentModel.findOne({
    where: { message_id: message.id },
  });

  return {
    id: message.id,
    message: message.message,
    attachment: attachment,
    user: message.user,
    sender_id: message.sender_id,
    ticket_id: message.ticket_id,
    createdAt: message.createdAt,
  };
}

async function populateStores(fetchedStores) {
  const tasks = await Promise.all(
    fetchedStores.map(async (row) => {
      return await populateOneStore(row);
    })
  );

  return tasks;
}

async function populateOneStore(store) {
  let services = await Service.findAll({ where: { store_id: store.id } });
  store.services = await populateServices(services);

  return store;
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

function populateContract(contractId) {
  return Contract.findOne({
    where: { id: contractId },
    include: [
      {
        model: User,
        as: "seeker",
        attributes: ["id", "name"],
      },
      {
        model: User,
        as: "provider",
        attributes: ["id", "name"],
      },
      {
        model: Reservation,
        as: "reservation",
        include: [
          { model: User, as: "user" },
          { model: User, as: "provider" },
          { model: Task, as: "task", include: [{ model: User, as: "user" }] },
          { model: Service, as: "service" },
        ],
      },
    ],
  });
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
  getServiceOwner,
  populateServices,
  populateOneService,
  fetchUserBooking,
  getRandomHotTasks,
  populateContract,
  getBalanceTransactionsRequiredActionsCount,
  getUserReportsRequiredActionsCount,
  getUserFeedbacksRequiredActionsCount,
  populateStores,
  populateOneStore,
  getUserSupportRequiredActionsCount,
  populateSupportTickets,
  populateOneSupportTicket,
  populateSupportMessages,
  populateOneSupportMessage,
  fetchAndSortGovernorateTasks,
  fetchPopularCategories,
};
