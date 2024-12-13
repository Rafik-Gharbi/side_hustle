const { fileUpload } = require("../middlewares/multer");
const { fileUploadSupport } = require("../middlewares/multer-support");

module.exports = (app) => {
  const userController = require("../controllers/user_controller");
  const {
    tokenVerification,
    tokenMail,
    refreshTokenVerification,
  } = require("../middlewares/authentificationHelper");
  var router = require("express").Router();

  // signin signup
  router.post("/signin", userController.signIn);
  router.post("/renew", refreshTokenVerification, userController.renewJWT);

  router.post("/signup", userController.signUp);

  router.post("/contact-us", userController.contactUs);

  // get profile by token
  router.get("/profile", tokenVerification, userController.profile);

  router.delete("/delete", tokenVerification, userController.deleteProfile);
  router.post(
    "/leave-feedback",
    tokenVerification,
    userController.profileDeletionFeedback
  );
  router.get(
    "/support-tickets",
    tokenVerification,
    userController.getSupportTickets
  );
  router.post(
    "/support-ticket",
    tokenVerification,
    fileUploadSupport,
    userController.addSupportTicket
  );
  router.put(
    "/support-ticket",
    tokenVerification,
    userController.updateSupportTicket
  );
  router.get(
    "/support-messages/:id",
    tokenVerification,
    userController.getSupportMessages
  );
  router.post(
    "/support-message",
    tokenVerification,
    fileUploadSupport,
    userController.sendSupportMessage
  );

  // get user required actions count
  router.get(
    "/required-actions",
    tokenVerification,
    userController.userActionsRequiredCount
  );

  // get user by id, available only for owners
  router.get("/user-id", tokenVerification, userController.getUserById);

  // endpoint that generate html of contract
  // router.get("/show-contract", checkOrigin, userController.showContract);

  //update profile with name email phonenumber government
  router.put(
    "/update-profile",
    tokenVerification,
    fileUpload,
    userController.updateProfile
  );
  router.put(
    "/update-coordinates",
    tokenVerification,
    userController.updateCoordinates
  );

  // update password when connected with JWT
  router.put(
    "/update-password",
    tokenVerification,
    userController.updatePassword
  );

  router.post("/email-forgot-password", userController.emailForgotPassword);

  router.put("/forgot-password", userController.forgotPassword);

  // saves the pdf in the server and send a copy via email to the user
  // router.post("/create-contract", checkOrigin, userController.saveContract);

  // saves the pdf in the server and send a copy via email to the user
  router.post("/social-media", tokenVerification, userController.socialMedia);

  //verify number
  router.post("/verify-phone", userController.verifyPhone);
  //verify mail
  router.post("/verify-mail", tokenMail, userController.verifyMail);

  /// verify verification status by token
  router.get(
    "/check-verification-user",
    tokenVerification,
    userController.checkVerificationUser
  );

  // Resend verification mail to user
  router.get(
    "/resend-verification",
    tokenVerification,
    userController.resendVerification
  );

  // Subscribe user to categories
  router.post(
    "/subscribe-category",
    tokenVerification,
    userController.subscribeCategory
  );

  // verify user identity
  router.post(
    "/verification-data",
    tokenVerification,
    fileUpload,
    userController.verifyIdentity
  );

  app.use("/user", router);
};
