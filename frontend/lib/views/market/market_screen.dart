import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
import '../../models/filter_model.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../my_store/my_store_screen.dart';
import '../task_filter/more_filters_popup.dart';
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
            appBarTitle: 'Stores Market',
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
                      hintText: 'Search Store',
                      suffixIcon: const Icon(Icons.search, color: kPrimaryColor),
                      fillColor: Colors.white,
                      onChanged: (value) => Helper.onSearchDebounce(
                        () => value.length >= 3 || value.isEmpty ? controller.fetchSearchedStores() : null,
                      ),
                    ),
                  )
                : null,
            body: LoadingRequest(
              isLoading: controller.isLoading,
              child: controller.filteredStoreList.isEmpty
                  ? const Center(child: Text('We found nothing!', style: AppFonts.x14Regular))
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredStoreList.length,
                            itemBuilder: (context, index) {
                              final store = controller.filteredStoreList[index];
                              return OpenContainer(
                                closedElevation: 0,
                                transitionDuration: const Duration(milliseconds: 600),
                                openBuilder: (_, __) => MyStoreScreen(store: store),
                                closedBuilder: (_, openContainer) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: Paddings.regular),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                      shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                                      tileColor: kNeutralLightOpacityColor,
                                      splashColor: kPrimaryOpacityColor,
                                      onTap: openContainer,
                                      minVerticalPadding: Paddings.regular,
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // store picture
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: ClipRRect(
                                              borderRadius: smallRadius,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(color: kNeutralColor),
                                                child: store.picture?.file.path != null
                                                    ? Image.network(store.picture!.file.path, height: 100, width: 100, fit: BoxFit.cover)
                                                    : Center(child: Text('No Image', style: AppFonts.x12Regular.copyWith(color: kNeutralColor100))),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: Paddings.regular),
                                          // store title, governorate, and description
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(store.name ?? 'User Store', style: AppFonts.x14Bold),
                                                if (store.governorate != null)
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.pin_drop_outlined, size: 14, color: kNeutralColor),
                                                      const SizedBox(width: Paddings.regular),
                                                      Text(store.governorate!.name, style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                                                    ],
                                                  ),
                                                const SizedBox(height: Paddings.regular),
                                                Text(store.description ?? '', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                                                const SizedBox(height: Paddings.regular),
                                                // TODO add user review
                                                if (store.services != null)
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text('Has ${store.services!.length} services', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                                                        Text('Starting from ${Helper.formatAmount(controller.getStoreCheapestService(store))} TND',
                                                            style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          // Bookmark store
                                          // if (store.owner?.id != AuthenticationService.find.jwtUserData?.id)
                                          //   StatefulBuilder(builder: (context, setState) {
                                          //     Future<void> toggleFavorite() async {
                                          //       final result = await MainAppController.find.toggleFavoriteTask(store);
                                          //       setState(() => store.isFavorite = result);
                                          //       if (!result) onRemoveFavorite?.call();
                                          //       TaskDatabaseRepository.find.backupTask(store, isFavorite: true);
                                          //     }
                                          //     return Padding(
                                          //       padding: const EdgeInsets.only(left: Paddings.regular),
                                          //       child: CustomButtons.icon(
                                          //         icon: Icon(store.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined, size: 18),
                                          //         onPressed: () =>
                                          //             AuthenticationService.find.isUserLoggedIn.value ? toggleFavorite() : Helper.snackBar(message: 'login_save_store_msg'.tr),
                                          //       ),
                                          //     );
                                          //   })
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
      ),
    );
  }
}
