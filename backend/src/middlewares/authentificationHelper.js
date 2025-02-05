const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const { User } = require("../models/user_model");
const { decryptData } = require("../helper/encryption");
const { verifyToken } = require("../helper/helpers");
const { Contract } = require("../models/contract_model");
const { createContract } = require("../helper/pdfHelper");
const fs = require("fs");
const path = require("path");

async function tokenVerification(req, res, next) {
  let token = req.headers["authorization"];
  if (token) {
    try {
      const result = await verifyToken(token);
      if (result) {
        req.decoded = result;
        next();
      } else {
        return res.status(403).json({
          success: false,
          message: "session_expired",
        });
      }
    } catch (error) {
      return res.status(403).json({
        success: false,
        message: "session_expired",
      });
    }
  } else {
    return res.status(403).json({
      message: "no_token_provided",
    });
  }
}

async function checkContractPermission(req, res, next) {
  const user = await User.findByPk(req.decoded.id);
  const contract = await Contract.findByPk(req.query.id);
  if (user.id != contract?.seeker_id && user.id != contract?.provider_id) {
    return res.status(401).json({ message: "not_allowed" });
  }
  const filePath = path.join(
    __dirname,
    `./public/contracts/contract_${user.language}_${req.query.id}.pdf`
  );
  if (!fs.existsSync(filePath)) {
    // File language is not created
    const sender = await User.findByPk(contract.seeker_id);
    const reciever = await User.findByPk(contract.provider_id);

    await createContract({
      contractId: contract.id,
      date: contract.dueDate,
      seekerName: sender.name,
      providerName: reciever.name,
      taskDescription: contract.description,
      deliverables: contract.delivrables,
      deliveryDate: contract.dueDate,
      price: contract.finalPrice,
      language: user.language,
    });
  }
  next();
}

function tokenVerificationOptional(req, res, next) {
  let token = req.headers["authorization"];
  if (token && !token.includes("null")) {
    let checkBearer = "Bearer ";
    if (token.startsWith(checkBearer)) {
      token = token.slice(checkBearer.length, token.length);
    }

    jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: "session_expired",
        });
      } else {
        req.decoded = decoded;
        next();
      }
    });
  } else {
    next();
  }
}
function refreshTokenVerification(req, res, next) {
  let token = req.body.refreshToken;
  if (token) {
    jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
      if (err) {
        return res.status(406).json({
          success: false,
          message: "session_expired",
        });
      } else {
        req.decoded = decoded;
        next();
      }
    });
  } else {
    return res.status(403).json({
      message: "no_token_provided",
    });
  }
}
function tokenGetId(req, res, next) {
  let token = req.headers["authorization"];
  if (token) {
    let checkBearer = "Bearer ";
    if (token.startsWith(checkBearer)) {
      token = token.slice(checkBearer.length, token.length);
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      req.decoded = decoded;
    });
  }
  next();
}

function tokenMail(req, res, next) {
  let { token, email, code, isMobile } = req.body;
  if (token && !isMobile) {
    const tokenDecrypted = decryptData(token["token"]);
    jwt.verify(tokenDecrypted, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: "session_expired",
        });
      } else {
        req.decoded = decoded;
        next();
      }
    });
  } else if (isMobile) {
    req.decoded = { email, code };
    next();
  } else {
    return res.status(403).json({
      message: "no_token_provided",
    });
  }
}
function roleMiddleware(roles) {
  return (req, res, next) => {
    const right = req.decoded?.role;

    if (right && roles === right) {
      next();
    } else {
      return res.status(403).send("access_denied");
    }
  };
}

function roleAuth(roles) {
  return async (req, res, next) => {
    const email = req.headers["email"];
    const password = req.headers["password"];

    if (!email || !password) {
      return res.status(403).json({ message: "missing_credentials" });
    }
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: "client_not_found" });
    }
    const isPasswordValid = user.password
      ? await bcrypt.compare(password, user.password)
      : undefined;
    if (!isPasswordValid) {
      return res.status(401).json({ message: "invalid_credentials" });
    }
    if (user.role && roles.some((role) => user.role.includes(role))) {
      req.decoded = user.id;
      next();
    } else {
      return res.status(403).json({ message: "access_denied" });
    }
  };
}
async function clientIsVerified(req, res, next) {
  const userFound = await User.findByPk(req.decoded.id);
  if (userFound.isVerified) {
    next();
  } else {
    return res.status(400).json({ message: "must_verify_account" });
  }
}
module.exports = {
  tokenVerification,
  roleMiddleware,
  clientIsVerified,
  tokenGetId,
  tokenMail,
  roleAuth,
  refreshTokenVerification,
  tokenVerificationOptional,
  checkContractPermission,
};
