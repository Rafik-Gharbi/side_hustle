import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/enum/request_status.dart';
import '../../../models/service.dart';
import '../../../models/store.dart';
import '../../../services/authentication_service.dart';
import '../../../services/logger_service.dart';
import '../../../services/theme/theme.dart';
import '../../../viewmodel/reservation_viewmodel.dart';
import '../../../widgets/custom_button_with_overlay.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/report_user_dialog.dart';
import '../../boost/add_boost/add_boost_bottomsheet.dart';
import '../service_request/service_request_screen.dart';
import 'service_details_controller.dart';

class ServiceDetailsScreen extends StatelessWidget {
  static const String routeName = '/service-details';
  final Service service;
  final Store? store;
  final RequestStatus? bookingStatus;
  final void Function()? onMarkDone;
  final bool? isTheOwner;

  const ServiceDetailsScreen({super.key, required this.service, this.store, this.bookingStatus, this.onMarkDone, this.isTheOwner});

  @override
  Widget build(BuildContext context) {
    final isOwner = isTheOwner ?? AuthenticationService.find.jwtUserData?.id == store?.owner?.id;
    double attachmentSize = (Get.width - 50) / 3;
    if ((service.gallery?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;
    return GetBuilder<ServiceDetailsController>(
      init: ServiceDetailsController(),
      tag: 'service-details-${service.id}',
      autoRemove: false,
      builder: (controller) => HoldInSafeArea(
        child: CustomStandardScaffold(
          backgroundColor: kNeutralColor100,
          title: '',
          noAppBar: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
                      CustomButtonWithOverlay(
                        offset: const Offset(-160, 30),
                        buttonWidth: 50,
                        button: const Icon(Icons.more_vert_outlined),
                        menu: DecoratedBox(
                          decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralColor100),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                if (isOwner) ...[
                                  ListTile(
                                    enabled: MainAppController.find.isConnected,
                                    shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                    title: Text('boost'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                                    leading: const Icon(Icons.rocket_launch_outlined),
                                    onTap: () {
                                      Helper.goBack();
                                      Get.bottomSheet(AddBoostBottomsheet(serviceId: service.id), isScrollControlled: true);
                                    },
                                  ),
                                  ListTile(
                                    enabled: MainAppController.find.isConnected,
                                    shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                    title: Text('edit'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                                    leading: const Icon(Icons.edit_outlined),
                                    onTap: () => controller.editService(service),
                                  ),
                                  ListTile(
                                    enabled: MainAppController.find.isConnected,
                                    shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                    title: Text('delete'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                                    leading: const Icon(Icons.delete_forever_outlined),
                                    onTap: () => controller.deleteService(service),
                                  ),
                                ] else
                                  ListTile(
                                    enabled: MainAppController.find.isConnected,
                                    shape: OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide.none),
                                    title: Text('report'.tr, style: AppFonts.x14Bold.copyWith(color: MainAppController.find.isConnected ? kBlackColor : kDisabledColor)),
                                    leading: const Icon(Icons.report_outlined),
                                    onTap: () async {
                                      Helper.goBack();
                                      Get.bottomSheet(ReportUserDialog(user: store!.owner!, service: service), isScrollControlled: true);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Paddings.large),
                  Text(service.name ?? 'service'.tr, style: AppFonts.x16Bold),
                  Row(
                    children: [
                      Buildables.buildCategoryIcon(service.category!.icon),
                      const SizedBox(width: Paddings.regular),
                      Text(service.category?.name ?? '', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                    ],
                  ),
                  const SizedBox(height: Paddings.exceptional),
                  Text('description'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                  const SizedBox(height: Paddings.regular),
                  Text(service.description ?? '', style: AppFonts.x14Regular),
                  const SizedBox(height: Paddings.exceptional),
                  if (service.included != null) ...[
                    Text('whats_included'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                    const SizedBox(height: Paddings.regular),
                    Text(service.included!, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                  if (service.notIncluded != null) ...[
                    Text('whats_not_included'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                    const SizedBox(height: Paddings.regular),
                    Text(service.notIncluded!, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                  if (service.notes != null) ...[
                    Text('notes'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                    const SizedBox(height: Paddings.regular),
                    Text(service.notes!, style: AppFonts.x14Regular),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                  if (service.gallery != null && service.gallery!.isNotEmpty) ...[
                    Text('gallery'.tr, style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                    const SizedBox(height: Paddings.regular),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          service.gallery?.length ?? 0,
                          (index) {
                            final attachment = service.gallery![index];
                            return Padding(
                              padding: EdgeInsets.only(right: index < service.gallery!.length - 1 ? Paddings.regular : 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                                child: SizedBox(
                                  width: attachmentSize,
                                  height: attachmentSize,
                                  child: attachment.type == ImageType.file
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(Paddings.small),
                                            child: Text(attachment.file.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: smallRadius,
                                          child: CachedNetworkImage(
                                            imageUrl: attachment.file.path,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context, url, downloadProgress) => Lottie.asset(Assets.pictureLoading, fit: BoxFit.cover),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                            errorListener: (error) => LoggerService.logger?.e(error),
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Paddings.exceptional),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.monetization_on_outlined),
                      const SizedBox(width: Paddings.regular),
                      Text('${'price'.tr}:', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                      const SizedBox(width: Paddings.regular),
                      Text('${Helper.formatAmount(service.price ?? 0)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold.copyWith(color: kNeutralColor)),
                    ],
                  ),
                  if (service.timeEstimationFrom != null && service.timeEstimationFrom != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: Paddings.regular),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined),
                          const SizedBox(width: Paddings.regular),
                          Text('${'time_estimation'.tr}:', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
                          const SizedBox(width: Paddings.regular),
                          Text(
                            '${Helper.formatAmount(service.timeEstimationFrom!)} ${service.timeEstimationTo != null ? '- ${Helper.formatAmount(service.timeEstimationTo!)} hours' : 'hours'}',
                            style: AppFonts.x14Bold.copyWith(color: kNeutralColor),
                          ),
                        ],
                      ),
                    ),
                  if (controller.condidates.value != -1 || store != null && isOwner || bookingStatus == RequestStatus.confirmed) ...[
                    const SizedBox(height: Paddings.exceptional * 2),
                    if (isOwner && store != null)
                      CustomButtons.elevatePrimary(
                        disabled: !MainAppController.find.isConnected,
                        title: 'check_request'.tr,
                        onPressed: () => Get.toNamed(ServiceRequestScreen.routeName, arguments: service),
                        width: Get.width,
                      )
                    else if (bookingStatus == null && !isOwner)
                      CustomButtons.elevatePrimary(
                        disabled: !MainAppController.find.isConnected,
                        title: 'book_service'.tr,
                        width: Get.width,
                        onPressed: () => Helper.verifyUser(
                          isVerified: true,
                          () => Buildables.requestBottomsheet(
                            noteController: controller.noteController,
                            isLoading: ReservationViewmodel.isLoading,
                            onSubmit: () => ReservationViewmodel.bookService(service),
                            neededCoins: service.coins,
                          ).then((value) => controller.clearFormFields()),
                        ),
                      )
                    else if (bookingStatus == RequestStatus.confirmed && onMarkDone != null)
                      CustomButtons.elevatePrimary(
                        disabled: !MainAppController.find.isConnected,
                        loading: ReservationViewmodel.isLoading,
                        title: 'mark_service_done'.tr,
                        titleStyle: AppFonts.x14Regular,
                        icon: Icon(Icons.done, color: kNeutralColor100),
                        width: Get.width - 40,
                        onPressed: onMarkDone!,
                      ),
                  ],
                  const SizedBox(height: Paddings.exceptional),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
