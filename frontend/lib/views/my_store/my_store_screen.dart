import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/store.dart';
import '../../services/authentication_service.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../../widgets/loading_request.dart';
import '../../widgets/service_card.dart';
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
            final isOwner = controller.userStore?.owner?.id == AuthenticationService.find.jwtUserData?.id;
            return store != null
                ? Scaffold(
                    backgroundColor: kNeutralColor100,
                    body: buildStoreContent(controller, isOwner),
                  )
                : CustomScaffoldBottomNavigation(
                    appBarTitle: 'My Store',
                    appBarActions: [
                      if (isOwner)
                        CustomButtons.icon(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: controller.editStore,
                        )
                    ],
                    body: buildStoreContent(controller, isOwner),
                  );
          },
        ),
      );

  Widget buildStoreContent(MyStoreController controller, bool isOwner) {
    return LoadingRequest(
      isLoading: controller.isLoading,
      child: controller.userStore == null
          ? Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  CircleAvatar(radius: 40, backgroundColor: kNeutralLightColor, child: const Icon(Icons.store_outlined, size: 48)),
                  const SizedBox(height: Paddings.extraLarge),
                  const Text('You have no store yet!', style: AppFonts.x14Regular),
                  const Spacer(),
                  CustomButtons.elevatePrimary(
                    title: 'Create my store',
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
                          CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                          Text('store'.tr, style: AppFonts.x15Bold),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  if (controller.userStore?.picture?.file.path != null)
                    Image.network(controller.userStore!.picture!.file.path, height: 200, width: Get.width, fit: BoxFit.cover)
                  else if (!isOwner)
                    DecoratedBox(
                      decoration: BoxDecoration(color: kNeutralLightOpacityColor),
                      child: SizedBox(height: 200, child: Center(child: Text('No Image', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)))),
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
                              Text('Add store cover picture', style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
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
                        Text(controller.userStore?.name ?? 'User store', style: AppFonts.x18Bold),
                        const SizedBox(height: Paddings.small),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pin_drop_outlined, size: 14),
                            const SizedBox(width: Paddings.regular),
                            Text(controller.userStore?.governorate?.name ?? 'City', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        const SizedBox(height: Paddings.extraLarge),
                        const Text('Store description:', style: AppFonts.x15Bold),
                        const SizedBox(height: Paddings.regular),
                        Text(controller.userStore?.description ?? '', style: AppFonts.x14Regular, softWrap: true),
                        const SizedBox(height: Paddings.exceptional),
                        if (controller.userStore?.services?.isNotEmpty ?? false) ...[
                          const Text('Store services', style: AppFonts.x15Bold),
                          const SizedBox(height: Paddings.large),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.userStore?.services?.length ?? 0,
                            separatorBuilder: (context, index) => const SizedBox(height: Paddings.regular),
                            itemBuilder: (context, index) {
                              final service = controller.userStore?.services![index];
                              return ServiceCard(
                                service: service!,
                                requests: service.requests,
                                onBookService: () => isOwner
                                    ? Get.toNamed(ServiceRequestScreen.routeName, arguments: service)
                                    : AuthenticationService.find.isUserLoggedIn.value
                                        ? Get.bottomSheet(
                                            SizedBox(
                                              height: Get.height * 0.4,
                                              child: Material(
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(Paddings.large),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(height: Paddings.regular),
                                                      const Center(child: Text('Request a service', style: AppFonts.x16Bold)),
                                                      const SizedBox(height: Paddings.exceptional),
                                                      CustomTextField(
                                                        fieldController: controller.noteController,
                                                        isTextArea: true,
                                                        outlinedBorder: true,
                                                        outlinedBorderColor: kNeutralColor,
                                                        hintText: 'Add a note for the store owner',
                                                      ),
                                                      const SizedBox(height: Paddings.exceptional),
                                                      CustomButtons.elevatePrimary(
                                                        title: 'Submit a request',
                                                        width: Get.width,
                                                        onPressed: () => controller.bookService(service),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                          ).then((value) => controller.clearRequestFormFields())
                                        : Helper.snackBar(message: 'login_express_interest_msg'.tr),
                                isOwner: AuthenticationService.find.jwtUserData?.id == controller.userStore?.owner?.id,
                                onDeleteService: () => controller.deleteService(service),
                                onEditService: () => controller.editService(service),
                              );
                            },
                          )
                        ],
                        if (isOwner) ...[
                          const SizedBox(height: Paddings.exceptional * 2),
                          CustomButtons.elevatePrimary(
                            title: 'Add service',
                            width: Get.width,
                            onPressed: () => controller.addService(),
                          ),
                        ],
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
