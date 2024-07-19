const { tokenVerification } = require("../middlewares/authentificationHelper");

module.exports = (app) => {
  const favoriteController = require("../controllers/favorite_controller");

  var router = require("express").Router();

  // create reservation (property and user connected)
  router.post("/toggle", tokenVerification, favoriteController.toggleFavorite);
  router.get("/list", tokenVerification, favoriteController.listFavorite);

  app.use("/favorite", router);
};
