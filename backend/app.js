/* -------------------------------------------------------------------------- */
/*                                Dependencies                                */
/* -------------------------------------------------------------------------- */

// Packages
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
var cors = require("cors");
const path = require("path");
const fs = require("fs");
const { sequelize } = require("./db.config");
const multer = require("multer");
const { i18n } = require("./i18n");

// config
dotenv.config();

// const
const app = express();

// Connect to the database and synchronise models
sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

// Middleware
app.use(i18n.init);
// app.use((_err, req, res, _next) => {
//   i18n.init(req, res);
// });
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.text({ type: "application/xml" }));
app.use(express.static(path.join(__dirname, "public")));

// API for getting created contract
app.get("/public/contracts/:id", (req, res) => {
  // TODO secure this route by checking the decoded jwt if it is one of the contract parties
  res.sendFile(
    path.join(__dirname, `./public/contracts/contract_${req.params.id}.pdf`)
  );
});
// API for uploads file (photo, galleries)
app.get("/public/task/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/task/${req.params.id}`));
});
// API for uploads file (photo, galleries)
app.get("/public/store/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/store/${req.params.id}`));
});
app.get("/public/deposit/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/deposit/${req.params.id}`));
});
app.get("/public/images/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/images/${req.params.id}`));
});
app.get("/public/images/user/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/images/user/${req.params.id}`));
});
app.get("/public/images/category/:id", (req, res) => {
  try {
    res.sendFile(
      path.join(__dirname, `./public/images/category/${req.params.id}`)
    );
  } catch (error) {
    console.log(`Error getting category image ${error}`);
  }
});
app.get("/public/support_attachments/logs/:id", async (req, res) => {
  res.sendFile(
    path.join(__dirname, `./public/support_attachments/logs/${req.params.id}`)
  );
});
app.get("/public/support_attachments/images/:id", async (req, res) => {
  res.sendFile(
    path.join(__dirname, `./public/support_attachments/images/${req.params.id}`)
  );
});
app.get("/public/support_attachments/documents/:id", async (req, res) => {
  res.sendFile(
    path.join(
      __dirname,
      `./public/support_attachments/documents/${req.params.id}`
    )
  );
});
app.get("/terms-condition", async (req, res) => {
  res.sendFile(
    path.join(__dirname, "./public/data/Side Hustle - Terms & Conditions.pdf")
  );
});
app.get("/privacy-policy", async (req, res) => {
  res.sendFile(
    path.join(__dirname, "./public/data/Side Hustle - Privacy Policy.pdf")
  );
});
// API for uploads file (photo, galleries)
app.get("/public/css/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/css/${req.params.id}`));
});

// API for uploads file (photo, galleries)
app.get("/public/javascripts/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/javascripts/${req.params.id}`));
});

app.use(cors());

// API for uploads file (photo, galleries)
app.get("/uploads/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./uploads/${req.params.id}`));
});

// Error handling middleware
app.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    // Multer-specific errors
    return res.status(400).send(err.message);
  }
  if (err) {
    // Generic errors
    return res.status(500).send(err.message);
  }
  next();
});

// app.use(responseToString);
module.exports = app;
