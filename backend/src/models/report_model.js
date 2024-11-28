const { sequelize, Sequelize } = require("../../db.config");
const { Service } = require("./service_model");
const { Task } = require("./task_model");
const { User } = require("./user_model");
const Report = sequelize.define(
  "report",
  {
    id: { type: Sequelize.BIGINT, primaryKey: true, autoIncrement: true },
    reasons: { type: Sequelize.STRING, allowNull: false },
    explanation: { type: Sequelize.STRING, allowNull: true },
    task_id: { type: Sequelize.UUID, allowNull: true },
    service_id: { type: Sequelize.UUID, allowNull: true },
    user_id: { type: Sequelize.BIGINT, allowNull: true },
    reported_id: { type: Sequelize.BIGINT, allowNull: false },
  },
  {
    tableName: "report",
    timestamps: true,
  }
);

Report.belongsTo(Task, { foreignKey: "task_id", allowNull: true });
Report.belongsTo(Service, { foreignKey: "service_id", allowNull: true });
Report.belongsTo(User, { as: "user", foreignKey: "user_id", allowNull: true });
Report.belongsTo(User, {
  as: "reportedUser",
  foreignKey: "reported_id",
  allowNull: false,
});

module.exports = {
  Report,
};
