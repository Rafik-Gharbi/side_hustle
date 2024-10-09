const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Task } = require("./task_model");

const FavoriteTask = sequelize.define(
  "favorite_task",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
  },
  {
    tableName: "favorite_task",
    timestamps: false,
  }
);
FavoriteTask.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE",
});
FavoriteTask.belongsTo(Task, {
  foreignKey: "task_id",
  as: "task",
  onDelete: "CASCADE",
});
module.exports = {
  FavoriteTask,
};
