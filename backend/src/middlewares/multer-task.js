// Packages
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");
const { adjustString, ensureDecryptBody } = require("../helper/helpers");

//config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    ensureDecryptBody(req);
    if (!fs.existsSync(path.join(__dirname, "../../public/task/"))) {
      execSync(`mkdir "${path.join(__dirname, "../../public/task/")}"`);
    }
    cb(null, "public/task/");
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
      `task-${adjustString(file.originalname, ext)}-${req.decoded.id}${ext}`
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

const taskImageUpload = upload.fields([
  { name: "photo", maxCount: 1 },
  { name: "gallery", maxCount: 25 },
]);

module.exports = { taskImageUpload };
