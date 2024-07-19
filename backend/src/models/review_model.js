const { sequelize, Sequelize } = require("../../db.config");
const { Task } = require("./task_model");
const Review = sequelize.define(
  "review",
  {
    comment: { type: Sequelize.TEXT },
    rating: { type: Sequelize.DOUBLE },
    name: { type: Sequelize.STRING },
  },
  {
    tableName: "review",
    timestamps: true,
  }
);
Review.belongsTo(Task, { foreignKey: "task_id" });

module.exports = {
  Review,
};
