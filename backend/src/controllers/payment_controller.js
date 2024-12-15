const { User } = require("../models/user_model");
const axios = require("axios");
const { Reservation } = require("../models/reservation_model");
const { Payment } = require("../models/payment_model");
const { Contract } = require("../models/contract_model");
const { Task } = require("../models/task_model");
const { Service } = require("../models/service_model");
const { CoinPack } = require("../models/coin_pack_model");
const { BalanceTransaction } = require("../models/balance_transaction_model");

exports.initFlouciPayment = async (req, res) => {
  try {
    const {
      contractId,
      taskId,
      serviceId,
      coinPackId,
      totalPrice,
      paymentType,
    } = req.body;
    if (
      (!contractId && !taskId && !serviceId && !coinPackId) ||
      !totalPrice ||
      !paymentType
    ) {
      return res.status(400).json({ message: "missing_element" });
    }

    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let contractFound, taskFound, serviceFound, coinPackFound;
    if (contractId) {
      contractFound = await Contract.findByPk(contractId);
      if (!contractFound) {
        return res.status(404).json({ message: "contract_not_found" });
      }
    }
    if (taskId) {
      taskFound = await Task.findByPk(taskId);
      if (!taskFound) {
        return res.status(404).json({ message: "task_not_found" });
      }
    }
    if (serviceId) {
      serviceFound = await Service.findByPk(serviceId);
      if (!serviceFound) {
        return res.status(404).json({ message: "service_not_found" });
      }
    }
    if (coinPackId) {
      coinPackFound = await CoinPack.findByPk(coinPackId);
      if (!coinPackFound) {
        return res.status(404).json({ message: "coin_pack_not_found" });
      }
    }

    const payment = await Payment.create({
      total_price: totalPrice,
      payment_type: paymentType,
      user_id: userFound.id,
      contract_id: contractFound?.id,
      task_id: taskFound?.id,
      service_id: serviceFound?.id,
      coin_pack_id: coinPackFound?.id,
      is_boost: taskId || serviceId,
    });

    const payload = {
      app_token: process.env.FLOUCI_APP_TOKEN,
      app_secret: process.env.FLOUCI_APP_SECRET,
      accept_card: "true",
      amount: totalPrice * 1000, // amount should be in millimes
      success_link: `https://test.abidconcept.tn/payment/verify/${payment.id}`,
      fail_link: `https://test.abidconcept.tn/payment/verify/${payment.id}`,
      session_timeout_secs: 1200,
      developer_tracking_id: process.env.FLOUCI_TRACKING_ID,
    };

    const responseFlouci = await axios.post(process.env.FLOUCI_URL, payload, {
      headers: { "Content-Type": "application/json" },
    });

    payment.provider_payment_id = responseFlouci.data.result.payment_id;
    payment.save();

    return res.status(200).json({
      paymentId: payment.id,
      link: responseFlouci.data.result.link,
      success: responseFlouci.data.result.success,
    });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.verifyFlouciPayment = async (req, res) => {
  try {
    const paymentId = req.params.id;
    if (!paymentId) {
      return res.status(400).json({ message: "missing_element" });
    }
    let paymentFound = await Payment.findByPk(paymentId);
    if (!paymentFound) {
      return res.status(404).json({ message: "payment_not_found" });
    }
    if (paymentFound.user_id != req.decoded.id) {
      return res.status(401).json({ message: "not_allowed" });
    }

    const responseFlouci = await axios.get(
      process.env.FLOUCI_VERIFY_URL + paymentFound.provider_payment_id,
      {
        headers: {
          "Content-Type": "application/json",
          "apppublic": process.env.FLOUCI_APP_TOKEN,
          "appsecret": process.env.FLOUCI_APP_SECRET,
        },
      }
    );

    paymentFound.status = responseFlouci.data.success ? "success" : "failed";
    paymentFound.payment_type =
      responseFlouci.data.result.type === "card" ? "bankCard" : "flouci";
    paymentFound.save();

    return res.status(200).json({ done: paymentFound.status === "success" });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};

exports.payWithBalance = async (req, res) => {
  try {
    const {
      contractId,
      taskId,
      serviceId,
      coinPackId,
      totalPrice,
      paymentType,
    } = req.body;
    if (
      (!contractId && !taskId && !serviceId && !coinPackId) ||
      !totalPrice ||
      !paymentType
    ) {
      return res.status(400).json({ message: "missing_element" });
    }

    let userFound = await User.findByPk(req.decoded.id);
    if (!userFound) {
      return res.status(404).json({ message: "user_not_found" });
    }
    let contractFound, taskFound, serviceFound, coinPackFound;
    if (contractId) {
      contractFound = await Contract.findByPk(contractId);
      if (!contractFound) {
        return res.status(404).json({ message: "contract_not_found" });
      }
    }
    if (taskId) {
      taskFound = await Task.findByPk(taskId);
      if (!taskFound) {
        return res.status(404).json({ message: "task_not_found" });
      }
    }
    if (serviceId) {
      serviceFound = await Service.findByPk(serviceId);
      if (!serviceFound) {
        return res.status(404).json({ message: "service_not_found" });
      }
    }
    if (coinPackId) {
      coinPackFound = await CoinPack.findByPk(coinPackId);
      if (!coinPackFound) {
        return res.status(404).json({ message: "coin_pack_not_found" });
      }
    }
    if (totalPrice > userFound.balance) {
      return res.status(400).json({ message: "not_enough_balance" });
    }

    const payment = await Payment.create({
      total_price: totalPrice,
      payment_type: paymentType,
      user_id: userFound.id,
      contract_id: contractFound?.id,
      task_id: taskFound?.id,
      service_id: serviceFound?.id,
      coin_pack_id: coinPackFound?.id,
      is_boost: taskId || serviceId,
    });

    BalanceTransaction.create({
      userId: userFound.id,
      amount: totalPrice,
      status: "completed",
      type: coinPackFound
        ? "coinPurchase"
        : contractFound
        ? "taskPayment"
        : taskId || serviceId
        ? "boostPurchase"
        : "system",
      description: coinPackFound
        ? `Purchase of ${coinPackFound.totalCoins} coins`
        : contractFound
        ? `Contract payment of ${contractId}`
        : taskId || serviceId
        ? `Boost of ${taskId ? "task" : "service"} ${taskId ?? serviceId}`
        : "System purchase",
    });

    userFound.balance -= coinPackFound.price;
    userFound.save();
    const token = await generateJWT(userFound);

    payment.provider_payment_id = responseFlouci.data.result.payment_id;
    payment.save();

    return res.status(200).json({ done: true, token: token });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: error });
  }
};
