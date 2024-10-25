const { sequelize, Sequelize } = require("../../db.config");
const { CoinPack } = require("./coin_pack_model");
const { User } = require("./user_model");
const CoinPackPurchase = sequelize.define(
  "coin_pack_purchase",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    available: { type: Sequelize.INTEGER, allowNull: false },
  },
  {
    tableName: "coin_pack_purchase",
    timestamps: true,
  }
);

CoinPackPurchase.belongsTo(User, { foreignKey: "user_id", allowNull: false });
CoinPackPurchase.belongsTo(CoinPack, { foreignKey: "coin_pack_id", allowNull: false });

module.exports = {
  CoinPackPurchase,
};
