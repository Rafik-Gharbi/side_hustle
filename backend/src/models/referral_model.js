const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Referral = sequelize.define(
  "referral",
  {
    id: { type: Sequelize.BIGINT, primaryKey: true, autoIncrement: true },
    status: {
      type: Sequelize.STRING,
      allowNull: false,
      defaultValue: "pending", // 'pending', 'registered', 'activated'
    },
    reward_coins: {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },
    transaction_date: { type: Sequelize.DATE, allowNull: true },
    registration_date: { type: Sequelize.DATE, allowNull: true },
  },
  {
    tableName: "referral",
    timestamps: true,
  }
);

Referral.belongsTo(User, { foreignKey: "referrer_id", allowNull: false });
Referral.belongsTo(User, {
  as: "referred_user",
  foreignKey: "referred_user_id",
  allowNull: false,
});

module.exports = {
  Referral,
};
