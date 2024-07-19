const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Governorate } = require("./governorate_model");
const { Category } = require("./category_model");
const { getOneMinuteBeforeMidnight } = require("../helper/helpers");
const Task = sequelize.define(
  "task",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    title: { type: Sequelize.STRING, allowNull: false },
    description: { type: Sequelize.STRING, allowNull: false },
    price: { type: Sequelize.FLOAT, allowNull: false },
    delivrables: { type: Sequelize.STRING, allowNull: true },
    due_date: {
      type: Sequelize.DATE,
      defaultValue: getOneMinuteBeforeMidnight,
    },
    // final List<File>? attachments;
  },
  {
    tableName: "task",
    timestamps: false,
  }
);

Task.belongsTo(User, { foreignKey: "owner_id", allowNull: false });
Task.belongsTo(Governorate, { foreignKey: "governorate_id", allowNull: false });
Task.belongsTo(Category, { foreignKey: "category_id", allowNull: false });

module.exports = {
  Task,
};
