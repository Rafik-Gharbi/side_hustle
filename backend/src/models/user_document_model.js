const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");

const UserDocumentModel = sequelize.define(
  "user_document",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    front_identity: { type: Sequelize.STRING },
    back_identity: { type: Sequelize.STRING },
    passport: { type: Sequelize.STRING },
    selfie: { type: Sequelize.STRING },
  },
  {
    tableName: "user_document",
  }
);
UserDocumentModel.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
  onDelete: "CASCADE",
});
module.exports = {
  UserDocumentModel,
};
