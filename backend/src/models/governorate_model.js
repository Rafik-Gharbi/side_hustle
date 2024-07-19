const { sequelize, Sequelize } = require("../../db.config");
const Governorate = sequelize.define(
  "governorate",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    name_fr: { type: Sequelize.STRING, allowNull: true },
    name_ar: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "governorate",
    timestamps: false,
  }
);

module.exports = {
  Governorate,
};
