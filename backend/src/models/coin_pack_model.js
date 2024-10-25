const { sequelize, Sequelize } = require("../../db.config");
const CoinPack = sequelize.define(
  "coin_pack",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    title: { type: Sequelize.STRING, allowNull: false },
    price: { type: Sequelize.INTEGER, allowNull: false },
    save: { type: Sequelize.INTEGER, allowNull: true },
    description: { type: Sequelize.STRING, allowNull: false },
    bonus: { type: Sequelize.INTEGER, allowNull: true },
    bonusMsg: { type: Sequelize.STRING, allowNull: true },
    totalCoins: { type: Sequelize.INTEGER, allowNull: false },
    validMonths: { type: Sequelize.INTEGER, allowNull: false },
  },
  {
    tableName: "coin_pack",
    timestamps: true,
  }
);

module.exports = {
  CoinPack,
};
