// encryption.js
const crypto = require("crypto");

function encryptData(password) {
  const key = Buffer.from(process.env.ENCRYPTION_KEY, "utf-8");
  const iv = Buffer.alloc(16, 0); // Initialization vector with zeros

  const cipher = crypto.createCipheriv(process.env.ENCRYPTION_METHOD, key, iv);

  let encrypted = cipher.update(password, "utf-8", "base64");
  encrypted += cipher.final("base64");

  return encrypted;
}

// Decrypt data
function decryptData(encryptedPasswordBase64) {
  const key = Buffer.from(process.env.ENCRYPTION_KEY, "utf-8");
  const iv = Buffer.alloc(16, 0); // Initialization vector with zeros

  const decipher = crypto.createDecipheriv(
    process.env.ENCRYPTION_METHOD,
    key,
    iv
  );
  decipher.setAutoPadding(true); // Set to false if you are using a different padding scheme

  let decrypted = decipher.update(
    Buffer.from(encryptedPasswordBase64, "base64")
  );
  decrypted = Buffer.concat([decrypted, decipher.final()]);

  return decrypted.toString("utf-8");
}

module.exports = {
  encryptData,
  decryptData,
};
