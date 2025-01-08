import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../add_boost/add_boost_bottomsheet.dart';
import 'components/boost_card.dart';
import 'list_boost_controller.dart';

class ListBoostScreen extends StatelessWidget {
  static const String routeName = '/boost';

  const ListBoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ListBoostController>(
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () {
            state.controller?.page = 0;
            state.controller?.fetchUserBoosts();
          },
        ),
        builder: (controller) => CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: 'my_boosts'.tr,
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.boostList.isEmpty
                ? Center(child: Text('found_nothing'.tr, style: AppFonts.x14Regular))
                : SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.boostList.length,
                          itemBuilder: (context, index) {
                            final boost = controller.boostList[index];
                            return BoostCard(
                              boost: boost,
                              isExpanded: controller.isExpanded,
                              expand: controller.expandTile,
                              getTask: controller.getTask,
                              getService: controller.getService,
                              toggleBoostActive: controller.toggleBoostActive,
                              onEditBoost: () => Get.bottomSheet(AddBoostBottomsheet(boost: boost), isScrollControlled: true).then((value) {
                                controller.page = 0;
                                controller.fetchUserBoosts();
                              }),
                            );
                          },
                        ),
                        Obx(
                          () => controller.isLoadingMore.value && !controller.isEndList
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
                                  child: SizedBox(height: 60, width: Get.width, child: Center(child: Buildables.buildLoadingWidget(height: 80))),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
