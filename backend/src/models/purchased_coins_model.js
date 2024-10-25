const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const PurchasedCoins = sequelize.define(
  "purchased_coins",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    coins: { type: Sequelize.INTEGER, allowNull: false },
    expiration_date: { type: Sequelize.DATE, allowNull: false }, // when coins expire
    coins_used: { type: Sequelize.INTEGER, defaultValue: 0 }, 
  },
  {
    tableName: "purchased_coins",
    timestamps: true,
  }
);

PurchasedCoins.belongsTo(User, { foreignKey: "user_id", allowNull: false });

module.exports = {
  PurchasedCoins,
};
