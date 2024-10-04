const Sequelize = require("sequelize");
const { deleteImages } = require("./src/helper/image");
require("dotenv").config();

var dbConfig = {
  HOST: process.env.DB_HOST,
  USER: process.env.DB_USER,
  PASSWORD: process.env.DB_PASSWORD,
  DB: process.env.DB_DB,
  dialect: process.env.DB_DIALECT,
  pool: {
    max: 100,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
  port: 3306,
};

//Initialize connection to DB
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  operatorsAliases: false,

  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle,
  },
  logging: false,
  port: dbConfig.port,
});

async function deleteDatabase() {
  await sequelize.sync({ force: true });
  deleteImages();
}

module.exports = {
  Sequelize,
  sequelize,
  deleteDatabase,
};
