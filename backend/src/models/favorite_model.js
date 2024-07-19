const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Task } = require("./task_model");

const Favorite = sequelize.define(
  "favorite",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
  },
  {
    tableName: "favorite",
    timestamps: false,
  }
);
Favorite.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE",
});
Favorite.belongsTo(Task, {
  foreignKey: "task_id",
  as: "task",
  onDelete: "CASCADE",
});
module.exports = {
  Favorite,
};
