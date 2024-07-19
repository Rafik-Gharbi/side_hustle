const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");

const VerificationCode = sequelize.define(
  "verification_code",
  {
    code: {
      type: Sequelize.STRING,
    },
    status: {
      type: Sequelize.STRING,
    },
    phone_number: {
      type: Sequelize.STRING,
    },
    attempt: {
      type: Sequelize.INTEGER,
    },
    type: {
      type: Sequelize.ENUM("otp", "forgotPassword"),
      allowNull: true,
    },
  },
  {
    tableName: "verification_code",
  }
);
VerificationCode.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE",
});
module.exports = {
  VerificationCode,
};
