import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/filter_model.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_card_effect.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/store_card.dart';
import '../../task/task_filter/more_filters_popup.dart';
import '../service_request/service_request_screen.dart';
import 'market_controller.dart';

class MarketScreen extends StatelessWidget {
  static const String routeName = '/market';
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<MarketController>(
        initState: (state) => Helper.waitAndExecute(
          () => state.controller != null,
          () => state.controller?.fetchSearchedStores(),
        ),
        builder: (controller) => Obx(
          () => CustomScaffoldBottomNavigation(
            appBarTitle: 'stores_market'.tr,
            appBarActions: [
              CustomButtons.icon(
                icon: Icon(controller.openSearchBar.value ? Icons.search_off_outlined : Icons.search_outlined),
                onPressed: () => controller.openSearchBar.value = !controller.openSearchBar.value,
              ),
              CustomButtons.icon(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () => Get.dialog(
                  MoreFiltersPopup(
                    updateFilter: (filter) => controller.filterModel = filter,
                    clearFilter: () => controller.filterModel = FilterModel(),
                    filter: controller.filterModel,
                  ),
                ),
              ),
            ],
            appBarBottom: controller.openSearchBar.value
                ? AppBar(
                    backgroundColor: kNeutralColor100,
                    leading: const SizedBox(),
                    flexibleSpace: CustomTextField(
                      fieldController: controller.searchStoreController,
                      hintText: 'search_store'.tr,
                      suffixIcon: const Icon(Icons.search, color: kPrimaryColor),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(
                        () {
                          if (value.length >= 3 || value.isEmpty) {
                            controller.page = 0;
                            controller.fetchSearchedStores();
                          }
                        },
                      ),
                    ),
                  )
                : null,
            body: LoadingCardEffect(
              isLoading: controller.isLoading,
              type: LoadingCardEffectType.store,
              child: controller.filteredStoreList.isEmpty
                  ? Center(child: Text('found_nothing'.tr, style: AppFonts.x14Regular))
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                        child: Column(
                          children: [
                            if (controller.hotServices.isNotEmpty) ...[
                              Buildables.buildTitle('hot_services'.tr),
                              LoadingCardEffect(
                                isLoading: controller.isLoading,
                                type: LoadingCardEffectType.task,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.hotServices.length,
                                  itemBuilder: (context, index) {
                                    final service = controller.hotServices[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: Paddings.small),
                                      child: ServiceCard(
                                        additionSubtitle: 'by_store_name'.trParams({'storeName': controller.getServiceStore(service).name!}),
                                        service: service,
                                        store: controller.getServiceStore(service),
                                        onBookService: () => controller.getServiceStore(service).owner?.id == AuthenticationService.find.jwtUserData?.id
                                            ? Get.toNamed(ServiceRequestScreen.routeName, arguments: service)
                                            : Helper.verifyUser(
                                                isVerified: true,
                                                () => Buildables.requestBottomsheet(
                                                  noteController: controller.noteController,
                                                  onSubmit: () => controller.bookService(service),
                                                  neededCoins: service.coins,
                                                ).then((value) => controller.clearRequestFormFields()),
                                              ),
                                        isOwner: AuthenticationService.find.jwtUserData?.id == controller.getServiceStore(service).owner?.id,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(height: Paddings.extraLarge),
                            Buildables.buildTitle('stores'.tr),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.filteredStoreList.length,
                              itemBuilder: (context, index) {
                                final store = controller.filteredStoreList[index];
                                return StoreCard(store: store);
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
        ),
      ),
    );
  }
}
