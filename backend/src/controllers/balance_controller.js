const { User } = require("../models/user_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");
const {
  notificationService,
  NotificationType,
} = require("../helper/notification_service");

exports.requestWithdrawal = async (req, res) => {
  try {
    let amount = req.body.amount;
    if (!amount) {
      return res.status(400).json({ message: "missing_id" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await BalanceTransaction.create({
      type: "withdrawal",
      amount: amount,
      userId: userFound.id,
    });

    userFound.balance -= amount;
    userFound.save();

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.requestDeposit = async (req, res) => {
  try {
    let amount = req.body.amount;
    let type = req.body.type;
    let depositSlip = req.body.depositSlip;
    if (!type || !amount || (type === "installment" && !depositSlip)) {
      return res.status(400).json({ message: "missing" });
    }
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    await BalanceTransaction.create({
      type: "deposit",
      depositSlip: !depositSlip ? undefined : `deposit-${depositSlip}`,
      depositType: type,
      amount: amount,
      userId: userFound.id,
    });

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.updateStatus = async (req, res) => {
  try {
    let id = req.body.id;
    let status = req.body.status;
    if (!id || !status) {
      return res.status(400).json({ message: "missing" });
    }
    let transaction = await BalanceTransaction.findByPk(id);
    if (!transaction) {
      return res.status(404).json({ message: "transaction_not_found" });
    }
    const transactionUser = await User.findByPk(transaction.userId);
    if (!transactionUser) {
      return res.status(404).json({ message: "user_not_found" });
    }

    if (status === "completed") {
      transactionUser.balance += transaction.amount;
      transactionUser.save();
      notificationService.sendNotification(
        transactionUser.id,
        "Balance Update",
        "Your deposit has been accepted.",
        NotificationType.BALANCE,
        {}
      );
    } else if (status === "failed") {
      notificationService.sendNotification(
        transactionUser.id,
        "Deposit Failed",
        "Your deposit has been failed.",
        NotificationType.BALANCE,
        {
          /* TODO add reasons */
        }
      );
    }

    transaction.status = status;
    transaction.save();

    return res.status(200).json({ done: true });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.getBalanceTransactions = async (req, res) => {
  try {
    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }

    const transactions = await BalanceTransaction.findAll({
      user_id: userFound.id,
    });

    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();

    const withdrawalCount = transactions.filter((transaction) => {
      const transactionDate = new Date(transaction.createdAt);
      return (
        transaction.transactionType === "withdrawal" &&
        transactionDate.getMonth() === currentMonth &&
        transactionDate.getFullYear() === currentYear
      );
    }).length;

    return res
      .status(200)
      .json({ transactions: transactions, withdrawalCount: withdrawalCount });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
