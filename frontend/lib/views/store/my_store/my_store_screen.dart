import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/store.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
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
  Widget build(BuildContext context) => HoldInSafeArea(
        child: GetBuilder<MyStoreController>(
          init: MyStoreController(store: store),
          builder: (controller) {
            final isOwner = controller.currentStore == null || controller.currentStore?.owner?.id == AuthenticationService.find.jwtUserData?.id;
            return store != null
                ? Scaffold(
                    backgroundColor: kNeutralColor100,
                    body: buildStoreContent(controller, isOwner),
                  )
                : CustomScaffoldBottomNavigation(
                    appBarTitle: 'my_store'.tr,
                    onBack: () => ProfileController.find.init(),
                    appBarActions: [buildMoreButton(isOwner, controller)],
                    body: buildStoreContent(controller, isOwner),
                  );
          },
        ),
      );

  CustomButtonWithOverlay buildMoreButton(bool isOwner, MyStoreController controller) {
    return CustomButtonWithOverlay(
      offset: const Offset(-170, 30),
      buttonWidth: 50,
      button: const Icon(Icons.more_vert_outlined),
      menu: DecoratedBox(
        decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
        child: SizedBox(
          width: 200,
          height: isOwner && controller.currentStore?.coordinates != null ? 180 : 120,
          child: Column(
            children: [
              ListTile(
                shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                title: Text('bookmark'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                leading: Icon(store?.isFavorite ?? false ? Icons.bookmark_outlined : Icons.bookmark_add_outlined),
                onTap: () {
                  Helper.goBack();
                  Helper.verifyUser(() async {
                    await MainAppController.find.toggleFavoriteStore(store!);
                    controller.update();
                  });
                },
              ),
              if (controller.currentStore?.coordinates != null)
                ListTile(
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('get_directions'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  leading: const Icon(Icons.near_me_outlined),
                  onTap: controller.openStoreItinerary,
                ),
              if (isOwner)
                ListTile(
                  shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                  title: Text('edit'.tr, style: AppFonts.x14Bold.copyWith(color: kBlackColor)),
                  leading: const Icon(Icons.edit_outlined),
                  onTap: controller.editStore,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStoreContent(MyStoreController controller, bool isOwner) {
    return LoadingRequest(
      isLoading: controller.isLoading,
      child: controller.currentStore == null && isOwner
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
                    title: 'create_store'.tr,
                    width: Get.width,
                    onPressed: controller.createStore,
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
                  if (controller.currentStore?.picture?.file.path != null)
                    Image.network(controller.currentStore!.picture!.file.path, height: 200, width: Get.width, fit: BoxFit.cover)
                  else if (!isOwner)
                    DecoratedBox(
                      decoration: BoxDecoration(color: kNeutralLightOpacityColor),
                      child: SizedBox(height: 200, child: Center(child: Text('no_image'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)))),
                    )
                  else
                    InkWell(
                      onTap: controller.addStorePicture,
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
                        Text(controller.currentStore?.name ?? 'user_store'.tr, style: AppFonts.x18Bold),
                        const SizedBox(height: Paddings.small),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pin_drop_outlined, size: 14),
                            const SizedBox(width: Paddings.regular),
                            Text(controller.currentStore?.governorate?.name ?? 'city'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        const SizedBox(height: Paddings.extraLarge),
                        Text('store_description'.tr, style: AppFonts.x15Bold),
                        const SizedBox(height: Paddings.regular),
                        Text(controller.currentStore?.description ?? '', style: AppFonts.x14Regular, softWrap: true),
                        const SizedBox(height: Paddings.exceptional),
                        if (controller.currentStore?.services?.isNotEmpty ?? false) ...[
                          Text('store_services'.tr, style: AppFonts.x15Bold),
                          const SizedBox(height: Paddings.large),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.currentStore?.services?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: Paddings.regular),
                            itemBuilder: (context, index) {
                              final service = controller.currentStore?.services![index];
                              return ServiceCard(
                                store: store ?? controller.currentStore!,
                                service: service!,
                                requests: service.requests,
                                onBookService: () => isOwner
                                    ? Get.toNamed(ServiceRequestScreen.routeName, arguments: service)
                                    : Helper.verifyUser(
                                        isVerified: true,
                                        () => Buildables.requestBottomsheet(
                                          noteController: controller.noteController,
                                          onSubmit: () => controller.bookService(service),
                                          neededCoins: service.coins,
                                        ).then((value) => controller.clearRequestFormFields()),
                                      ),
                                isOwner: AuthenticationService.find.jwtUserData?.id == controller.currentStore?.owner?.id,
                                onDeleteService: () => controller.deleteService(service),
                                onEditService: () => controller.editService(service),
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
                              width: Get.width,
                              onPressed: () => controller.addService(),
                            ),
                          ),
                        Text('store_owner_rating'.tr, style: AppFonts.x15Bold),
                        const SizedBox(height: Paddings.regular),
                        RatingOverview(
                          onShowAllReviews: () => Get.bottomSheet(AllReviews(reviews: controller.storeOwnerReviews, isBottomsheet: true), isScrollControlled: true),
                          rating: controller.currentStore?.rating ?? 0,
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
