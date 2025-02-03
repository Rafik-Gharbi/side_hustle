const { Governorate } = require("../models/governorate_model");
const { Category } = require("../models/category_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const { User } = require("../models/user_model");
const { Report } = require("../models/report_model");
const { Feedback } = require("../models/feedback_model");
const { CoinPack } = require("../models/coin_pack_model");
const { contactUsMail } = require("../views/template_email");
const { sendMail } = require("../helper/email_service");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { Survey } = require("../models/survey_model");

// check backend is reachable
exports.checkCurrentVersion = async (req, res) => {
  try {
    const version = process.env.APP_VERSION;
    return res.status(200).json({ result: true, version: version });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// get all regions
exports.getAllGovernorates = async (req, res) => {
  try {
    const lang = req.params.lang;
    let governorates = await Governorate.findAll();
    governorates = governorates.map((row) => ({
      id: row.id,
      name: lang === "ar" ? row.nameAr : lang === "fr" ? row.nameFr : row.name,
    }));
    return res.status(200).json({ governorates });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// get all categories
exports.getAllCategories = async (req, res) => {
  try {
    const lang = req.params.lang;
    let categories = await Category.findAll();
    const populatedCategories = await Promise.all(
      categories.map(async (row) => {
        let subscribedUsers = await CategorySubscriptionModel.findAll({
          where: { category_id: row.id },
        });

        let subscribedCount = subscribedUsers.length;

        if (row.parentId === -1) {
          const childCategories = categories.filter(
            (category) => category.parentId === row.id
          );
          for (const child of childCategories) {
            let childSubscribedUsers = await CategorySubscriptionModel.findAll({
              where: { category_id: child.id },
            });
            subscribedCount += childSubscribedUsers.length;
          }
        }

        return {
          id: row.id,
          name:
            lang === "ar" ? row.nameAr : lang === "fr" ? row.nameFr : row.name,
          description:
            lang === "ar"
              ? row.descriptionAr
              : lang === "fr"
              ? row.descriptionFr
              : row.description,
          icon: row.icon,
          parentId: row.parentId,
          subscribed: subscribedCount,
        };
      })
    );
    return res.status(200).json({ categories: populatedCategories });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getCoinPacks = async (req, res) => {
  try {
    const lang = req.params.lang;
    let coins = await CoinPack.findAll();
    for (let i = 0; i < coins.length; i++) {
      coins[i].title =
        lang === "ar"
          ? coins[i].titleAr
          : lang === "fr"
          ? coins[i].titleFr
          : coins[i].title;
      coins[i].description =
        lang === "ar"
          ? coins[i].descriptionAr
          : lang === "fr"
          ? coins[i].descriptionFr
          : coins[i].description;
      coins[i].bonusMsg =
        lang === "ar"
          ? coins[i].bonusMsgAr
          : lang === "fr"
          ? coins[i].bonusMsgFr
          : coins[i].bonusMsg;
    }
    return res.status(200).json({ coins });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.sendMail = async (req, res) => {
  try {
    const template = contactUsMail("email", "name", "subject", "body", "phone");
    sendMail(
      process.env.AUTH_USER_EMAIL,
      `Contact Us Dootify - Testing`,
      template,
      req.hostname
    );
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getMaxTaskPrice = async (req, res) => {
  try {
    const maxPrice = await Task.max("price");
    return res.status(200).json({ max: maxPrice });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getMaxServicePrice = async (req, res) => {
  try {
    const maxPrice = await Service.max("price");
    return res.status(200).json({ max: maxPrice });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.reportUser = async (req, res) => {
  try {
    const { user, reportedUser, task, service, reasons, explanation } =
      req.body;
    if ((!task && !service) || !reasons) {
      return res.status(400).json({ message: "missing" });
    }

    const existUser = await User.findOne({ where: { id: reportedUser.id } });
    if (!existUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await Report.create({
      reasons,
      explanation,
      task_id: task?.id,
      service_id: service?.id,
      user_id: req.decoded?.id ?? user?.id,
      reported_id: existUser.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.feedback = async (req, res) => {
  try {
    const { feedback, comment } = req.body;
    if (!feedback) {
      return res.status(400).json({ message: "missing" });
    }

    await Feedback.create({
      feedback,
      comment,
      user_id: req.decoded?.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.survey = async (req, res) => {
  try {
    await Survey.create({
      gender: req.body.gender,
      ageRange: req.body.ageRange,
      cityFrom: req.body.cityFrom,
      employment: req.body.employment,
      usageFrequency: req.body.usageFrequency,
      internetAccess: req.body.internetAccess,
      hasBankCard: req.body.hasBankCard,
      paymentMethods: req.body.paymentMethods,
      serviceOffer: req.body.serviceOffer,
      paidFor: req.body.paidFor,
      annualMarketing: req.body.annualMarketing,
      currentlyDelegating: req.body.currentlyDelegating,
      currentlyDelegatingWith: req.body.currentlyDelegatingWith,
      interestDelegating: req.body.interestDelegating,
      providerChallenges: req.body.providerChallenges,
      findProviders: req.body.findProviders,
      findingPain: req.body.findingPain,
      findingCriteria: req.body.findingCriteria,
      taskFees: req.body.taskFees,
      preferredCategories: req.body.preferredCategories,
      transferMoney: req.body.transferMoney,
      neededFeatures: req.body.neededFeatures,
      escrowPayment: req.body.escrowPayment,
      verifyIdentity: req.body.verifyIdentity,
      premiumSubscription: req.body.premiumSubscription,
      payPremium: req.body.payPremium,
      testUser: req.body.testUser,
      notifyPublic: req.body.notifyPublic,
      otherInternetAccess: req.body.otherInternetAccess,
      otherPaymentMethod: req.body.otherPaymentMethod,
      serviceOffering: req.body.serviceOffering,
      providerChallengesText: req.body.providerChallengesText,
      findProvidersText: req.body.findProvidersText,
      findingPainText: req.body.findingPainText,
      findingCriteriaText: req.body.findingCriteriaText,
      preferredCategoriesText: req.body.preferredCategoriesText,
      neededFeaturesText: req.body.neededFeaturesText,
      escrowPaymenting: req.body.escrowPaymenting,
      openFeedback: req.body.openFeedback,
      testUserFullName: req.body.testUserFullName,
      testUserEmail: req.body.testUserEmail,
      testUserPhone: req.body.testUserPhone,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
