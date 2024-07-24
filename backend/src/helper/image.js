const axios = require("axios");
const https = require("https");
const fs = require("fs");
const path = require("path");
const sharp = require("sharp");
const { execSync } = require("child_process");

// Function to download image from URL
async function downloadImage(imageUrl) {
  const response = await axios.get(imageUrl, {
    responseType: "arraybuffer",
    httpsAgent: new https.Agent({ rejectUnauthorized: false }), // Ignore SSL certificate errors
  });

  return Buffer.from(response.data, "binary");
}

function extractIdFromGoogleUrl(url) {
  const lastIndex = url.lastIndexOf("/");
  const id = url.substring(lastIndex + 1);
  return id;
}
// Function to save image
async function saveImage(imageName, imageBuffer, folder, resize = true) {
  const destinationDirectory = path.join(__dirname, `../../public/${folder}`);
  if (!fs.existsSync(path.join(destinationDirectory))) {
    execSync(`mkdir "${path.join(destinationDirectory)}"`);
  }

  const imagePath = path.join(destinationDirectory, imageName);

  try {
    let imageSaved = imageBuffer;
    if (resize) {
      imageSaved = await sharp(imageBuffer).resize({ width: 800 }).toBuffer();
    }
    fs.writeFileSync(imagePath, imageSaved);

    return imagePath.replace(__dirname + "/public", "");
  } catch (error) {
    throw error;
  }
}
function deleteImages() {
  deleteFolderRecursive("../../public/images/user");
  deleteFolderRecursive("../../public/task");
}
function deleteImage(filePath) {
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  }
}
function deleteFolderRecursive(folderPathString) {
  folderPath = path.join(__dirname, folderPathString);
  if (fs.existsSync(folderPath)) {
    fs.readdirSync(folderPath).forEach((file, index) => {
      const curPath = path.join(folderPath, file);
      if (fs.lstatSync(curPath).isDirectory()) {
        // Recursive call if it's a directory
        deleteFolderRecursive(curPath);
      } else {
        // Delete the file
        fs.unlinkSync(curPath);
      }
    });
    // Delete the folder itself
    fs.rmdirSync(folderPath);
  }
}
module.exports = {
  downloadImage,
  saveImage,
  deleteImage,
  extractIdFromGoogleUrl,
  deleteFolderRecursive,
  deleteImages,
};
