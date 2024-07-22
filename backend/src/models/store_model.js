const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Governorate } = require("./governorate_model");
const Store = sequelize.define(
  "store",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    picture: { type: Sequelize.STRING, allowNull: true },
    coordinates: { type: Sequelize.STRING, allowNull: true },
    description: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "store",
    timestamps: true,
  }
);

Store.belongsTo(User, { foreignKey: "owner_id", allowNull: false });
Store.belongsTo(Governorate, { foreignKey: "governorate_id", allowNull: false });

module.exports = {
  Store,
};
