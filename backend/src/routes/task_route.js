const { tokenVerificationOptional, tokenVerification } = require("../middlewares/authentificationHelper");
const { taskImageUpload } = require("../middlewares/multer-task");

module.exports = (app) => {
  const taskController = require("../controllers/task_controller");

  let router = require("express").Router();

  router.get("/", tokenVerificationOptional, taskController.getAllTasks);
  router.get("/hot", tokenVerificationOptional, taskController.getHotTasks);
  router.get("/filter", tokenVerificationOptional, taskController.filterTasks);
  router.post("/", tokenVerification, taskImageUpload, taskController.addTask);
  //   router.get(
  //     "/getAll",
  //     tokenVerification,
  //     roleMiddleware(["admin"]),
  //     taskController.getAll
  //   );
  //   router.get("/:id", tokenGetId, taskController.getDetail);
  //   router.get("/:id/:location", taskController.getCalendarPropertyId);
  //   router.post("/get-price", taskController.getPriceProperty);
  //   router.delete("/remove/:id", taskController.deleteProperty);
  app.use("/task", router);
};
