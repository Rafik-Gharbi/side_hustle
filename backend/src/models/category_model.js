const { sequelize, Sequelize } = require("../../db.config");
const Category = sequelize.define(
  "category",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    description: { type: Sequelize.STRING, allowNull: false },
    nameFr: { type: Sequelize.STRING, allowNull: true },
    descriptionFr: { type: Sequelize.STRING, allowNull: true },
    nameAr: { type: Sequelize.STRING, allowNull: true },
    descriptionAr: { type: Sequelize.STRING, allowNull: true },
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
