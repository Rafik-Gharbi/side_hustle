const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Parameters = sequelize.define(
  "parameters",
  {
    id: {
      type: Sequelize.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    langue: {
      type: Sequelize.ENUM("french", "english"),
      defaultValue: "french",
    },
    theme: {
      type: Sequelize.ENUM("light", "dark"),
      defaultValue: "light",
    },
    currency: {
      type: Sequelize.ENUM("euro", "dtn", "dollar"),
      defaultValue: "dtn",
    },
    stayLoggedIn: {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
    },
    createdAt: {
      type: Sequelize.DATE,
    },
    updatedAt: {
      type: Sequelize.DATE,
    },
  },
  {
    tableName: "parameters",
    timestamps: true,
  }
);
Parameters.belongsTo(User, { foreignKey: "user_id" });

module.exports = {
  Parameters,
};
