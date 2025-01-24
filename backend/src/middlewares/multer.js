const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");
const { adjustString, ensureDecryptBody } = require("../helper/helpers");

// Config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    ensureDecryptBody(req);
    const dir = path.join(__dirname, "../../public/images/user");
    if (!fs.existsSync(dir)) {
      execSync(`mkdir -p "${dir}"`);
    }
    cb(null, "public/images/user");
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname).toLowerCase();
    if (![".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"].includes(ext)) {
      const error = new Error("Only images are allowed");
      error.status = 415;
      return cb(error);
    }
    cb(null, `${adjustString(file.originalname)}-${req.decoded.id}${ext}`);
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 10 }, // 10 MB
});

const fileUpload = upload.fields([
  { name: "photo", maxCount: 1 },
  { name: "gallery", maxCount: 3 },
]);

module.exports = { fileUpload };
