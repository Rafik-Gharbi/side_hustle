const { User } = require("../models/user_model");
const { Review } = require("../models/review_model");
const { Governorate } = require("../models/governorate_model");
const { VerificationCode } = require("../models/verification_code");
const { Op } = require("sequelize");
const Bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { sendMail } = require("../helper/email_service");
const {
  sendConfirmationMail,
  contactUsMail,
  forgotPasswordEmailTemplate,
} = require("../views/template_email");
const {
  verifyPhoneNumber,
  calculateDateDifference,
  getDate,
  removeSpacesFromPhoneNumber,
  generateJWT,
  adjustString,
} = require("../helper/helpers");
const {
  downloadImage,
  saveImage,
  extractIdFromGoogleUrl,
} = require("../helper/image");
const { encryptData } = require("../helper/encryption");
const { UserDocumentModel } = require("../models/user_document_model");
const {
  CategorySubscriptionModel,
} = require("../models/category_subscribtion_model");
const {
  NotificationType,
  notificationService,
} = require("../helper/notification_service");
const {
  getMyRequestRequiredActionsCount,
  getTaskHistoryRequiredActionsCount,
  getMyStoreRequiredActionsCount,
  getApproveUsersRequiredActionsCount,
  getServiceHistoryRequiredActionsCount,
} = require("../sql/sql_request");

