const { sequelize, Sequelize } = require("../../db.config");
const Category = sequelize.define(
  "category",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    name_fr: { type: Sequelize.STRING, allowNull: true },
    name_ar: { type: Sequelize.STRING, allowNull: true },
    icon: { type: Sequelize.STRING, allowNull: false },
    parentId: { type: Sequelize.INTEGER, allowNull: false, default: -1 },
  },
  {
    tableName: "category",
    timestamps: false,
  }
);

module.exports = {
  Category,
};
