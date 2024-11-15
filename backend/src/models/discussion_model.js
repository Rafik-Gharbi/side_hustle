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
Discussion.belongsTo(User, { as: "user", foreignKey: "user_id" });
Discussion.belongsTo(User, { as: "owner", foreignKey: "owner_id" });

module.exports = {
  Discussion,
};
