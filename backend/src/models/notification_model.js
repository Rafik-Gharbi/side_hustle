const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Notification = sequelize.define(
  "notification",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    title: { type: Sequelize.STRING, allowNull: true },
    body: { type: Sequelize.STRING, allowNull: true },
    type: { type: Sequelize.STRING, allowNull: true },
    seen: { type: Sequelize.BOOLEAN, defaultValue: false },
    action: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "notification",
    timestamps: true,
  }
);

Notification.belongsTo(User, { foreignKey: "user_id", allowNull: false });

module.exports = {
  Notification,
};
