const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Store } = require("./store_model");

const FavoriteStore = sequelize.define(
  "favorite_store",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
  },
  {
    tableName: "favorite_store",
    timestamps: false,
  }
);
FavoriteStore.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE",
});
FavoriteStore.belongsTo(Store, {
  foreignKey: "store_id",
  as: "store",
  onDelete: "CASCADE",
});
module.exports = {
  FavoriteStore,
};
