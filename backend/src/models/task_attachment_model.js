const { sequelize, Sequelize } = require("../../db.config");
const { Task } = require("./task_model");
const TaskAttachmentModel = sequelize.define(
  "task_attachment",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    url: { type: Sequelize.STRING },
    type: { type: Sequelize.STRING },
  },
  {
    tableName: "task_attachment",
  }
);

TaskAttachmentModel.belongsTo(Task, {
  foreignKey: "task_id",
  onDelete: "CASCADE",
});

module.exports = {
  TaskAttachmentModel,
};