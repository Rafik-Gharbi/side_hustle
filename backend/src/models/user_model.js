const { sequelize, Sequelize } = require("../../db.config.js");
const { Governorate } = require("./governorate_model.js");

const User = sequelize.define(
  "user",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING },
    email: {
      type: Sequelize.STRING,
      defaultValue: null,
      unique: true,
      validate: {
        isEmail: function (value) {
          if (this.email && !Sequelize.Validator.isEmail(value)) {
            throw new Error("Invalid email address");
          }
        },
      },
    },
    password: { type: Sequelize.STRING },
    gender: { type: Sequelize.STRING },
    birthdate: { type: Sequelize.DATE },
    facebookId: { type: Sequelize.STRING, unique: true },
    googleId: { type: Sequelize.STRING, unique: true },
    picture: { type: Sequelize.STRING },
    phone_number: { type: Sequelize.STRING, unique: true },
    isArchived: { type: Sequelize.BOOLEAN, defaultValue: false },
    isVerified: { type: Sequelize.STRING, defaultValue: "none" },
    isMailVerified: { type: Sequelize.BOOLEAN, defaultValue: false },
    role: { type: Sequelize.STRING, defaultValue: "[provider]" },
  },
  {
    tableName: "user",
  }
);

User.belongsTo(Governorate, { foreignKey: "governorate_id", allowNull: false });

module.exports = {
  User,
};
