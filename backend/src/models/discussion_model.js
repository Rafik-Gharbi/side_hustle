const { sequelize } = require("../../db.config");
const { Reservation } = require("./reservation_model");
const { User } = require("./user_model");
const Discussion = sequelize.define(
  "discussion",
  {},
  {
    tableName: "discussion",
    timestamps: true,
  }
);
Discussion.belongsTo(Reservation, { as: "reservation", foreignKey: "reservation_id" });
Discussion.belongsTo(User, { as: "user", foreignKey: "user_id" });
Discussion.belongsTo(User, { as: "owner", foreignKey: "owner_id" });

module.exports = {
  Discussion,
};
