const { sequelize } = require("../../db.config");

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

const getImageByPropertyId = async (propertyId) => {
  const query = `
    SELECT id,url, thumbnail
    FROM property_image
    WHERE property_id = :propertyId
  `;
  const results = await sequelize.query(query, {
    replacements: { propertyId: propertyId },
    type: sequelize.QueryTypes.SELECT,
  });

  return results.map((result) => ({
    id: result.id,
    url: result.url,
    thumbnail: result.thumbnail,
  }));
};

const getOwnerIdByProperty = async (propertyId) => {
  const query = `
    SELECT owner_id
    FROM property
    WHERE id = :propertyId
  `;
  const results = await sequelize.query(query, {
    replacements: { propertyId: propertyId },
    type: sequelize.QueryTypes.SELECT,
  });
  if (results.length > 0) {
    return results[0].owner_id; // Return just the owner_id
  } else {
    return null; // Return null if no results found
  }
};

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
      SELECT discussion.id FROM chat
      JOIN sub_discussion ON sub_discussion.id = chat.sub_discussion_id
      JOIN discussion ON discussion.id = sub_discussion.discussion_id
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
  sub_discussion_list,
  idChat,
  connected,
  limitQuery = 11,
  pageQuery = 1
) {
  const page = pageQuery;
  const limit = parseInt(limitQuery);
  const offset = (page - 1) * limit;
  const discussionId = await getDiscussionIdByChatId(idChat);
  let query = `
        SELECT chat.*
        FROM chat
        JOIN sub_discussion ON sub_discussion.id = chat.sub_discussion_id
        JOIN discussion ON discussion.id = sub_discussion.discussion_id
        ${
          sub_discussion_list && !idChat
            ? "WHERE sub_discussion_id IN (:sub_discussion_id)"
            : !sub_discussion_list && idChat
            ? ` WHERE (sender_id = :connected OR reciever_id = :connected) 
            AND chat.id >= :idChat AND discussion.id = :discussionId`
            : ""
        } 
        ORDER BY chat.createdAt ${idChat ? "ASC" : "DESC"}
        LIMIT ${idChat ? 4 : ":limit"} OFFSET :offset
        `;
  const chatList = await sequelize.query(query, {
    replacements: {
      sub_discussion_id: sub_discussion_list
        ? sub_discussion_list.map((subDiscussion) => {
            return [subDiscussion.id];
          })
        : null,
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
  getImageByPropertyId,
  getFavoriteTaskByUserId,
  getFavoriteStoreByUserId,
  getOwnerIdByProperty,
  getAvgReviewAndCount,
  getSubDiscussions,
  getChat,
  getDiscussionIdByChatId,
  getFavoriteClientPropertyId,
  getTextByLanguage,
};
