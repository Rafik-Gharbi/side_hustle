const { sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Discussion = sequelize.define(
  "discussion",
  {},
  {
    tableName: "discussion",
    timestamps: true,
  }
);
Discussion.belongsTo(User, { foreignKey: "user_id" });
Discussion.belongsTo(User, { foreignKey: "owner_id" });

module.exports = {
  Discussion,
};
