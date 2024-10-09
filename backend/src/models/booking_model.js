const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Service } = require("./service_model");
const Booking = sequelize.define(
  "booking",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    total_price: { type: Sequelize.FLOAT, allowNull: false },
    coupon: { type: Sequelize.STRING, allowNull: true },
    note: { type: Sequelize.STRING, allowNull: true },
    status: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "booking",
    timestamps: true,
  }
);

Booking.belongsTo(Service, { foreignKey: "service_id", allowNull: false });
Booking.belongsTo(User, { foreignKey: "user_id", allowNull: false });

module.exports = {
  Booking,
};
