module.exports = (app) => {
  const chatController = require("../controllers/chat_controller");
  const {
    tokenVerification,
  } = require("../middlewares/authentificationHelper");
  var router = require("express").Router();

  router.get("/get-chat", tokenVerification, chatController.getChat);

  router.get("/get-not-seen", tokenVerification, chatController.getNotSeenChat);

  router.get("/search-chat", tokenVerification, chatController.searchChat);

  router.get(
    "/chat-id",

    tokenVerification,
    chatController.getChatsById
  );

  router.get(
    "/chat-before-after",
    tokenVerification,
    chatController.getChatsBeforeAfter
  );

  router.get(
    "/load-more-chat",
    tokenVerification,
    chatController.getMoreMessagesByDiscussionId
  );

  app.use("/chat", router);
};
