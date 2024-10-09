const { sequelize, Sequelize } = require("../../db.config");
const { Category } = require("./category_model");
const { Store } = require("./store_model");
const Service = sequelize.define(
  "service",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    name: { type: Sequelize.STRING, allowNull: false },
    description: { type: Sequelize.STRING, allowNull: false },
    included: { type: Sequelize.STRING },
    notIncluded: { type: Sequelize.STRING },
    notes: { type: Sequelize.STRING },
    price: { type: Sequelize.FLOAT, allowNull: false },
    timeEstimationFrom: { type: Sequelize.FLOAT },
    timeEstimationTo: { type: Sequelize.FLOAT },
    archived: { type: Sequelize.BOOLEAN, defaultValue: false },
  },
  {
    tableName: "service",
    timestamps: true,
  }
);

Service.belongsTo(Store, { foreignKey: "store_id", allowNull: false });
Service.belongsTo(Category, { foreignKey: "category_id", allowNull: false });

module.exports = {
  Service,
};
