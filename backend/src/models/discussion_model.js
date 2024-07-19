const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Task } = require("./task_model");
const Discussion = sequelize.define(
  "discussion",
  {},
  {
    tableName: "discussion",
    timestamps: true,
  }
);
Discussion.belongsTo(User, { foreignKey: "user_id" });
Discussion.belongsTo(User, { foreignKey: "owner_id" });
Discussion.belongsTo(Task, { foreignKey: "task_id" });

module.exports = {
  Discussion,
};
