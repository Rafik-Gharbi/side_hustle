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
  },
  {
    tableName: "report",
    timestamps: false,
  }
);

Report.belongsTo(Task, { foreignKey: "task_id", allowNull: true });
Report.belongsTo(Service, { foreignKey: "service_id", allowNull: true });
Report.belongsTo(User, { foreignKey: "user_id", allowNull: false });
Report.belongsTo(User, { foreignKey: "reported_id", allowNull: false });

module.exports = {
  Report,
};
