const { sequelize, Sequelize } = require("../../db.config");
const { User } = require("./user_model");
const Survey = sequelize.define(
  "survey",
  {
    id: { type: Sequelize.BIGINT, primaryKey: true, autoIncrement: true },
    gender: { type: Sequelize.STRING, allowNull: false },
    ageRange: { type: Sequelize.STRING, allowNull: false },
    employment: { type: Sequelize.STRING, allowNull: false },
    usageFrequency: { type: Sequelize.STRING, allowNull: false },
    internetAccess: { type: Sequelize.STRING, allowNull: false },
    hasBankCard: { type: Sequelize.STRING, allowNull: false },
    paymentMethods: { type: Sequelize.STRING, allowNull: false },
    serviceOffer: { type: Sequelize.STRING, allowNull: false },
    paidFor: { type: Sequelize.STRING, allowNull: false },
    monthlyPremium: { type: Sequelize.STRING, allowNull: false },
    interestDelegating: { type: Sequelize.STRING, allowNull: false },
    providerChallenges: { type: Sequelize.STRING, allowNull: false },
    findProviders: { type: Sequelize.STRING, allowNull: false },
    findingPain: { type: Sequelize.STRING, allowNull: false },
    findingCriteria: { type: Sequelize.STRING, allowNull: false },
    taskFees: { type: Sequelize.STRING, allowNull: false },
    preferredCategories: { type: Sequelize.STRING, allowNull: false },
    transferMoney: { type: Sequelize.STRING, allowNull: false },
    neededFeatures: { type: Sequelize.STRING, allowNull: false },
    escrowPayment: { type: Sequelize.STRING, allowNull: false },
    verifyIdentity: { type: Sequelize.STRING, allowNull: false },
    premiumSubscription: { type: Sequelize.STRING, allowNull: false },
    payPremium: { type: Sequelize.STRING, allowNull: false },
    testUser: { type: Sequelize.STRING, allowNull: false },
    notifyPublic: { type: Sequelize.STRING, allowNull: true },
    otherInternetAccess: { type: Sequelize.STRING, defaultValue: "" },
    otherPaymentMethod: { type: Sequelize.STRING, defaultValue: "" },
    serviceOffering: { type: Sequelize.STRING, defaultValue: "" },
    providerChallengesText: { type: Sequelize.STRING, defaultValue: "" },
    findProvidersText: { type: Sequelize.STRING, defaultValue: "" },
    findingPainText: { type: Sequelize.STRING, defaultValue: "" },
    findingCriteriaText: { type: Sequelize.STRING, defaultValue: "" },
    preferredCategoriesText: { type: Sequelize.STRING, defaultValue: "" },
    neededFeaturesText: { type: Sequelize.STRING, defaultValue: "" },
    escrowPaymenting: { type: Sequelize.STRING, defaultValue: "" },
    openFeedback: { type: Sequelize.STRING, defaultValue: "" },
    testUserFullName: { type: Sequelize.STRING, allowNull: true },
    testUserEmail: { type: Sequelize.STRING, allowNull: true },
    testUserPhone: { type: Sequelize.STRING, allowNull: true },
  },
  {
    tableName: "survey",
    timestamps: true,
  }
);

Survey.belongsTo(User, { as: "user", foreignKey: "user_id", allowNull: true });

module.exports = {
  Survey,
};
