const { sequelize } = require("../../db.config");
const { User } = require("../models/user_model");
const { Review } = require("../models/review_model");

// user review request
exports.getReviewsByUserId = async (req, res) => {
  try {
    const userId = req.params.id;
    const userFound = await User.findByPk(userId);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const reviews = await Review.findAll({ where: { user_id: userFound.id } });
    const formattedList = await Promise.all(
      reviews.map(async (row) => {
        const reviewee = await User.findOne({ where: { id: row.reviewee_id } });
        return {
          condidates,
          review: {
            id: row.id,
            message: row.message,
            rating: row.rating,
            quality: row.quality,
            fees: row.fees,
            punctuality: row.punctuality,
            politeness: row.politeness,
            reviewee,
            user: userFound,
            picture: row.picture,
          },
        };
      })
    );
    return res.status(200).json({ formattedList });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// add a new review
exports.addReview = async (req, res) => {
  const {
    message,
    quality,
    fees,
    punctuality,
    politeness,
    rating,
    user_id,
    picture,
  } = req.body;

  try {
    // Check if user exists
    const user = await User.findOne({ where: { id: req.decoded.id } });
    if (!user) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const reviewee = await User.findOne({ where: { id: user_id } });
    if (!reviewee) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const review = await Review.create({
      message,
      rating,
      quality,
      fees,
      punctuality,
      politeness,
      reviewee_id: reviewee.id,
      picture,
      user_id: user.id,
    });

    // Return created review
    return res.status(200).json({
      review: {
        id: review.id,
        message: review.message,
        rating: review.rating,
        fees: review.fees,
        punctuality: review.punctuality,
        politeness: review.politeness,
        quality: review.quality,
        picture: review.picture,
        reviewee: reviewee,
        user: user,
      },
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// update a review
exports.updateReview = async (req, res) => {
  const transaction = await sequelize.transaction();
  const id = req.params.id;
  try {
    const { message, rating, quality, fees, punctuality, politeness, picture } =
      req.body;

    if (!id) {
      return res.status(400).json({ message: "missing_review_id" });
    }
    const review = await Review.findByPk(id);
    if (!review) {
      return res.status(404).json({ message: "review_not_found" });
    }
    const foundUser = await User.findByPk(req.decoded.id);
    if (!foundUser) {
      return res.status(404).json({ message: "user_not_found" });
    }
    if (foundUser.id != review.reviewee_id) {
      return res.status(401).json({ message: "not_owner_review" });
    }

    // Update review
    const updatedReview = await review.update(
      {
        message,
        rating,
        quality,
        fees,
        punctuality,
        politeness,
        picture,
      },
      { transaction }
    );

    // Commit the transaction
    await transaction.commit();

    return res.status(200).json({ review: updatedReview });
  } catch (error) {
    // Rollback the transaction in case of error
    if (transaction) await transaction.rollback();
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error.message });
  }
};

// delete a review
exports.deleteReview = async (req, res) => {
  try {
    const ID = req.params.id;

    const deletedReview = await Review.findOne({ where: { id: ID } });
    await Review.destroy({ where: { id: ID } });
    deleteImage(
      path.join(__dirname, "../../public/review", deletedReview.picture)
    );
    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json(error);
  }
};
