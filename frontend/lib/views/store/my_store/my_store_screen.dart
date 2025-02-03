import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/store.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../services/tutorials/create_store_tutorial.dart';
import '../../../viewmodel/reservation_viewmodel.dart';
import '../../../viewmodel/store_viewmodel.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/main_screen_with_bottom_navigation.dart';
import '../../../widgets/service_card.dart';
import '../../profile/profile_screen/profile_controller.dart';
import '../../review/all_reviews.dart';
import '../../review/rating_overview.dart';
import '../service_request/service_request_screen.dart';
import 'my_store_controller.dart';

class MyStoreScreen extends StatelessWidget {
  static const String routeName = '/my-store';
  final Store? store;
  const MyStoreScreen({super.key, this.store});

  @override
  Widget build(BuildContext context) {
    RxBool hasOpenedTutorial = false.obs;
    return HoldInSafeArea(
      child: GetBuilder<MyStoreController>(
        init: MyStoreController(store: store),
        initState: (state) => Helper.waitAndExecute(() => state.controller != null && !(state.controller?.isLoading.value ?? true), () {
          final hasFinishedCreateStoreTutorial = SharedPreferencesService.find.get(hasFinishedCreateStoreTutorialKey) == 'true';
          if (!hasFinishedCreateStoreTutorial && Get.currentRoute == routeName && !hasOpenedTutorial.value && state.controller!.targets.isNotEmpty) {
            hasOpenedTutorial.value = true;
            MainScreenWithBottomNavigation.isOnTutorial.value = true;
            TutorialCoachMark(
              targets: state.controller!.targets,
              colorShadow: kNeutralOpacityColor,
              textSkip: 'skip'.tr,
              textStyleSkip: AppFonts.x12Bold.copyWith(color: kBlackReversedColor),
              additionalWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                child: Obx(
                  () => CheckboxListTile(
                    dense: true,
                    checkColor: kNeutralColor100,
                    contentPadding: EdgeInsets.zero,
                    side: BorderSide(color: kNeutralColor100),
                    title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                    value: CreateStoreTutorial.notShowAgain.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) => CreateStoreTutorial.notShowAgain.value = value ?? false,
                  ),
                ),
              ),
              onSkip: () {
                if (CreateStoreTutorial.notShowAgain.value) {
                  SharedPreferencesService.find.add(hasFinishedCreateStoreTutorialKey, 'true');
                }
                MainScreenWithBottomNavigation.isOnTutorial.value = false;
                hasOpenedTutorial.value = false;
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedCreateStoreTutorialKey, 'true'),
            ).show(context: context);
          }
        }),
        builder: (controller) {
          final isOwner = StoreViewmodel.currentStore == null || StoreViewmodel.currentStore?.owner?.id == AuthenticationService.find.jwtUserData?.id;
          return Obx(
            () => PopScope(
              canPop: !hasOpenedTutorial.value,
              child: store != null
                  ? Scaffold(
                      backgroundColor: kNeutralColor100,
                      body: buildStoreContent(controller, isOwner),
                    )
                  : CustomStandardScaffold(
                      backgroundColor: kNeutralColor100,
                      title: 'my_store'.tr,
                      onBack: () => ProfileController.find.init(),
                      actionButton: buildMoreButton(isOwner, controller),
                      body: buildStoreContent(controller, isOwner),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMoreButton(bool isOwner, MyStoreController controller) {
    return StoreViewmodel.currentStore != null
        ? CustomButtonWithOverlay(
            offset: const Offset(-170, 30),
            buttonWidth: 50,
            button: const Icon(Icons.more_vert_outlined),
            menu: DecoratedBox(
              decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    ListTile(
                      enabled: MainAppController.find.isConnected,
                      shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                      title: Text('bookmark'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                      leading: Icon(store?.isFavorite ?? false ? Icons.bookmark_outlined : Icons.bookmark_add_outlined),
                      onTap: () {
                        Helper.goBack();
                        Helper.verifyUser(() async {
                          await MainAppController.find.toggleFavoriteStore(store!);
                          controller.update();
                        });
                      },
                    ),
                    if (StoreViewmodel.currentStore?.coordinates != null)
                      ListTile(
                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                        title: Text('get_directions'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                        leading: const Icon(Icons.near_me_outlined),
                        onTap: controller.openStoreItinerary,
                      ),
                    if (isOwner) ...[
                      ListTile(
                        enabled: MainAppController.find.isConnected,
                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                        title: Text('edit'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                        leading: const Icon(Icons.edit_outlined),
                        onTap: controller.editStore,
                      ),
                      ListTile(
                        enabled: MainAppController.find.isConnected,
                        shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                        title: Text('delete'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                        leading: const Icon(Icons.delete_forever_outlined),
                        onTap: controller.deleteStore,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget buildStoreContent(MyStoreController controller, bool isOwner) {
    return LoadingRequest(
      isLoading: controller.isLoading,
      child: StoreViewmodel.currentStore == null && isOwner
          ? Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  CircleAvatar(radius: 40, backgroundColor: kNeutralLightColor, child: const Icon(Icons.store_outlined, size: 48)),
                  const SizedBox(height: Paddings.extraLarge),
                  Text('have_no_store'.tr, style: AppFonts.x14Regular),
                  const Spacer(),
                  CustomButtons.elevatePrimary(
                    disabled: !MainAppController.find.isConnected,
                    key: controller.createStoreBtnKey,
                    title: 'create_store'.tr,
                    loading: StoreViewmodel.isLoading,
                    width: Get.width,
                    onPressed: controller.createStore,
                  ),
                  const SizedBox(height: Paddings.regular),
                  CustomButtons.elevateSecondary(
                    title: 'later'.tr,
                    width: Get.width,
                    onPressed: Get.back,
                  ),
                  const SizedBox(height: Paddings.exceptional * 2),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (store != null)
                    // OpenContainer Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
                          Text('store'.tr, style: AppFonts.x15Bold),
                          buildMoreButton(isOwner, controller),
                        ],
                      ),
                    ),
                  if (!Helper.isNullOrEmpty(StoreViewmodel.currentStore?.picture?.file.path))
                    CachedNetworkImage(
                      imageUrl: StoreViewmodel.currentStore!.picture!.file.path,
                      height: 200, width: Get.width, fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Lottie.asset(Assets.pictureLoading, fit: BoxFit.cover),
                      errorWidget: (context, url, error) => DecoratedBox(
                        decoration: BoxDecoration(color: kNeutralOpacityColor),
                        child: Center(child: Icon(Icons.error, color: kNeutralLightColor)),
                      ),
                      // errorListener: (error) => LoggerService.logger?.e(error),
                    )
                  else if (!isOwner)
                    DecoratedBox(
                      decoration: BoxDecoration(color: kNeutralOpacityColor),
                      child: SizedBox(height: 200, child: Center(child: ClipRRect(borderRadius: smallRadius, child: Image.asset(Assets.noImage, height: 140)))),
                    )
                  else
                    InkWell(
                      onTap: MainAppController.find.isConnected ? controller.addStorePicture : null,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: kNeutralLightOpacityColor),
                        child: SizedBox(
                          width: Get.width,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined, size: 24, color: kNeutralColor),
                              const SizedBox(height: Paddings.small),
                              Text('add_store_cover'.tr, style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Paddings.small),
                        Text(StoreViewmodel.currentStore?.name ?? 'user_store'.tr, style: AppFonts.x18Bold),
                        const SizedBox(height: Paddings.small),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pin_drop_outlined, size: 14),
                            const SizedBox(width: Paddings.regular),
                            Text(StoreViewmodel.currentStore?.governorate?.name ?? 'city'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        const SizedBox(height: Paddings.extraLarge),
                        Text('store_description'.tr, style: AppFonts.x15Bold),
                        const SizedBox(height: Paddings.regular),
                        Text(StoreViewmodel.currentStore?.description ?? '', style: AppFonts.x14Regular, softWrap: true),
                        const SizedBox(height: Paddings.exceptional),
                        if (StoreViewmodel.currentStore?.services?.isNotEmpty ?? false) ...[
                          Text('store_services'.tr, style: AppFonts.x15Bold),
                          const SizedBox(height: Paddings.large),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: StoreViewmodel.currentStore?.services?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: Paddings.regular),
                            itemBuilder: (context, index) {
                              final service = StoreViewmodel.currentStore?.services![index];
                              return ServiceCard(
                                store: store ?? StoreViewmodel.currentStore!,
                                service: service!,
                                requests: service.requests,
                                onBookService: MainAppController.find.isConnected
                                    ? () => isOwner
                                        ? Get.toNamed(ServiceRequestScreen.routeName, arguments: service)
                                        : Helper.verifyUser(
                                            isVerified: true,
                                            () => Buildables.requestBottomsheet(
                                              noteController: ReservationViewmodel.noteController,
                                              onSubmit: () => ReservationViewmodel.bookService(service),
                                              isLoading: ReservationViewmodel.isLoading,
                                              neededCoins: service.coins,
                                            ).then((value) => ReservationViewmodel.clearRequestFormFields()),
                                          )
                                    : null,
                                isOwner: AuthenticationService.find.jwtUserData?.id == StoreViewmodel.currentStore?.owner?.id,
                                onDeleteService: MainAppController.find.isConnected ? () => controller.deleteService(service) : null,
                                onEditService: MainAppController.find.isConnected ? () => controller.editService(service) : null,
                                isHighlighted: controller.highlightedService?.id == service.id,
                              );
                            },
                          )
                        ],
                        if (isOwner)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Paddings.exceptional),
                            child: CustomButtons.elevatePrimary(
                              title: 'add_service'.tr,
                              disabled: !MainAppController.find.isConnected,
                              width: Get.width,
                              onPressed: () => StoreViewmodel.addService(),
                            ),
                          ),
                        Text('store_owner_rating'.tr, style: AppFonts.x15Bold),
                        const SizedBox(height: Paddings.regular),
                        RatingOverview(
                          onShowAllReviews: () => Get.bottomSheet(AllReviews(reviews: controller.storeOwnerReviews, isBottomsheet: true), isScrollControlled: true),
                          rating: StoreViewmodel.currentStore?.rating ?? 0,
                          reviews: controller.storeOwnerReviews,
                        ),
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
