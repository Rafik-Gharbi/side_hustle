const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Review = sequelize.define(
  "review",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    message: { type: Sequelize.TEXT },
    picture: { type: Sequelize.TEXT },
    rating: { type: Sequelize.DOUBLE, allowNull: false },
    quality: { type: Sequelize.DOUBLE },
    fees: { type: Sequelize.DOUBLE },
    puctuality: { type: Sequelize.DOUBLE },
    politeness: { type: Sequelize.DOUBLE },
  },
  {
    tableName: "review",
    timestamps: true,
  }
);
Review.belongsTo(User, { foreignKey: "user_id" });
Review.belongsTo(User, { foreignKey: "reviewee_id" });

module.exports = {
  Review,
};
