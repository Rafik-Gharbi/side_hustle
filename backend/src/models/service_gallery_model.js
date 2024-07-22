const { sequelize, Sequelize } = require("../../db.config");
const { Service } = require("./service_model");
const ServiceGalleryModel = sequelize.define(
  "service_gallery",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    url: { type: Sequelize.STRING },
    type: { type: Sequelize.STRING },
  },
  {
    tableName: "service_gallery",
  }
);

ServiceGalleryModel.belongsTo(Service, {
  foreignKey: "service_id",
  onDelete: "CASCADE",
});

module.exports = {
  ServiceGalleryModel,
};
