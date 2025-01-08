const { sequelize, Sequelize } = require("../../db.config");
const Governorate = sequelize.define(
  "governorate",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    nameFr: { type: Sequelize.STRING, allowNull: true },
    nameAr: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "governorate",
    timestamps: false,
  }
);

module.exports = {
  Governorate,
};
