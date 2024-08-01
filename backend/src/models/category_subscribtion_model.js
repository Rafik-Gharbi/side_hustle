const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Category } = require("./category_model");

const CategorySubscriptionModel = sequelize.define(
  "category_subscription",
  {},
  {
    tableName: "category_subscription",
    timestamps: true,
  }
);

CategorySubscriptionModel.belongsTo(User, { foreignKey: "user_id" });
CategorySubscriptionModel.belongsTo(Category, { foreignKey: "category_id" });

module.exports = {
  CategorySubscriptionModel,
};
