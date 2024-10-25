const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Service } = require("./service_model");
const { Task } = require("./task_model");
const { CoinPackPurchase } = require("./coin_pack_purchase_model");
const Transaction = sequelize.define(
  "transaction",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    coins: { type: Sequelize.INTEGER, allowNull: false },
    type: { type: Sequelize.STRING, defaultValue: "proposal" }, // { proposal, refund, purchase, monthlyReset, initialCoins, request }
    status: { type: Sequelize.STRING, defaultValue: "pending" }, // { pending, completed, refunded }
  },
  {
    tableName: "transaction",
    timestamps: true,
  }
);

Transaction.belongsTo(CoinPackPurchase, { foreignKey: "coin_pack_id", allowNull: true });
Transaction.belongsTo(Service, { foreignKey: "service_id", allowNull: true });
Transaction.belongsTo(Task, { foreignKey: "task_id", allowNull: true });
Transaction.belongsTo(User, { foreignKey: "user_id", allowNull: false });

module.exports = {
  Transaction,
};
