const {
  tokenVerification,
  tokenVerificationOptional,
} = require("../middlewares/authentificationHelper");
const { storeImageUpload } = require("../middlewares/multer-store");

module.exports = (app) => {
  const storeController = require("../controllers/store_controller");

  let router = require("express").Router();

  router.get("/user", tokenVerification, storeController.getUserStore);

  router.get("/id/:id", storeController.getStoreById);

  router.get(
    "/filter",
    tokenVerificationOptional,
    storeController.filterStores
  );

  router.get(
    "/hot-services",
    tokenVerificationOptional,
    storeController.getHotServices
  );

  router.post(
    "/",
    tokenVerification,
    storeImageUpload,
    storeController.addStore
  );

  router.post(
    "/service",
    tokenVerification,
    storeImageUpload,
    storeController.addService
  );

  router.put(
    "/service",
    tokenVerification,
    storeImageUpload,
    storeController.updateService
  );

  router.delete("/service", tokenVerification, storeController.deleteService);

  //   router.get(
  //     "/getAll",
  //     tokenVerification,
  //     roleMiddleware(["admin"]),
  //     storeController.getAll
  //   );
  //   router.get("/:id", tokenGetId, storeController.getDetail);
  //   router.get("/:id/:location", storeController.getCalendarPropertyId);
  //   router.post("/get-price", storeController.getPriceProperty);
  //   router.delete("/remove/:id", storeController.deleteProperty);

  app.use("/store", router);
};
