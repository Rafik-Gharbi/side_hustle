// Packages
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");

//config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (!fs.existsSync(path.join(__dirname, "../../public/store/"))) {
      execSync(`mkdir "${path.join(__dirname, "../../public/store/")}"`);
    }
    cb(null, "public/store/");
  },
  filename: function (req, file, cb) {
    var ext = path.extname(file.originalname).toLocaleLowerCase();
    if (
      ext !== ".jpg" &&
      ext !== ".jpeg" &&
      ext !== ".png" &&
      ext !== ".pdf" &&
      ext !== ".docx" &&
      ext !== ".doc"
    ) {
      var error = new Error("File type not allowed");
      error.status = 415; // Set the status code to 415
      return cb(error);
    }
    cb(
      null,
      `store-${adjustString(file.originalname, ext)}-${req.decoded.id}${ext}`
    );
  },
});

/* ---------------------------------- CONST --------------------------------- */
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 10, // 10 MB
  },
});

const storeImageUpload = upload.fields([
  { name: "photo", maxCount: 1 },
  { name: "gallery", maxCount: 25 },
]);

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
module.exports = { storeImageUpload };
