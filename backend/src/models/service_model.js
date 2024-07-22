const { sequelize, Sequelize } = require("../../db.config");
const { Category } = require("./category_model");
const { Store } = require("./store_model");
const Service = sequelize.define(
  "service",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    description: { type: Sequelize.STRING, allowNull: false },
    price: { type: Sequelize.FLOAT, allowNull: false },
  },
  {
    tableName: "service",
    timestamps: true,
  }
);

Service.belongsTo(Store, { foreignKey: "store_id", allowNull: false });
Service.belongsTo(Category, { foreignKey: "category_id", allowNull: false });

module.exports = {
  Service,
};
