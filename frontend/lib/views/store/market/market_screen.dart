import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/colors.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../viewmodel/reservation_viewmodel.dart';
import '../../../widgets/loading_card_effect.dart';
import '../../../widgets/main_screen_with_bottom_navigation.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/store_card.dart';
import '../service_request/service_request_screen.dart';
import 'market_controller.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasOpenedTutorial = false;
    return GetBuilder<MarketController>(
      initState: (state) => Helper.waitAndExecute(
        () => state.controller != null,
        () {
          FirebaseAnalytics.instance.logScreenView(screenName: 'MarketScreen');
          state.controller?.fetchSearchedStores();
        },
      ),
      builder: (controller) => Obx(
        () {
          final hasFinishedMarketTutorial = SharedPreferencesService.find.get(hasFinishedMarketTutorialKey) == 'true';
          if (!hasFinishedMarketTutorial && MainAppController.find.isMarketScreen && !hasOpenedTutorial && controller.targets.isNotEmpty && !controller.isLoading.value) {
            hasOpenedTutorial = true;
            MainScreenWithBottomNavigation.isOnTutorial.value = true;
            TutorialCoachMark(
              targets: controller.targets,
              colorShadow: kNeutralOpacityColor,
              additionalWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                child: Obx(
                  () => CheckboxListTile(
                    dense: true,
                    checkColor: kNeutralColor100,
                    contentPadding: EdgeInsets.zero,
                    side: BorderSide(color: kNeutralColor100),
                    title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                    value: MainScreenWithBottomNavigation.notShowAgain.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) => MainScreenWithBottomNavigation.notShowAgain.value = value ?? false,
                  ),
                ),
              ),
              textSkip: 'skip'.tr,
              textStyleSkip: AppFonts.x12Bold.copyWith(color: kBlackReversedColor),
              onSkip: () {
                if (MainScreenWithBottomNavigation.notShowAgain.value) {
                  SharedPreferencesService.find.add(hasFinishedMarketTutorialKey, 'true');
                  Future.delayed(Durations.medium4, () => MainScreenWithBottomNavigation.notShowAgain.value = false);
                }
                MainScreenWithBottomNavigation.isOnTutorial.value = false;
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedMarketTutorialKey, 'true'),
            ).show(context: context);
          }
          return MainAppController.find.isMarketScreen
              ? LoadingCardEffect(
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
                                                      isLoading: ReservationViewmodel.isLoading,
                                                      onSubmit: () => ReservationViewmodel.bookService(service),
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
                                    return StoreCard(key: index == 0 ? controller.firstStoreKey : null, store: store);
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
                )
              : const SizedBox();
        },
      ),
    );
  }
}
