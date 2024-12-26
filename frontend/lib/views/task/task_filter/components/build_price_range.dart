import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/helper.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_text_field.dart';
import '../more_filter_controller.dart';

class BuildPriceRange extends StatelessWidget {
  const BuildPriceRange({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoreFilterController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
            child: Text('price_range'.tr, style: AppFonts.x15Bold),
          ),
          RangeSlider(
            min: kMinPriceRange,
            max: kMaxPriceRange,
            activeColor: kPrimaryColor,
            onChanged: (value) => controller.managePriceFilter(range: value),
            values: RangeValues(
              double.tryParse(controller.minPriceController.text) ?? kMinPriceRange,
              double.tryParse(controller.maxPriceController.text) ?? kMaxPriceRange,
            ),
          ),
          GetBuilder<MainAppController>(
            builder: (mainAppController) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 140,
                  child: CustomTextField(
                    hintText: 'minimum'.tr,
                    hintTextStyle: AppFonts.x12Regular,
                    enableFloatingLabel: true,
                    fieldController: controller.minPriceController,
                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: Paddings.regular),
                      child: Text(mainAppController.currency.value, style: AppFonts.x12Bold),
                    ),
                    onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(min: value)),
                  ),
                ),
                Container(
                  height: 1,
                  width: 10,
                  color: kNeutralColor,
                  margin: const EdgeInsets.symmetric(vertical: 25),
                ),
                SizedBox(
                  width: 140,
                  child: CustomTextField(
                    hintText: 'maximum'.tr,
                    hintTextStyle: AppFonts.x12Regular,
                    enableFloatingLabel: true,
                    fieldController: controller.maxPriceController,
                    textInputType: const TextInputType.numberWithOptions(decimal: true),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: Paddings.regular),
                      child: Text(mainAppController.currency.value, style: AppFonts.x12Bold),
                    ),
                    onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(max: value)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
