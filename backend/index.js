// index.js

const http = require("http");
const app = require("./app");
const socketio = require("socket.io");
const dotenv = require("dotenv");
const initializeSocket = require("./socket");
const { notificationService } = require("./src/helper/notification_service");
dotenv.config();

// Importing Routes
require("./src/routes/database_route")(app);
require("./src/routes/params_route")(app);
require("./src/routes/task_route")(app);
require("./src/routes/store_route")(app);
require("./src/routes/user_route")(app);
require("./src/routes/reservation_route")(app);
require("./src/routes/booking_route")(app);
require("./src/routes/favorite_route")(app);
require("./src/routes/chat_route")(app);
require("./src/routes/review_route")(app);
require("./src/routes/notification_route")(app);
require("./src/routes/boost_route")(app);

// Create HTTP server

const server = http.createServer(app);
// Initialize Socket.io
const io = initializeSocket(socketio(server));
// Initialize notification service
notificationService.init(io);

// PORT
const PORT = process.env.PORT || 3000;

// Start the server
server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

module.exports = io;
