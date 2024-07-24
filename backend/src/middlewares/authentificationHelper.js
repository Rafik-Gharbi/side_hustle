const jwt = require("jsonwebtoken");
const Bcrypt = require("bcrypt");
const { User } = require("../models/user_model");
const { decryptData } = require("../helper/encryption");
const { Parameters } = require("../models/paramters_model");
const { generateJWT } = require("../helper/helpers");
// const { loadTranslations } = require("./helpers");

function tokenVerification(req, res, next) {
  let token = req.headers["authorization"];
  if (token) {
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
    return res.status(403).json({
      message: "no_token_provided",
    });
  }
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
      ? await Bcrypt.compare(password, user.password)
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
};
