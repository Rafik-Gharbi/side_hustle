const { Referral } = require("../models/referral_model");
const { User } = require("../models/user_model");

exports.listReferral = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const referrals = await Referral.findAll({
      where: { referrer_id: userFound.id },
      include: [{ model: User, as: "referred_user" }],
    });

    return res.status(200).json({ referrals });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
