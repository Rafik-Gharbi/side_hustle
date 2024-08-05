const { tokenVerification } = require("../middlewares/authentificationHelper");
const { reviewImageUpload } = require("../middlewares/multer-review");

module.exports = (app) => {
  const reviewController = require("../controllers/review_controller");

  let router = require("express").Router();

  router.get("/:id", reviewController.getReviewsByUserId);

  router.post(
    "/",
    tokenVerification,
    reviewImageUpload,
    reviewController.addReview
  );

  router.put(
    "/:id",
    tokenVerification,
    reviewImageUpload,
    reviewController.updateReview
  );
  
  router.delete("/:id", tokenVerification, reviewController.deleteReview);

  app.use("/review", router);
};
