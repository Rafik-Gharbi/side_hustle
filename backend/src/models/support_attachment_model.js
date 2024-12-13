const { sequelize, Sequelize } = require("../../db.config");
const { SupportMessage } = require("./support_message");
const { SupportTicket } = require("./support_ticket");
const SupportAttachmentModel = sequelize.define(
  "support_attachment",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    url: { type: Sequelize.STRING },
    type: { type: Sequelize.STRING },
  },
  {
    tableName: "support_attachment",
  }
);

SupportAttachmentModel.belongsTo(SupportTicket, {
  foreignKey: "ticket_id",
  onDelete: "CASCADE",
  allowNull: true,
});
SupportAttachmentModel.belongsTo(SupportMessage, {
  foreignKey: "message_id",
  onDelete: "CASCADE",
  allowNull: true,
});

module.exports = {
  SupportAttachmentModel,
};
