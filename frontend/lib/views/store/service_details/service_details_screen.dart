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
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../service_request/service_request_screen.dart';
import 'service_details_controller.dart';

class ServiceDetailsScreen extends StatelessWidget {
  static const String routeName = '/service-details';
  final Service service;
  final Store? store;
  final RequestStatus? bookingStatus;
  final void Function()? onMarkDone;

  const ServiceDetailsScreen({super.key, required this.service, this.store, this.bookingStatus, this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    double attachmentSize = (Get.width - 50) / 3;
    if ((service.gallery?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;
    return GetBuilder<ServiceDetailsController>(
      init: ServiceDetailsController(),
      tag: 'service-details-${service.id}',
      autoRemove: false,
      builder: (controller) => HoldInSafeArea(
        child: CustomScaffoldBottomNavigation(
          noAppBar: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                  const SizedBox(height: Paddings.large),
                  Text(service.name ?? 'Service', style: AppFonts.x16Bold),
                  Row(
                    children: [
                      Icon(service.category?.icon, size: 14),
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
                  if (service.timeEstimationFrom != null)
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
                  if (controller.condidates.value != -1 ||
                      store != null && AuthenticationService.find.jwtUserData?.id == store!.owner?.id ||
                      bookingStatus == RequestStatus.confirmed) ...[
                    const SizedBox(height: Paddings.exceptional * 2),
                    if (AuthenticationService.find.jwtUserData?.id == store?.owner?.id && store != null)
                      CustomButtons.elevatePrimary(
                        title: 'check_request'.tr,
                        onPressed: () => Get.toNamed(ServiceRequestScreen.routeName, arguments: service),
                        width: Get.width,
                      )
                    else if (bookingStatus == null)
                      CustomButtons.elevatePrimary(
                        title: 'book_service'.tr,
                        onPressed: () => AuthenticationService.find.isUserLoggedIn.value
                            ? Buildables.requestBottomsheet(noteController: controller.noteController, onSubmit: () => controller.bookService(service))
                                .then((value) => controller.clearFormFields())
                            : Helper.snackBar(message: 'login_express_interest_msg'.tr),
                        width: Get.width,
                      )
                    else if (bookingStatus == RequestStatus.confirmed && onMarkDone != null)
                      CustomButtons.elevatePrimary(
                        title: 'Mark service as done',
                        titleStyle: AppFonts.x14Regular,
                        icon: const Icon(Icons.done, color: kNeutralColor100),
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