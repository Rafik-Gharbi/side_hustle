const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");

const VerificationCode = sequelize.define(
  "verification_code",
  {
    code: {
      type: Sequelize.STRING,
    },
    // status: {
    //   type: Sequelize.ENUM("pending", "used"),
    //   defaulValue: "pending",
    // },
    phone_number: {
      type: Sequelize.STRING,
    },
    email: {
      type: Sequelize.STRING,
    },
    attempt: {
      type: Sequelize.INTEGER,
      defaultValue: 0,
    },
    type: {
      type: Sequelize.ENUM("otp", "forgotPassword"),
      allowNull: true,
      defaultValue: "otp",
    },
  },
  {
    tableName: "verification_code",
    timestamps: true,
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