exports.renewJWT = async (req, res) => {
  try {
    const decodedJwt = req.decoded;
    const user = await User.findByPk(decodedJwt.id);
    const token = await generateJWT(user);
    const refreshToken = await generateJWT(user, true);

    return res.status(200).json({ token, refreshToken });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.signIn = async (req, res) => {
  const { email, phoneNumber, facebookId, googleId, password, isMobile } =
    req.body;
  try {
    // Check if user exists
    let formattedPhoneNumber = removeSpacesFromPhoneNumber(phoneNumber);
    const user = await checkUserExists(
      email,
      formattedPhoneNumber,
      googleId,
      facebookId
    );
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (googleId && user.googleId != googleId) {
      user.googleId = googleId;
    }
    if (facebookId && user.facebookId != facebookId) {
      user.facebookId = facebookId;
    }
    if (!googleId && !facebookId && (email || formattedPhoneNumber)) {
      // If neither googleId nor facebookId matches, verify traditionally with email and password
      if (!password) {
        return res.status(400).json({ message: "missing_password" });
      }
      const isPasswordValid = user.password
        ? await Bcrypt.compare(password, user.password)
        : undefined;
      // if (!isPasswordValid) {
      //   return res.status(401).json({ message: "invalid_credentials" });
      // }
    } else if (!googleId && !facebookId) {
      return res.status(400).json({ message: "missing_credentials" });
    }
    let token, refreshToken;

    // if (picture) {
    //   const pictureName = `${extractIdFromGoogleUrl(picture)}.jpg`;
    //   if (user.picture !== pictureName) {
    //     try {
    //       const name = await downloadImage(picture);
    //       await saveImage(pictureName, name, "user");
    //       user.picture = pictureName;
    //     } catch (error) {
    //       console.error("Error downloading image:", error);
    //     }
    //   }
    // }
    if (!user.isMailVerified) {
      resendConfirmationMail(user, req.host, isMobile);
    }
    await user.save();

    token = await generateJWT(user);

    refreshToken = await generateJWT(user, true);

    return res.status(200).json({ token, refreshToken });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.contactUs = async (req, res) => {
  const { name, body, email, subject, phone } = req.body;
  if (!name || !body || !email || !subject) {
    return res.status(401).json({ message: "missing" });
  }
  try {
    const template = contactUsMail(email, name, subject, body, phone);
    sendMail(
      process.env.AUTH_USER_EMAIL,
      `Contact Us The Landlord - ${subject}`,
      template,
      req.host
    );
    sendMail(
      "reservations@thelandlord.tn",
      `Contact Us The Landlord - ${subject}`,
      template,
      req.host
    );
    sendMail(
      "Sarah.benachour@thelandlord.tn",
      `Contact Us The Landlord - ${subject}`,
      template,
      req.host
    );
    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.signUp = async (req, res) => {
  const {
    email,
    name,
    phoneNumber,
    facebookId,
    picture,
    googleId,
    password,
    birthdate,
    gender,
    governorate,
    isMobile,
    coordinates,
    keepPrivacy,
  } = req.body;

  let formattedPhoneNumber = removeSpacesFromPhoneNumber(phoneNumber);
  try {
    // Check if user exists
    const user = await checkUserExists(
      email,
      formattedPhoneNumber,
      googleId,
      facebookId
    );
    if (user) {
      return res.status(404).json({ message: "user_already_found" });
    }
    if (googleId || facebookId) {
      var newPicture = null;
      // If the user connects with Google or Facebook, no password is needed
      if (picture) {
        const pictureName = `${extractIdFromGoogleUrl(picture)}.jpg`;
        try {
          const name = await downloadImage(picture);
          await saveImage(adjustString(pictureName), name, "images/user");
          newPicture = pictureName;
        } catch (error) {
          console.error("Error downloading image:", error);
        }
      }
      response = await User.create({
        email,
        facebookId,
        picture: newPicture,
        googleId,
        name,
        phone_number: phoneNumber,
        birthdate,
        gender,
        governorate_id: governorate,
        coordinates,
        keepPrivacy,
      });
    } else if (email || formattedPhoneNumber) {
      // If email or phone_number is provided, password must be set
      if (!password) {
        return res.status(400).json({ message: "missing_password" });
      }
      const hashedPass = await Bcrypt.hash(password, 10);

      //if the user used a phone number
      if (formattedPhoneNumber) {
        // we verify if it validate the pattern
        if (!verifyPhoneNumber(formattedPhoneNumber)) {
          return res.status(400).json({ message: "wrong_number" });
        }
      }
      response = await User.create({
        email,
        facebookId,
        picture,
        googleId,
        password: hashedPass,
        name,
        phone_number: phoneNumber,
        birthdate,
        gender,
        governorate_id: governorate,
        coordinates,
        keepPrivacy,
      });
    } else {
      return res.status(400).json({ message: "missing_credentials" });
    }
    const token = await generateJWT(response);

    if (email) {
      //generate code for confrimation mail
      let code = generateRandomCode();

      //save the code in the database
      await VerificationCode.create({
        code,
        user_id: response.id,
      });

      const mailVerificationToken = jwt.sign(
        {
          code: code,
          user_id: response.id,
        },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_MAIL_EXPIRATION }
      );
      const cryptedToken = encryptData(mailVerificationToken);
      //send email
      const template = sendConfirmationMail(
        response.name,
        isMobile ? code : cryptedToken,
        isMobile
      );
      sendMail(response.email, "Confirmation de compte", template, req.host);
    }
    if (formattedPhoneNumber) {
      // const otp = await sendOTP(formattedPhoneNumber);
      // const verificationCode = {
      //   status: otp.status,
      //   phone_number: otp.to,
      //   attempt: otp.sendCodeAttempts.length,
      // };
      // await VerificationCode.create(verificationCode);
    }

    // Return token
    return res.status(200).json({ token });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.subscribeCategory = async (req, res) => {
  const { categories, fcmToken } = req.body;
  try {
    // Check if user exists
    const userId = req.decoded.id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!categories || categories.length == 0) {
      return res.status(400).json({ message: "missing" });
    }
    categories.forEach(async (category) => {
      await CategorySubscriptionModel.create({
        user_id: userId,
        category_id: category.id,
      });
    });
    userFound.fcmToken = fcmToken;
    userFound.save();

    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.profile = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const categories = await CategorySubscriptionModel.findAll({
      where: { user_id: userId },
    });

    let myRequestActionRequired = await getMyRequestRequiredActionsCount(
      userId
    );
    let taskHistoryActionRequired = await getTaskHistoryRequiredActionsCount(
      userId
    );
    let servieHistoryActionRequired =
      await getServiceHistoryRequiredActionsCount(userId);
    let myStoreActionRequired = await getMyStoreRequiredActionsCount(userId);
    let approveUsersActionRequired = await getApproveUsersRequiredActionsCount(
      userId
    );

    return res.status(200).json({
      user: userFound,
      subscribedCategories: categories,
      myRequestActionRequired,
      taskHistoryActionRequired,
      myStoreActionRequired,
      approveUsersActionRequired,
      servieHistoryActionRequired,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getUserById = async (req, res) => {
  try {
    const connectedUserId = req.decoded.id;
    const id = req.query.id;

    const connectedUser = await User.findByPk(connectedUserId);
    if (!connectedUser) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const userFound = await User.findByPk(id);

    const userReviews = await Review.findAll({
      where: { user_id: userFound.id },
    });

    let reviews = [];
    reviews = await Promise.all(
      userReviews.map(async (review) => {
        const reviewee = await User.findOne({
          where: { id: review.reviewee_id },
        });
        return {
          id: review.id,
          message: review.message,
          rating: review.rating,
          reviewee: {
            id: reviewee.id,
            name: reviewee.name,
            governorate_id: reviewee.governorate_id,
            picture: reviewee.picture,
            isVerified: reviewee.isVerified,
          },
          user: {
            id: userFound.id,
            name: userFound.name,
            governorate_id: userFound.governorate_id,
            picture: userFound.picture,
            isVerified: userFound.isVerified,
          },
          quality: review.quality,
          createdAt: review.createdAt,
          fees: review.fees,
          punctuality: review.punctuality,
          politeness: review.politeness,
        };
      })
    );

    return res.status(200).json({
      user: {
        id: userFound.id,
        name: userFound.name,
        governorate_id: userFound.governorate_id,
        picture: userFound.picture,
        isVerified: userFound.isVerified,
      },
      reviews: reviews,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.verifyPhone = async (req, res) => {
  try {
    const { phoneNumber, code, email } = req.body;

    if (!phoneNumber || !code || !email) {
      return res.status(400).json({ message: "missing_credentials" });
    }
    const formattedPhoneNumber = removeSpacesFromPhoneNumber(phoneNumber);

    if (!verifyPhoneNumber(formattedPhoneNumber)) {
      return res.status(400).json({ message: "wrong_number" });
    }

    // const responseVerification = await verifyOTP(formattedPhoneNumber, code);
    // if (responseVerification == "approved") {
    //   const user = await User.findOne({
    //     where: { email: email },
    //   });
    //   if (user) {
    //     user.phone_number = formattedPhoneNumber;
    //     await VerificationCode.destroy({
    //       where: {
    //         phone_number: formattedPhoneNumber,
    //       },
    //     });
    //   } else {
    //     return res.status(404).json({ message: "user_not_found" });
    //   }
    //   await user.save();
    // } else {
    //   return res.status(400).json({ message: "otp_verif_failed" });
    // }
    return res.status(200).json({ message: "otp_approved" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.usersForApproving = async (req, res) => {
  try {
    const connectedUserId = req.decoded.id;

    const connectedUser = await User.findByPk(connectedUserId);
    if (!connectedUser) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const approveUsers = await User.findAll({
      where: { isVerified: "pending" },
    });

    const users = await Promise.all(
      approveUsers.map(async (user) => {
        const userDocument = await UserDocumentModel.findOne({
          where: { user_id: user.id },
        });
        return { user, userDocument };
      })
    );

    return res.status(200).json({ users });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.approveUser = async (req, res) => {
  try {
    const userForApproveId = req.query.userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return res.status(404).json({ message: "user_not_found" });
    }

    userApprove.isVerified = "verified";
    await userApprove.save();

    notificationService.sendNotification(
      userApprove.id,
      "Successfully Approved",
      "Your profile has been approved.",
      NotificationType.VERIFICATION,
      { userId: userApprove.id, Approved: true }
    );

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.userNotApprovable = async (req, res) => {
  try {
    const userForApproveId = req.query.userId;

    const userApprove = await User.findByPk(userForApproveId);
    if (!userApprove) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const userDocument = await UserDocumentModel.findOne({
      where: { user_id: userForApproveId },
    });
    if (!userDocument) {
      return res.status(404).json({ message: "user_document_not_found" });
    }

    userDocument.destroy();
    userApprove.isVerified = "none";
    await userApprove.save();

    notificationService.sendNotification(
      userApprove.id,
      "Failed to Approve",
      "Your profile hasn't been approved. Probably your profile is missing some needed data or your provided documents weren't acceptable.",
      NotificationType.VERIFICATION,
      { userId: userApprove.id, Approved: false }
    );
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.socialMedia = async (req, res) => {
  try {
    console.log(req.body);
    const { facebookId, googleId, email, name } = req.body;
    const userFound = await User.findByPk(req.decoded.id);
    console.log(userFound.email);
    const updatedUser = await userFound.update({
      facebookId: facebookId ?? null,
      googleId: googleId ?? null,
      email: userFound.email && userFound.email != "" ? userFound.email : email,
      name: userFound.name && userFound.name != "" ? userFound.name : name,
    });

    // await userFound.save();
    return res.status(200).json({ updatedUser });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// Find a single User with token
exports.checkVerificationUser = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "account_not_found" });
    }
    return res.status(200).json({ verified: userFound.isMailVerified });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

//verify mail by userId
exports.verifyMail = async (req, res) => {
  try {
    const userId = req.decoded.user_id;
    const userEmail = req.decoded.email;
    const code = req.decoded.code ? req.decoded.code : req.decoded;
    const user = userId
      ? await User.findByPk(userId)
      : await User.findOne({
          where: { email: userEmail },
        });

    if (!user) {
      return res.status(401).send({ message: "account_not_found" });
    }

    const verificationCode = await VerificationCode.findOne({
      where: { user_id: user.id },
    });

    if (verificationCode && code == verificationCode.code) {
      if (user.isMailVerified) {
        return res.status(400).send({ message: "already_verified" });
      }
      user.isMailVerified = true;
      await user.save();

      verificationCode.destroy();

      token = await generateJWT(user);
      return res.status(200).json({ token });
    } else {
      return res.status(400).send({ message: "already_verified" });
    }
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// Resend verification mail to user
exports.resendVerification = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const isMobile = req.body.isMobile;
    var verificationCode;
    const user = await User.findByPk(userId);
    if (user.isMailVerified) {
      return res.status(404).json({ message: "already_verified" });
    }
    verificationCode = await resendConfirmationMail(user, req.host, isMobile);

    return res.status(200).json({ message: verificationCode });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

async function createAndSaveCode(userId, type) {
  const code = generateRandomCode();
  await VerificationCode.create({ code, user_id: userId, type: type });
  return code;
}

// Main controller function
exports.emailForgotPassword = async (req, res) => {
  const email = req.body.email;
  if (!email) {
    return res.status(401).json({ message: "email_missing" });
  }

  try {
    const foundUser = await User.findOne({ where: { email } });
    if (!foundUser) {
      return res.status(401).json({ message: "user_not_found" });
    }

    const foundCode = await VerificationCode.findOne({
      where: {
        [Op.and]: [{ type: "forgotPassword", user_id: foundUser.id }],
      },
    });

    let code;
    if (foundCode) {
      const currentdate = new Date();
      const foundCodeCreatedAt = new Date(foundCode.createdAt);
      const minuteDiff = calculateDateDifference(
        foundCodeCreatedAt,
        currentdate,
        "minutes"
      );

      if (minuteDiff >= 30) {
        await foundCode.destroy();
        code = await createAndSaveCode(foundUser.id, "forgotPassword");
      } else {
        code = foundCode.code; // Reuse the existing code
      }
    } else {
      code = await createAndSaveCode(foundUser.id, "forgotPassword");
    }

    const templateUser = forgotPasswordEmailTemplate(code);
    sendMail(foundUser.email, "Forgot Password Code", templateUser, req.host);

    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.error(`Error at ${req.route.path}`, error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

exports.forgotPassword = async (req, res) => {
  const { newPassword, code } = req.body;
  if (!newPassword || !code) {
    return res.status(401).json({ message: "missing" });
  }
  try {
    const foundCode = await VerificationCode.findOne({
      where: {
        code: code,
        type: "forgotPassword",
      },
      include: [
        {
          model: User,
          as: "user",
        },
      ],
    });
    if (!foundCode) {
      return res.status(401).json({ message: "code_not_found" });
    }
    if (foundCode.user.password) {
      const samePassword = await Bcrypt.compare(
        newPassword,
        foundCode.user.password
      );
      if (samePassword) {
        return res.status(401).json({ message: "same_password" });
      }
    }
    const hashedPass = await Bcrypt.hash(newPassword, 10);
    foundCode.user.password = hashedPass;
    await foundCode.user.save();
    await foundCode.destroy();
    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updatePassword = async (req, res) => {
  if (!req.body.newPassword) {
    return res.status(404).json({ message: "new_password_missing" });
  }
  if (!req.body.currentPassword) {
    return res.status(404).json({ message: "current_password_missing" });
  }
  try {
    var userFound = await User.findByPk(req.decoded.id);
    if (userFound.password) {
      const wrontPassword = await Bcrypt.compare(
        req.body.currentPassword,
        userFound.password
      );
      if (!wrontPassword) {
        return res.status(400).json({ message: "wrong_password" });
      }
      const samePassword = await Bcrypt.compare(
        req.body.newPassword,
        userFound.password
      );
      if (samePassword) {
        return res.status(400).json({ message: "same_password" });
      }
    }
    const hashedPass = await Bcrypt.hash(req.body.newPassword, 10);
    userFound.password = hashedPass;
    await userFound.save();
    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateProfile = async (req, res) => {
  const {
    email,
    phone,
    name,
    governorate,
    birthdate,
    gender,
    coordinates,
    keepPrivacy,
    bio,
  } = req.body;
  const formattedPhoneNumber = removeSpacesFromPhoneNumber(phone);
  try {
    const userFound = await User.findByPk(req.decoded.id);
    if (userFound.email && !email) {
      return res.status(400).json({ message: "mail_missing" });
    }
    if (userFound.phone_number && !formattedPhoneNumber) {
      return res.status(400).json({ message: "phone_missing" });
    }
    if (userFound.name && !name) {
      return res.status(400).json({ message: "name_missing" });
    }
    if (userFound.governorate && !governorate) {
      return res.status(400).json({ message: "governorate_missing" });
    }
    if (userFound.birthdate && !birthdate) {
      return res.status(400).json({ message: "birthdate_missing" });
    }
    if (userFound.gender && !gender) {
      return res.status(400).json({ message: "gender_missing" });
    }
    if (userFound.phone_number && !verifyPhoneNumber(formattedPhoneNumber)) {
      return res.status(400).json({ message: "wrong_number" });
    }
    //we either change the new profilPic if sended, or we put the same picture
    let picture = req.files?.photo?.[0].filename ?? userFound.picture;

    const updatedUser = await userFound.update({
      name,
      email,
      picture,
      governorate_id: governorate,
      birthdate,
      gender,
      coordinates,
      keepPrivacy,
      // bio,
    });
    req.files?.gallery?.forEach(async (image) => {
      await Governorate.create({
        url: image.filename,
        user_id: userFound.id,
      });
    });
    if (formattedPhoneNumber != userFound.phone_number) {
      const foundedCode = await VerificationCode.findOne({
        where: {
          user_id: userFound.id,
        },
      });
      if (foundedCode && foundedCode.attempt > 4) {
        return res.status(401).json({ message: "too_many_otp" });
      }
    }
    const jwt = await generateJWT(updatedUser);
    return res.status(200).json({ updatedUser, jwt });
  } catch (error) {
    const errorMessage = error.errors?.[0].message || error.message;
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: errorMessage });
  }
};

exports.verifyIdentity = async (req, res) => {
  try {
    const userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!req.files?.gallery || req.files?.gallery.length == 0) {
      return res.status(400).json({ message: "missing" });
    }

    if (req.files?.gallery?.length == 3) {
      await UserDocumentModel.create({
        front_identity: req.files?.gallery[0].filename,
        back_identity: req.files?.gallery[1].filename,
        selfie: req.files?.gallery[2].filename,
        user_id: userFound.id,
      });
    } else if (req.files?.gallery?.length == 2) {
      await UserDocumentModel.create({
        passport: req.files?.gallery[0].filename,
        selfie: req.files?.gallery[1].filename,
        user_id: userFound.id,
      });
    } else {
      return res.status(400).json({ message: "missing" });
    }
    userFound.isVerified = "pending";
    await userFound.save();

    const jwt = await generateJWT(userFound);

    notificationService.sendNotificationToAdmin(
      "New User Verification",
      "A new user has submitted his document, check them out.",
      NotificationType.VERIFICATION,
      { userId: userFound.id, isAdmin: true }
    );

    return res.status(200).json({ message: "done", jwt: jwt });
  } catch (error) {
    const errorMessage = error.errors?.[0].message || error.message;
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: errorMessage });
  }
};

exports.userActionsRequiredCount = async (req, res) => {
  try {
    const userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let myRequestActionRequired = await getMyRequestRequiredActionsCount(
      userFound.id
    );
    let taskHistoryActionRequired = await getTaskHistoryRequiredActionsCount(
      userFound.id
    );
    let myStoreActionRequired = await getMyStoreRequiredActionsCount(
      userFound.id
    );
    let approveUsersActionRequired = 0;
    if (userFound.role === "admin")
      approveUsersActionRequired = await getApproveUsersRequiredActionsCount(
        userFound.id
      );
    let servieHistoryActionRequired =
      await getServiceHistoryRequiredActionsCount(userFound.id);
    const categories = await CategorySubscriptionModel.findAll({
      where: { user_id: userFound.id },
    });

    let count =
      myRequestActionRequired +
      taskHistoryActionRequired +
      myStoreActionRequired +
      servieHistoryActionRequired +
      approveUsersActionRequired;
    if (categories.length == 0) count++;
    return res.status(200).json({ count });
  } catch (error) {
    const errorMessage = error.errors?.[0].message || error.message;
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: errorMessage });
  }
};

const checkUserExists = async (email, phoneNumber, googleId, facebookId) => {
  try {
    let whereClause = {};

    // Build the where clause based on provided email, phoneNumber, googleId, and facebookId
    const conditions = [];
    if (email) {
      conditions.push({ email });
    }
    if (phoneNumber) {
      conditions.push({ phone_number: phoneNumber });
    }
    if (googleId) {
      conditions.push({ googleId });
    }
    if (facebookId) {
      conditions.push({ facebookId });
    }

    // Define the role exclusion condition separately
    const roleCondition = { role: { [Op.notLike]: "%partner%" } };

    // Combine conditions with role exclusion
    if (conditions.length > 0) {
      whereClause = {
        [Op.and]: [{ [Op.or]: conditions }, roleCondition],
      };
    } else {
      // If no email, phoneNumber, googleId, or facebookId provided, still apply role exclusion
      whereClause = roleCondition;
    }

    const user = await User.findOne({ where: whereClause });

    return user ? user : null;
  } catch (error) {
    console.error(`Error in checkUserExists function`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return null;
  }
};

function generateRandomCode() {
  // Generate a random number between 100000 and 999999
  const randomNum = Math.floor(Math.random() * 900000) + 100000;
  // Convert the random number to a string and return it
  return randomNum.toString();
}

async function resendConfirmationMail(user, host, isMobile) {
  var verificationCode;
  verificationCode = await VerificationCode.findOne({
    where: { user_id: user.id },
  });
  if (!verificationCode) {
    verificationCode = await VerificationCode.create({
      user_id: user.id,
      code: generateRandomCode(),
    });
  } else {
    const dayDiff = calculateDateDifference(
      verificationCode.createdAt,
      getDate(),
      "hours"
    );
    //we can change this
    if (dayDiff < 1) {
      return "mail_already_sent";
    }
  }
  const mailVerificationToken = jwt.sign(
    {
      code: verificationCode.code,
      user_id: user.id,
    },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_MAIL_EXPIRATION }
  );

  const cryptedToken = encryptData(mailVerificationToken);

  //prepare mail to send for the user with code
  const template = sendConfirmationMail(
    user.name,
    isMobile ? verificationCode.code : cryptedToken,
    isMobile
  );
  sendMail(user.email, "Confirmation de compte", template, host);
  return verificationCode.code;
}

// cron.schedule("0 0 * * *", async () => {
//   try {
//     await VerificationCode.destroy({ where: {} });
//     console.log("Deleted rows successfully.");
//   } catch (error) {
//     console.error("Error occurred while deleting rows:", error);
//   }
// });
