const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const SupportTicket = sequelize.define(
  "support_ticket",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    category: {
      type: Sequelize.ENUM(
        "generalInquiry",
        "technicalIssue",
        "profileDeletion",
        "paymentIssue"
      ),
      allowNull: false,
    },
    subject: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    description: {
      type: Sequelize.TEXT,
      allowNull: false,
      defaultValue: "",
    },
    status: {
      type: Sequelize.ENUM("open", "pending", "resolved", "closed"),
      defaultValue: "open",
    },
    priority: {
      type: Sequelize.ENUM("low", "medium", "high"),
      defaultValue: "low",
    },
  },
  {
    tableName: "support_ticket",
    timestamps: true,
  }
);

SupportTicket.belongsTo(User, {
  as: "user",
  foreignKey: "user_id",
  allowNull: false,
});
SupportTicket.belongsTo(User, {
  as: "assigned",
  foreignKey: "assigned_to",
  allowNull: true,
});

module.exports = {
  SupportTicket,
};
