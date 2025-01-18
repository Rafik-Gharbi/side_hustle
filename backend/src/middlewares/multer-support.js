const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");
const { adjustString, ensureDecryptBody } = require("../helper/helpers");

// Helper to create directory if it doesn't exist
function ensureDirectoryExists(dir) {
  if (!fs.existsSync(dir)) {
    execSync(`mkdir -p "${dir}"`);
  }
}

// Storage configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    let dir;

    ensureDecryptBody(req);
    // Check file type to determine destination
    const ext = path.extname(file.originalname).toLowerCase();
    if (ext === ".txt") {
      dir = path.join(__dirname, "../../public/support_attachments/logs");
    } else if ([".pdf", ".docx", ".doc"].includes(ext)) {
      dir = path.join(__dirname, "../../public/support_attachments/documents");
    } else if ([".jpg", ".jpeg", ".png", ".gif", ".webp"].includes(ext)) {
      dir = path.join(__dirname, "../../public/support_attachments/images");
    } else {
      const error = new Error("Invalid file type");
      error.status = 415;
      return cb(error);
    }

    ensureDirectoryExists(dir); // Ensure directory exists
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname).toLowerCase();

    if (ext === ".txt") {
      // For log files
      const userId = req.decoded?.id || "unknown";
      const timestamp = new Date().toISOString().replace(/[:.]/g, "-"); // Format date for filename
      cb(null, `log-${userId}-${timestamp}.txt`);
    } else if ([".pdf", ".docx", ".doc"].includes(ext)) {
      const userId = req.decoded?.id || "unknown";
      const timestamp = new Date().toISOString().replace(/[:.]/g, "-"); // Format date for filename
      cb(null, `doc-${userId}-${timestamp}${ext}`);
    } else if ([".jpg", ".jpeg", ".png", ".gif", ".webp"].includes(ext)) {
      // For image files
      cb(null, `${adjustString(file.originalname)}-${req.decoded?.id}${ext}`);
    } else {
      const error = new Error("Invalid file type");
      error.status = 415;
      return cb(error);
    }
  },
});

// Multer instance
const upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 10 }, // 10 MB
});

// File upload configuration
const fileUploadSupport = upload.fields([
  { name: "photo", maxCount: 1 },
  { name: "gallery", maxCount: 3 },
  { name: "logFile", maxCount: 1 }, // For log files
]);

module.exports = { fileUploadSupport };
