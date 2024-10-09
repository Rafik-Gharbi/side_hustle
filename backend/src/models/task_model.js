const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Governorate } = require("./governorate_model");
const { Category } = require("./category_model");
const { getOneMinuteBeforeMidnight } = require("../helper/constants");
const Task = sequelize.define(
  "task",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    title: { type: Sequelize.STRING, allowNull: false },
    description: { type: Sequelize.STRING, allowNull: false },
    price: { type: Sequelize.FLOAT, allowNull: false },
    delivrables: { type: Sequelize.STRING, allowNull: true },
    coordinates: { type: Sequelize.STRING, allowNull: true },
    due_date: {
      type: Sequelize.DATE,
      defaultValue: getOneMinuteBeforeMidnight,
    },
    archived: { type: Sequelize.BOOLEAN, defaultValue: false },
  },
  {
    tableName: "task",
    timestamps: true,
  }
);

Task.belongsTo(User, { foreignKey: "owner_id", allowNull: false });
Task.belongsTo(Governorate, { foreignKey: "governorate_id", allowNull: false });
Task.belongsTo(Category, { foreignKey: "category_id", allowNull: false });

module.exports = {
  Task,
};
