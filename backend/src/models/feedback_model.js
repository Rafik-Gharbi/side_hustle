const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Feedback = sequelize.define(
  "feedback",
  {
    id: { type: Sequelize.BIGINT, primaryKey: true, autoIncrement: true },
    feedback: { type: Sequelize.STRING, allowNull: false },
    comment: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "feedback",
    timestamps: true,
  }
);

Feedback.belongsTo(User, { as: "user", foreignKey: "user_id", allowNull: false });

module.exports = {
  Feedback,
};
