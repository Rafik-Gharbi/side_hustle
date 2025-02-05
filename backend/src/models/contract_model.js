const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const { Reservation } = require("./reservation_model");
const Contract = sequelize.define(
  "contract",
  {
    id: {
      type: Sequelize.UUID,
      defaultValue: Sequelize.UUIDV4,
      primaryKey: true,
    },
    finalPrice: { type: Sequelize.FLOAT, allowNull: false },
    dueDate: { type: Sequelize.DATE, allowNull: true },
    isSigned: { type: Sequelize.BOOLEAN, defaultValue: false },
    isPayed: { type: Sequelize.BOOLEAN, defaultValue: false },
    description: { type: Sequelize.STRING, allowNull: false },
    delivrables: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "contract",
    timestamps: true,
  }
);

Contract.belongsTo(Reservation, { foreignKey: "reservation_id", allowNull: false });
Contract.belongsTo(User, {
  as: "seeker",
  foreignKey: "seeker_id",
  allowNull: false,
});
Contract.belongsTo(User, {
  as: "provider",
  foreignKey: "provider_id",
  allowNull: false,
});

module.exports = {
  Contract,
};
