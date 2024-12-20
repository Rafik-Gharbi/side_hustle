const { I18n } = require("i18n");
const path = require("path");

const i18n = new I18n();

i18n.configure({
  locales: ["en", "fr", "ar"], // Supported languages
  directory: path.join(__dirname, "locales"), // Path to translation files
  defaultLocale: "en", // Default language
  queryParameter: "lang", // Optional: Allow language override via query parameter
  objectNotation: true, // Enable nested translations
});

module.exports = { i18n };
