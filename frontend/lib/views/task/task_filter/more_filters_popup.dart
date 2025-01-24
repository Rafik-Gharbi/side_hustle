import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/category.dart';
import '../../../models/filter_model.dart';
import '../../../services/theme/theme.dart';
import '../../../helpers/buildables.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown_2.dart';
import 'components/build_nearby_range.dart';
import 'components/build_price_range.dart';
import 'more_filter_controller.dart';

class MoreFiltersPopup extends StatelessWidget {
  final void Function(FilterModel) updateFilter;
  final void Function() clearFilter;
  final FilterModel filter;
  final bool isTasks;

  const MoreFiltersPopup({super.key, required this.updateFilter, required this.filter, required this.clearFilter, this.isTasks = true});

  @override
  Widget build(BuildContext context) => AlertDialog(
        surfaceTintColor: kNeutralColor100,
        backgroundColor: kNeutralColor100,
        contentPadding: const EdgeInsets.all(Paddings.large),
        insetPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
        content: SizedBox(
          height: Get.height * 0.65,
          width: Get.width,
          child: ClipRRect(
            borderRadius: regularRadius,
            child: GetBuilder<MoreFilterController>(
              init: MoreFilterController(),
              initState: (state) => Helper.waitAndExecute(() => state.controller != null, () => state.controller!.init(filter, isTasks)),
              didUpdateWidget: (oldWidget, state) => Helper.waitAndExecute(() => state.controller != null, () => state.controller!.init(filter, isTasks)),
              dispose: (state) => Helper.waitAndExecute(() => state.controller != null, () => state.controller!.filter = FilterModel()),
              autoRemove: false,
              builder: (controller) => Material(
                surfaceTintColor: Helper.isMobile ? kNeutralColor100 : Colors.transparent,
                borderRadius: regularRadius,
                color: Helper.isMobile ? kNeutralColor100 : Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(bottom: Paddings.large),
                      child: Center(child: Text('more_filters'.tr, style: AppFonts.x16Bold)),
                    ),
                    // Filters
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: Paddings.regular),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                              child: Text('category'.tr, style: AppFonts.x15Bold),
                            ),
                            CustomDropDownMenu2<Category>(
                              maxWidth: true,
                              dropdownMaxHeight: Get.height * 0.4,
                              selectedItem: controller.category,
                              hint: controller.category.name,
                              items: [anyCategory, ...MainAppController.find.categories],
                              valueFrom: (category) => '${category.name} (${category.subscribed})',
                              onChanged: (category) => controller.category = category!,
                            ),
                            Buildables.lightDivider(),
                            const BuildPriceRange(),
                            Buildables.lightDivider(),
                            const BuildNearbyRange(),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButtons.elevateSecondary(
                          title: 'clear_filter'.tr,
                          width: Get.width / 3,
                          onPressed: () {
                            controller.clearFilter();
                            clearFilter.call();
                          },
                        ),
                        const SizedBox(width: Paddings.regular),
                        CustomButtons.elevatePrimary(
                          title: 'filter'.tr,
                          loading: controller.isLoading,
                          width: Get.width / 3,
                          onPressed: () {
                            controller.isLoading.value = true;
                            updateFilter.call(controller.getFilterModel());
                            controller.isLoading.value = false;
                            Helper.goBack();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: Paddings.extraLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
