const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");

// Config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const dir = path.join(__dirname, "../../public/images/client");
    if (!fs.existsSync(dir)) {
      execSync(`mkdir -p "${dir}"`);
    }
    cb(null, "public/images/client");
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname).toLowerCase();
    if (![".jpg", ".jpeg", ".png", ".gif", ".webp"].includes(ext)) {
      const error = new Error("Only images are allowed");
      error.status = 415;
      return cb(error);
    }
    cb(null, `${adjustString(file.originalname, ext)}-${req.decoded.id}${ext}`);
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

function adjustString(inputString, ext) {
  let sanitizedString = inputString.toLowerCase();
  // Remove the provided extension if it exists at the end of the string
  if (sanitizedString.endsWith(ext.toLowerCase())) {
    sanitizedString = sanitizedString.slice(0, -ext.length);
  }
  // Remove special characters and spaces
  sanitizedString = sanitizedString.replace(/[^\w\s]/gi, ""); // Remove special characters
  sanitizedString = sanitizedString.replace(/\s+/g, ""); // Remove spaces

  return sanitizedString;
}
