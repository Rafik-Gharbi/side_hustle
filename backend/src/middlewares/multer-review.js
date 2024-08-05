// Packages
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");
const { adjustString } = require("../helper/helpers");

//config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (!fs.existsSync(path.join(__dirname, "../../public/review/"))) {
      execSync(`mkdir "${path.join(__dirname, "../../public/review/")}"`);
    }
    cb(null, "public/review/");
  },
  filename: function (req, file, cb) {
    var ext = path.extname(file.originalname).toLocaleLowerCase();
    if (ext !== ".jpg" && ext !== ".jpeg" && ext !== ".png") {
      var error = new Error("File type not allowed");
      error.status = 415; // Set the status code to 415
      return cb(error);
    }
    cb(
      null,
      `review-${adjustString(file.originalname, ext)}-${req.decoded.id}${ext}`
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

const reviewImageUpload = upload.fields([
  { name: "photo", maxCount: 1 },
]);

module.exports = { reviewImageUpload };
