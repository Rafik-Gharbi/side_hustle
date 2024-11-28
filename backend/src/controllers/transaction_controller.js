const cron = require("node-cron");
const { Op, Sequelize } = require("sequelize");
const moment = require("moment");
const { Service } = require("../models/service_model");
const { Task } = require("../models/task_model");
const { Transaction } = require("../models/transaction_model");
const { User } = require("../models/user_model");
const { CoinPack } = require("../models/coin_pack_model");
const { generateJWT } = require("../helper/helpers");
const { CoinPackPurchase } = require("../models/coin_pack_purchase_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");

exports.listTransaction = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const transactions = await Transaction.findAll({
      where: { user_id: userFound.id },
      include: [
        { model: Task, as: "task", include: [{ model: User, as: "user" }] },
        { model: Service, as: "service" },
        {
          model: CoinPackPurchase,
          as: "coin_pack_purchase",
          include: [{ model: CoinPack, as: "coin_pack" }],
        },
      ],
    });

    let coinPacks = await CoinPackPurchase.findAll({
      where: {
        user_id: userFound.id,
        createdAt: {
          // Calculate transactions that are not yet expired
          [Op.gte]: Sequelize.literal(
            `DATE_SUB(NOW(), INTERVAL (SELECT validMonths FROM coin_pack WHERE id = coin_pack_purchase.coin_pack_id) MONTH)`
          ),
        },
      },
      include: [
        {
          model: CoinPack,
          required: true,
          where: {
            validMonths: { [Op.ne]: null }, // Ensure CoinPack has a validMonths field
          },
        },
      ],
    });

    return res.status(200).json({ transactions, coinPacks });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.buyCoins = async (req, res) => {
  try {
    // TODO this is only working from balance for now, add bank card payment later
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    const coinPack = await CoinPack.findByPk(req.params.id);
    if (coinPack.price > userFound.balance) {
      return res.status(400).json({ message: "not_enough_balance" });
    }
    const coinPurchase = await CoinPackPurchase.create({
      user_id: userFound.id,
      coin_pack_id: coinPack.id,
      available: coinPack.totalCoins,
    });
    await Transaction.create({
      coins: coinPack.totalCoins,
      coin_pack_id: coinPurchase.id,
      user_id: userFound.id,
      status: "completed",
      type: "purchase",
    });
    BalanceTransaction.create({
      userId: userFound.id,
      amount: coinPack.price,
      type: "coinPurchase",
      status: "completed",
      description: `Purchase of ${coinPack.totalCoins} coins`,
    });

    userFound.balance -= coinPack.price;
    userFound.save();
    const token = await generateJWT(userFound);

    return res.status(200).json({ done: true, token: token });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

// Cron job to run on the first day of every month for reseting users coins.
// Only completed transaction on the previous month will get reseted.
cron.schedule("0 0 1 * *", async () => {
  console.log("Running monthly reset cron job...");
  // Get the first and last day of the previous month
  const startOfPrevMonth = moment()
    .subtract(1, "months")
    .startOf("month")
    .toDate();
  const endOfPrevMonth = moment().subtract(1, "months").endOf("month").toDate();
  try {
    // Find all users
    const users = await User.findAll();
    for (const user of users) {
      // Find all transactions that were completed in the previous month, regardless of when they were created
      const transactions = await Transaction.findAll({
        where: {
          user_id: user.id,
          status: "completed",
          updatedAt: {
            // We use `updatedAt` to check when the status changed to "completed"
            [Op.between]: [startOfPrevMonth, endOfPrevMonth],
          },
        },
      });
      // Calculate total coins from completed transactions
      const totalCoins = transactions.reduce(
        (sum, transaction) => sum + transaction.coins,
        0
      );
      // If there are completed transactions, create a monthly reset
      if (totalCoins > 0) {
        await Transaction.create({
          user_id: user.id,
          type: "monthlyReset",
          coins: totalCoins,
          status: "completed",
        });
        user.availableCoins += coins;
        user.save();

        console.log(
          `Monthly reset transaction added for user ${user.id}: ${totalCoins} coins`
        );
      }
    }
  } catch (error) {
    console.error("Error in monthly reset cron job:", error);
  }
});
