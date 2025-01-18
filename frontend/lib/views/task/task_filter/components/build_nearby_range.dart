import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../helpers/helper.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/custom_text_field.dart';
import '../more_filter_controller.dart';

class BuildNearbyRange extends StatelessWidget {
  const BuildNearbyRange({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoreFilterController>(
      builder: (controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
            child: Text('nearby'.tr, style: AppFonts.x15Bold),
          ),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: Slider(
                    min: 1,
                    max: 100,
                    activeColor: kPrimaryColor,
                    value: controller.nearbyRange.value,
                    onChanged: AuthenticationService.find.jwtUserData?.coordinates == null ? null : (double value) => controller.nearbyRange.value = value,
                  ),
                ),
                CustomTextField(
                  width: 100,
                  textFontSize: 14,
                  enabled: AuthenticationService.find.jwtUserData?.coordinates != null,
                  fieldController: TextEditingController(text: '${controller.nearbyRange.value.toStringAsFixed(0)} ${'km'.tr}'),
                  textInputType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => Helper.onSearchDebounce(
                    () => controller.nearbyRange.value = double.parse(value.contains(' ') ? value.substring(0, value.indexOf(' ')) : value),
                  ),
                ),
              ],
            ),
          ),
          if (AuthenticationService.find.jwtUserData?.coordinates == null)
            InkWell(
              onTap: controller.shareLocation,
              child: Padding(
                padding: const EdgeInsets.all(Paddings.small),
                child: DecoratedBox(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.6))),
                  child: Text('share_your_location'.tr, style: AppFonts.x12Regular),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
