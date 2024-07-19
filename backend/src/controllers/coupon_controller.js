const { sequelize } = require("../../db.config");
const {
  calculateDateDifference,
  getDate,
  isValidPercentage,
  percentageFormatted,
  checkProperties,
} = require("../helper/helpers");
const { Coupon } = require("../models/coupon_model");
const { CouponReservation } = require("../models/coupon_reservation_model");
const { Property } = require("../models/property_model");
const { getPropertiesById } = require("../sql/property_sql");

exports.createCoupon = async (req, res) => {
  const {
    name,
    dateFrom,
    dateTo,
    percentage,
    includedProperties,
    excludedProperties,
  } = req.body;

  if (!name || !dateFrom || !dateTo || !percentage) {
    return res.status(400).json({ message: "missing" });
  }

  try {
    const existingCoupon = await Coupon.findOne({ where: { name: name } });
    if (existingCoupon) {
      return res.status(401).json({ message: "coupon_existing" });
    }

    let excludeIds = [];
    if (Array.isArray(excludedProperties) && excludedProperties.length > 0) {
      excludeIds = await checkProperties(excludedProperties);
      if (excludeIds.length !== excludedProperties.length) {
        return res.status(404).json({ message: "property_not_found" });
      }
    }

    let includeIds = [];
    if (Array.isArray(includedProperties) && includedProperties.length > 0) {
      includeIds = await checkProperties(includedProperties);
      if (includeIds.length !== includedProperties.length) {
        return res.status(404).json({ message: "property_not_found" });
      }
    }

    const isValidPercentage = percentageFormatted(percentage);
    if (isValidPercentage > 1) {
      return res.status(404).json({ message: "percentage_incorrect" });
    }

    const dayDiffFrom = calculateDateDifference(
      getDate(),
      dateFrom,
      "days",
      false
    );
    const dayDiffTo = calculateDateDifference(getDate(), dateTo, "days", false);

    const createdCoupon = await Coupon.create({
      name: name,
      dateFrom: dateFrom,
      dateTo: dateTo,
      percentage: isValidPercentage,
      exclude: excludeIds.join(","),
      include: includeIds.join(","),
      active: dayDiffFrom <= 0 && dayDiffTo >= 0 ? true : false,
    });

    return res.status(200).json({ result: createdCoupon });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.findAll = async (req, res) => {
  try {
    const couponFound = await Coupon.findAll();
    if (Array.isArray(couponFound) && couponFound.length > 0) {
      for (const coupon of couponFound) {
        // Calculate day differences
        const dayDiffFrom = calculateDateDifference(
          getDate(),
          coupon.dateFrom,
          "days",
          false
        );
        const dayDiffTo = calculateDateDifference(
          getDate(),
          coupon.dateTo,
          "days",
          false
        );

        // Deactivate coupons based on date calculations
        if (dayDiffFrom <= 0 && dayDiffTo <= 0 && coupon.active) {
          coupon.active = false;
          await coupon.save(); // Save changes if the coupon needs to be deactivated
        }

        // Split include and exclude properties if not null, otherwise assign empty array
        coupon.include = coupon.include
          ? await getPropertiesById(coupon.include.split(","))
          : null;
        coupon.exclude = coupon.exclude
          ? await getPropertiesById(coupon.exclude.split(","))
          : null;

        const couponReservation = await CouponReservation.findAll({
          where: {
            coupon_id: coupon.id,
          },
        });
        // Adding a temporary attribute for this session's response
        coupon.dataValues.timesUsed = couponReservation.length; // This is not saved to the database, only added for response purposes
      }
    }

    // Return the modified list of coupons
    return res.status(200).json(couponFound);
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error); // Displaying the error in console
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.getOne = async (req, res) => {
  try {
    if (!req.body.name) {
      return res.status(401).json({ message: "name_not_found" });
    }
    const couponFound = await Coupon.findOne({
      where: { name: req.body.name },
    });
    if (!couponFound) {
      return res.status(404).json({ message: "coupon_not_found" });
    }
    const daysDiff = calculateDateDifference(
      getDate(),
      couponFound.dateTo,
      "days",
      false
    );
    if (daysDiff < 0) {
      return res.status(401).json({ message: "coupon_expired" });
    }
    if (couponFound.properties != null) {
      const properties = couponFound.properties.split(",");
      couponFound.properties = properties;
    } else {
      couponFound.properties = [];
    }

    return res.status(200).json(couponFound);
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};

// Node.js update logic adjustment
exports.update = async (req, res) => {
  try {
    const id = req.params.id;
    const {
      name,
      percentage,
      dateFrom,
      dateTo,
      active,
      includedProperties,
      excludedProperties,
    } = req.body;

    if (!id) {
      return res.status(404).json({ message: "coupon_id_missing" });
    }

    const foundCoupon = await Coupon.findByPk(id);
    let updatedCoupon = { ...foundCoupon.dataValues };
    // Update various fields if provided
    if (name) foundCoupon.name = name;
    if (percentage) {
      const formattedPercentage = percentageFormatted(percentage);
      if (formattedPercentage > 1) {
        return res.status(404).json({ message: "percentage_incorrect" });
      }
      foundCoupon.percentage = formattedPercentage;
      updatedCoupon.percentage = formattedPercentage;
    }
    if (dateFrom) foundCoupon.dateFrom = dateFrom;
    if (dateTo) foundCoupon.dateTo = dateTo;
    if (active != null) {
      foundCoupon.active = active;
      updatedCoupon.active = active;
    }

    // Update excluded properties
    if (excludedProperties == null || excludedProperties.length === 0) {
      foundCoupon.exclude = null;
      updatedCoupon.exclude = null;
    } else {
      const excludeIds = await checkProperties(excludedProperties);
      if (excludeIds.length !== excludedProperties.length) {
        return res.status(404).json({ message: "property_not_found" });
      }

      updatedCoupon.exclude = updatedCoupon.exclude
        ? await getPropertiesById(updatedCoupon.exclude.split(","))
        : null;
    }

    // Update included properties
    if (includedProperties == null || includedProperties.length === 0) {
      foundCoupon.include = null;
    } else {
      const includeIds = await checkProperties(includedProperties);
      if (includeIds.length !== includedProperties.length) {
        return res.status(404).json({ message: "property_not_found" });
      }
      foundCoupon.include = includeIds.join(",");
      updatedCoupon.include = updatedCoupon.include
        ? await getPropertiesById(updatedCoupon.include.split(","))
        : null;
    }

    await foundCoupon.save();

    return res.status(200).json({ foundCoupon: updatedCoupon });
  } catch (error) {
    console.log(`Error at ${req.route.path}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return res.status(500).json({ message: "Internal Server Error" });
  }
};
