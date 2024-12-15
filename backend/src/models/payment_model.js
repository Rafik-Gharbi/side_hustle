const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Reservation } = require("./reservation_model");
const { Contract } = require("./contract_model");
const { Task } = require("./task_model");
const { Service } = require("./service_model");
const { CoinPack } = require("./coin_pack_model");
const Payment = sequelize.define(
  "payment",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    total_price: { type: Sequelize.FLOAT, allowNull: false },
    payment_type: {
      type: Sequelize.ENUM("flouci", "deposit", "bankCard", "balance"),
      allowNull: false,
    },
    status: {
      type: Sequelize.ENUM("created", "success", "failed", "canceled"),
      defaultValue: "created",
    },
    provider_payment_id: { type: Sequelize.STRING, allowNull: true }, // refer to flouci payment id (for verifying payment status)
    is_boost: { type: Sequelize.BOOLEAN, allowNull: true },
  },
  {
    tableName: "payment",
    timestamps: true,
  }
);

// contract_id, task_id, service_id, coin_pack_id, and is_boost are meant for refering to the payment object
Payment.belongsTo(Contract, { foreignKey: "contract_id", allowNull: true });
Payment.belongsTo(Task, { foreignKey: "task_id", allowNull: true });
Payment.belongsTo(Service, { foreignKey: "service_id", allowNull: true });
Payment.belongsTo(CoinPack, { foreignKey: "coin_pack_id", allowNull: true });
Payment.belongsTo(User, { foreignKey: "user_id" });

module.exports = {
  Payment,
};
