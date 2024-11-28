const { sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { DataTypes } = require("sequelize");
const BalanceTransaction = sequelize.define(
  "balance_transaction",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    type: {
      type: DataTypes.ENUM(
        "taskPayment",
        "taskEarnings",
        "deposit",
        "withdrawal",
        "coinPurchase",
        "boostPurchase",
        "system"
      ),
      allowNull: false,
    },
    amount: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("pending", "completed", "failed"),
      allowNull: false,
      defaultValue: "pending",
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    depositSlip: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    depositType: {
      type: DataTypes.ENUM("bankCard", "installment"),
      allowNull: true,
    },
  },
  {
    tableName: "balance_transaction",
    timestamps: true,
  }
);

BalanceTransaction.belongsTo(User, { foreignKey: "userId", allowNull: false });

module.exports = {
  BalanceTransaction,
};
