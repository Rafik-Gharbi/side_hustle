const { sequelize, Sequelize } = require("../../db.config");
const { Discussion } = require("./discussion_model");
const { User } = require("./user_model");
const Chat = sequelize.define(
  "chat",
  {
    message: { type: Sequelize.STRING },
    seen: { type: Sequelize.BOOLEAN, defaultValue: false },
  },
  {
    tableName: "chat",
    timestamps: true,
  }
);
Chat.belongsTo(User, { foreignKey: "sender_id" });
Chat.belongsTo(User, { foreignKey: "reciever_id" });
Chat.belongsTo(Discussion, { foreignKey: "discussion_id" });

module.exports = {
  Chat,
};
