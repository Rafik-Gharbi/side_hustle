const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Governorate } = require("./governorate_model");
const Boost = sequelize.define(
  "boost",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    budget: { type: Sequelize.FLOAT, allowNull: false },
    gender: { type: Sequelize.STRING },
    endDate: {
      type: Sequelize.DATE,
      defaultValue: () => {
        const date = new Date();
        date.setDate(date.getDate() + 7);
        return date;
      },
    },
    minAge: { type: Sequelize.INTEGER },
    maxAge: { type: Sequelize.INTEGER },
    task_service_id: { type: Sequelize.INTEGER, allowNull: false },
    isTask: { type: Sequelize.BOOLEAN, allowNull: false },
    isActive: { type: Sequelize.BOOLEAN, defaultValue: true },
  },
  {
    tableName: "boost",
    timestamps: true,
  }
);

Boost.belongsTo(User, { foreignKey: "user_id", allowNull: false });
Boost.belongsTo(Governorate, { foreignKey: "governorate_id", allowNull: true });

module.exports = {
  Boost,
};
