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

// config
dotenv.config();

// const
const app = express();
// Connect to the database and synchronise models
const { sequelize } = require("./db.config");
const multer = require("multer");

sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

// Middleware
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.text({ type: "application/xml" }));
app.use(express.static(path.join(__dirname, "public")));

// API for uploads file (photo, galleries)
app.get("/public/task/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/task/${req.params.id}`));
});
// API for uploads file (photo, galleries)
app.get("/public/store/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/store/${req.params.id}`));
});
// app.get("/public/task/hd/:id", (req, res) => {
//   res.sendFile(path.join(__dirname, `./public/task/hd/${req.params.id}`));
// });
app.get("/public/images/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/images/${req.params.id}`));
});
app.get("/public/images/client/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/images/client/${req.params.id}`));
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
