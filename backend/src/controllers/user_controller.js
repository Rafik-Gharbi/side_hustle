const cron = require("node-cron");
const { User } = require("../models/user_model");
const { Review } = require("../models/review_model");
const { Governorate } = require("../models/governorate_model");
const { VerificationCode } = require("../models/verification_code");
const { Op } = require("sequelize");
const bcrypt = require("bcrypt");
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
  generateUniqueReferralCode,
  getFileType,
  normalizeCode,
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
  getTaskHistoryRequiredActionsCount: getMyOffersRequiredActionsCount,
  getMyStoreRequiredActionsCount,
  getApproveUsersRequiredActionsCount,
  populateSupportTickets,
  populateSupportMessages,
} = require("../sql/sql_request");
const { Reservation } = require("../models/reservation_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { Boost } = require("../models/boost_model");
const { Transaction } = require("../models/transaction_model");
const { Referral } = require("../models/referral_model");
const { getAdminRequiredActionsCount } = require("./admin_controller");
const { SupportTicket } = require("../models/support_ticket");
const { SupportMessage } = require("../models/support_message");
const {
  SupportAttachmentModel,
} = require("../models/support_attachment_model");

exports.sendTestMail = async (req, res) => {
  try {
    let code = generateRandomCode();
    // const template = forgotPasswordEmailTemplate(code);
    // const template = contactUsMail("email", "name", "subject", "body", "phone");
    const template = sendConfirmationMail("Rafik Test", code, true);
    sendMail(
      "rafik.gharbi@icloud.com",
      "Contact Us Dootify - Testing",
      template
    );
    return res.status(200).json({ message: "done" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

exports.renewJWT = async (req, res) => {
  try {
    const decodedJwt = req.decoded;
    const user = decodedJwt ? await User.findByPk(decodedJwt.id) : undefined;
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
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
      if (!user.password || typeof password !== "string") {
        return res.status(401).json({ message: "invalid_credentials" });
      }

      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        console.log("Password is not valid");
        return res.status(401).json({ message: "invalid_credentials" });
      }
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
      resendConfirmationMail(user, req.hostname, isMobile);
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
      `Contact Us Dootify - ${subject}`,
      template,
      req.hostname
    );
    sendMail(
      "reservations@dootify.com",
      `Contact Us Dootify - ${subject}`,
      template,
      req.hostname
    );
    sendMail(
      "Sarah.benachour@dootify.com",
      `Contact Us Dootify - ${subject}`,
      template,
      req.hostname
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
    referralCode,
    language,
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
    let response;
    const newUserReferralCode = await generateUniqueReferralCode();
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
        referral_code: newUserReferralCode,
        language: language ?? "en",
      });
    } else if (email || formattedPhoneNumber) {
      // If email or phone_number is provided, password must be set
      if (!password) {
        return res.status(400).json({ message: "missing_password" });
      }
      const hashedPass = await bcrypt.hash(password, 10);

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
        referral_code: newUserReferralCode,
        language: language ?? "en",
      });
    } else {
      return res.status(400).json({ message: "missing_credentials" });
    }

    if (referralCode) {
      const referrer = await User.findOne({
        where: { referral_code: referralCode },
      });
      if (referrer) {
        await Referral.create({
          referrer_id: referrer.id,
          referred_user_id: response.id,
        });
      }
    }

    await Transaction.create({
      coins: 50,
      user_id: response.id,
      status: "completed",
      type: "initialCoins",
    });

    const token = await generateJWT(response);

    if (email) {
      //generate code for confrimation mail
      let code = generateRandomCode();

      //save the code in the database
      await VerificationCode.create({
        code,
        phone_number: response.phone_number,
        email: response.email,
        user_id: response.id,
      });

      const mailVerificationToken = jwt.sign(
        {
          code: code,
          phone_number: response.phone_number,
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
      sendMail(
        response.email,
        "Confirmation de compte",
        template,
        req.hostname
      );
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

    // Send notification to the referee to verify his account for getting rewarded
    if (referralCode) {
      notificationService.sendNotification(
        response.id,
        "notifications.verify_account",
        "notifications.verify_account_for_reward",
        NotificationType.REWARDS,
        {}
      );
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
    let myOffersActionRequired = await getMyOffersRequiredActionsCount(userId);
    let myStoreActionRequired = await getMyStoreRequiredActionsCount(userId);
    let approveUsersActionRequired = await getApproveUsersRequiredActionsCount(
      userId
    );

    let userHasBoosts = false;
    const userBoosts = await Boost.findAll({
      where: { user_id: userFound.id },
    });
    userHasBoosts = userBoosts.length > 0;
    const jwt = await generateJWT(userFound);

    let adminDashboardActionRequired = 0;
    if (userFound.role == "admin") {
      adminDashboardActionRequired = await getAdminRequiredActionsCount();
    }

    return res.status(200).json({
      token: jwt,
      user: userFound,
      subscribedCategories: categories,
      myRequestActionRequired,
      myOffersActionRequired,
      myStoreActionRequired,
      approveUsersActionRequired,
      userHasBoosts,
      adminDashboardActionRequired,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getUserById = async (req, res) => {
  try {
    const id = req.query.id;
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

exports.deleteProfile = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "account_not_found" });
    }
    let openedSupportTicket = await SupportTicket.findOne({
      where: { user_id: userId, category: "profileDeletion", status: "open" },
    });
    if (openedSupportTicket) {
      return res.status(400).json({ message: "already_exist" });
    }
    await SupportTicket.create({
      user_id: userId,
      category: "profileDeletion",
      subject: "Request to Delete Profile",
      description: "User has requested to delete their profile.",
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.profileDeletionFeedback = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const { reasons, thoughts } = req.body;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "account_not_found" });
    }

    let openedSupportTicket = await SupportTicket.findOne({
      where: { user_id: userId, category: "profileDeletion", status: "open" },
    });
    if (openedSupportTicket) {
      openedSupportTicket.description +=
        `\nReasons: ${reasons}` + `\nThoughts: ${thoughts}`;
      openedSupportTicket.save();
    }

    return res.status(200).json({ done: openedSupportTicket !== undefined });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getSupportTickets = async (req, res) => {
  try {
    const userId = req.decoded?.id;
    const guest_id = req.query.guest_id;
    const userFound = await User.findByPk(userId);
    if (!userFound && !guest_id) {
      return res.status(404).json({ message: "account_not_found" });
    }

    let openedSupportTicket = await SupportTicket.findAll({
      where: guest_id ? { guest_id: guest_id } : { user_id: userId },
      include: [{ model: User, as: "user" }],
    });

    openedSupportTicket = await populateSupportTickets(openedSupportTicket);

    return res.status(200).json({ tickets: openedSupportTicket });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.addSupportTicket = async (req, res) => {
  try {
    const user_id = req.decoded?.id;
    const { category, priority, description, subject, guest_id } = req.body;
    const userFound = await User.findByPk(user_id);
    if (!userFound && !guest_id) {
      return res.status(404).json({ message: "account_not_found" });
    }
    if (!category || !description || !subject) {
      return res.status(400).json({ message: "missing" });
    }

    const ticket = await SupportTicket.create({
      user_id,
      category,
      subject,
      description,
      priority,
      guest_id,
    });

    let pictures = req.files?.photo ?? req.files?.gallery;
    if (pictures && pictures.length > 0) {
      await Promise.all(
        pictures.map(async (file) => {
          await SupportAttachmentModel.create({
            ticket_id: ticket.id,
            url: file.filename,
            type: getFileType(file),
          });
        })
      );
    }
    const logFile = req.files?.logFile?.[0];
    if (logFile) {
      await SupportAttachmentModel.create({
        ticket_id: ticket.id,
        url: logFile.filename,
        type: getFileType(logFile),
      });
    }

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateSupportTicket = async (req, res) => {
  try {
    const userId = req.decoded?.id;
    const { status, priority, id, guest_id } = req.body;
    const userFound = await User.findByPk(userId);
    if (!userFound && !guest_id) {
      return res.status(404).json({ message: "account_not_found" });
    }
    if (!id || !status || !priority) {
      return res.status(400).json({ message: "missing" });
    }
    const ticketFound = await SupportTicket.findOne({
      where: { id: id },
      include: [{ model: User, as: "user" }],
    });
    if (!ticketFound) {
      return res.status(404).json({ message: "ticket_not_found" });
    }

    ticketFound.status = status;
    ticketFound.priority = priority;
    ticketFound.save();

    return res.status(200).json({ ticket: ticketFound });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateGuestData = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const guest_id = req.body.guest_id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "account_not_found" });
    }
    const ticketsFound = await SupportTicket.findAll({
      where: { guest_id: guest_id },
    });
    await Promise.all(
      ticketsFound.map(async (ticket) => {
        ticket.user_id = userId;
        ticket.guest_id = null;
        await ticket.save();
      })
    );

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateUserFcmToken = async (req, res) => {
  try {
    const userId = req.decoded.id;
    const token = req.body.token;
    const userFound = await User.findByPk(userId);
    if (!token || token === "") {
      return res.status(400).json({ message: "missing" });
    }
    if (!userFound) {
      return res.status(404).json({ message: "account_not_found" });
    }
    userFound.fcmToken = token;
    userFound.save();
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getSupportMessages = async (req, res) => {
  try {
    const userId = req.decoded?.id;
    const guest_id = req.query.guest_id;
    const ticketId = req.query.ticket_id;
    const userFound = await User.findByPk(userId);
    if (!userFound && !guest_id) {
      return res.status(404).json({ message: "account_not_found" });
    }
    const ticketFound = await SupportTicket.findByPk(ticketId);
    if (!ticketFound) {
      return res.status(404).json({ message: "ticket_not_found" });
    }

    let ticketMessages = await SupportMessage.findAll({
      where: { ticket_id: ticketId },
      include: [{ model: User, as: "user" }],
      order: [["createdAt", "ASC"]],
    });
    ticketMessages = await populateSupportMessages(ticketMessages);

    return res.status(200).json({ messages: ticketMessages });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.sendSupportMessage = async (req, res) => {
  try {
    const userId = req.decoded?.id;
    const { message, attachment, ticketId, guest_id } = req.body;
    const userFound = await User.findByPk(userId);
    if (!userFound && !guest_id) {
      return res.status(404).json({ message: "account_not_found" });
    }
    if (!message) {
      return res.status(400).json({ message: "missing" });
    }

    const msg = await SupportMessage.create({
      sender_id: userId,
      guest_id: guest_id,
      message: message,
      attachment: attachment,
      ticket_id: ticketId,
    });
    const file = req.files?.photo?.[0] ?? req.files?.logFile?.[0];
    if (file) {
      await SupportAttachmentModel.create({
        message_id: msg.id,
        url: file.filename,
        type: getFileType(file),
      });
    }

    return res.status(200).json({ done: true });
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
    let code = req.decoded.code ? req.decoded.code : req.decoded;
    code = normalizeCode(code);
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
      return res.status(400).send({ message: "wrong_code" });
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
    verificationCode = await resendConfirmationMail(
      user,
      req.hostname,
      isMobile
    );

    return res.status(200).json({ message: verificationCode });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

async function createAndSaveCode(user, type) {
  const code = generateRandomCode();
  await VerificationCode.create({
    code,
    user_id: user.id,
    phone_number: user.phone_number,
    email: user.email,
    type: type,
  });
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
        code = await createAndSaveCode(foundUser, "forgotPassword");
      } else {
        code = foundCode.code; // Reuse the existing code
      }
    } else {
      code = await createAndSaveCode(foundUser, "forgotPassword");
    }

    const templateUser = forgotPasswordEmailTemplate(code);
    sendMail(
      foundUser.email,
      "Forgot Password Code",
      templateUser,
      req.hostname
    );

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
      include: [{ model: User, as: "user" }],
    });
    if (!foundCode) {
      return res.status(401).json({ message: "code_not_found" });
    }
    if (foundCode.user.password) {
      const samePassword = await bcrypt.compare(
        newPassword,
        foundCode.user.password
      );
      if (samePassword) {
        return res.status(401).json({ message: "same_password" });
      }
    }
    const hashedPass = await bcrypt.hash(newPassword, 10);
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
      const wrontPassword = await bcrypt.compare(
        req.body.currentPassword,
        userFound.password
      );
      if (!wrontPassword) {
        return res.status(400).json({ message: "wrong_password" });
      }
      const samePassword = await bcrypt.compare(
        req.body.newPassword,
        userFound.password
      );
      if (samePassword) {
        return res.status(400).json({ message: "same_password" });
      }
    }
    const hashedPass = await bcrypt.hash(req.body.newPassword, 10);
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
    bankNumber,
    balance,
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
      phone_number: formattedPhoneNumber,
      birthdate,
      gender,
      coordinates,
      hasSharedPosition: coordinates != undefined,
      keepPrivacy,
      bankNumber,
      balance,
      // bio,
    });
    req.files?.gallery?.forEach(async (image) => {
      await Governorate.create({
        url: image.filename,
        user_id: userFound.id,
      });
    });
    // if (formattedPhoneNumber != userFound.phone_number) {
    //   const foundedCode = await VerificationCode.findOne({
    //     where: {
    //       user_id: userFound.id,
    //     },
    //   });
    //   if (foundedCode && foundedCode.attempt > 4) {
    //     return res.status(401).json({ message: "too_many_otp" });
    //   }
    // }
    const jwt = await generateJWT(updatedUser);
    return res.status(200).json({ updatedUser, jwt });
  } catch (error) {
    const errorMessage = error.errors?.[0].message || error.message;
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: errorMessage });
  }
};

exports.updateProfileLanguage = async (req, res) => {
  const { lang } = req.body;
  try {
    const userFound = await User.findByPk(req.decoded.id);
    if (!lang) {
      return res.status(400).json({ message: "missing" });
    }

    const updatedUser = await userFound.update({
      language: lang,
    });
    const jwt = await generateJWT(updatedUser);
    return res.status(200).json({ jwt });
  } catch (error) {
    const errorMessage = error.errors?.[0].message || error.message;
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: errorMessage });
  }
};

exports.updateCoordinates = async (req, res) => {
  const { coordinates } = req.body;
  try {
    const userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (!coordinates) {
      return res.status(400).json({ message: "missing" });
    }

    const updatedUser = await userFound.update({ coordinates });
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
      "notifications.new_user_verification",
      "notifications.new_user_verification_msg",
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
    let taskHistoryActionRequired = await getMyOffersRequiredActionsCount(
      userFound.id
    );
    let myStoreActionRequired = await getMyStoreRequiredActionsCount(
      userFound.id
    );
    const categories = await CategorySubscriptionModel.findAll({
      where: { user_id: userFound.id },
    });
    const adminDashboardActionRequired =
      userFound.role === "admin" ? await getAdminRequiredActionsCount() : 0;

    let count =
      myRequestActionRequired +
      taskHistoryActionRequired +
      myStoreActionRequired +
      adminDashboardActionRequired;
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
      phone_number: user.phone_number,
      email: user.email,
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

async function checkUnreviewed() {
  try {
    let counter = 0;
    // Fetch task reservations that are finished but not reviewed
    const finishedReservations = await Reservation.findAll({
      where: { status: "finished" },
    });
    await Promise.all(
      finishedReservations.map(async (reservation) => {
        const foundTask = await Task.findOne({
          where: { id: reservation.task_id },
        });
        const existReview = await Review.findOne({
          where: {
            reviewee_id: foundTask.owner_id,
            user_id: reservation.user_id,
          },
        });
        if (!existReview) {
          counter++;
          await notificationService.sendNotification(
            foundTask.owner_id,
            "notifications.review_finished_task",
            "notifications.review_finished_task_name",
            NotificationType.REVIEW,
            { userId: reservation.user_id, taskId: reservation.task_id },
            (data = { taskTitle: foundTask.title })
          );
        }
      })
    );

    // Fetch service bookings that are finished but not reviewed
    const finishedBookings = await Reservation.findAll({
      where: { status: "finished" },
    });
    await Promise.all(
      finishedBookings.map(async (booking) => {
        const foundService = await Service.findOne({
          where: { id: booking.service_id },
        });
        const existReview = await Review.findOne({
          where: {
            reviewee_id: foundService.owner_id,
            user_id: booking.user_id,
          },
        });
        if (!existReview) {
          counter++;
          await notificationService.sendNotification(
            booking.user_id,
            "notifications.review_finished_service",
            "notifications.review_finished_service_name",
            NotificationType.REVIEW,
            { userId: foundService.owner_id, serviceId: booking.service_id },
            (data = { serviceName: foundService.title })
          );
        }
      })
    );

    console.log(`Checked for unreviewed tasks and sent ${counter} reminders.`);
  } catch (error) {
    console.error("Error checking unreviewed tasks: \x1b[31m%s\x1b[0m", error);
  }
}

cron.schedule("0 20 * * *", () => {
  console.log("Running cron job to check for unreviewed tasks/services");
  checkUnreviewed();
});
