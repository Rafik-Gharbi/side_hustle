const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Task } = require("./task_model");
const Reservation = sequelize.define(
  "reservation",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    total_price: { type: Sequelize.FLOAT, allowNull: false },
    proposed_price: { type: Sequelize.FLOAT, allowNull: true },
    coupon: { type: Sequelize.STRING, allowNull: true },
    note: { type: Sequelize.STRING, allowNull: true },
    status: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "reservation",
    timestamps: true,
  }
);

Reservation.belongsTo(Task, { foreignKey: "task_id", allowNull: false });
Reservation.belongsTo(User, { foreignKey: "user_id", allowNull: false });

module.exports = {
  Reservation,
};
