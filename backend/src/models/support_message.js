const { sequelize, Sequelize } = require("../../db.config");
const { SupportTicket } = require("./support_ticket");
const { User } = require("./user_model");
const SupportMessage = sequelize.define(
  "support_message",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    message: {
      type: Sequelize.STRING,
      allowNull: false,
    },
    guest_id: {
      type: Sequelize.STRING,
      allowNull: true,
    },
    attachment: { type: Sequelize.STRING },
  },
  {
    tableName: "support_message",
    timestamps: true,
  }
);

SupportMessage.belongsTo(User, {
  as: "user",
  foreignKey: "sender_id",
  allowNull: true,
});
SupportMessage.belongsTo(SupportTicket, {
  foreignKey: "ticket_id",
  allowNull: false,
});

module.exports = {
  SupportMessage,
};
