import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/loading_card_effect.dart';
import '../../../widgets/service_card.dart';
import '../../../widgets/store_card.dart';
import '../service_request/service_request_screen.dart';
import 'market_controller.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      init: MarketController(),
      initState: (state) => Helper.waitAndExecute(
        () => state.controller != null,
        () => state.controller?.fetchSearchedStores(),
      ),
      builder: (controller) => LoadingCardEffect(
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
    );
  }
}
