import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/enum/request_status.dart';
import '../models/service.dart';
import '../models/store.dart';
import '../services/theme/theme.dart';
import '../views/store/service_details/service_details_screen.dart';
import 'custom_buttons.dart';
import 'overflowed_text_with_tooltip.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final Store? store;
  final void Function()? onBookService;
  final void Function()? onDeleteService;
  final void Function()? onEditService;
  final void Function()? onMarkDone;
  final bool isOwner;
  final int requests;
  final RequestStatus? bookingStatus;
  final bool dense;
  final bool isHighlighted;

  const ServiceCard({
    super.key,
    required this.service,
    this.store,
    this.onBookService,
    this.onDeleteService,
    this.onEditService,
    this.isOwner = false,
    this.requests = -1,
    this.bookingStatus,
    this.onMarkDone,
    this.dense = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (_, __) => ServiceDetailsScreen(service: service, store: store, bookingStatus: bookingStatus, onMarkDone: onMarkDone),
      closedBuilder: (_, openContainer) => isOwner
          ? SwipeActionCell(
              key: ObjectKey(service),
              backgroundColor: Colors.transparent,
              trailingActions: [
                SwipeAction(
                  performsFirstActionWithFullSwipe: true,
                  icon: const Icon(Icons.delete_forever_rounded, color: kNeutralColor100),
                  onTap: (handler) => onDeleteService?.call(),
                  color: kErrorColor,
                ),
                SwipeAction(
                  performsFirstActionWithFullSwipe: true,
                  icon: const Icon(Icons.edit_outlined, color: kNeutralColor100),
                  onTap: (handler) => onEditService?.call(),
                  color: kSelectedColor,
                ),
              ],
              child: buildServiceCard(),
            )
          : buildServiceCard(),
    );
  }

  Widget buildServiceCard() {
    bool highlighted = false;
    return StatefulBuilder(builder: (context, setState) {
      if (context.mounted) Future.delayed(const Duration(milliseconds: 600), () => setState(() => highlighted = isHighlighted));
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
        shape: dense
            ? const OutlineInputBorder(borderSide: BorderSide(color: kNeutralColor100))
            : RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
        tileColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
        splashColor: kPrimaryOpacityColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Get.width - 160, child: OverflowedTextWithTooltip(title: service.name ?? 'NA', style: AppFonts.x14Bold, expand: false)),
                  Text(service.description ?? 'NA', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                ],
              ),
            ),
            if (!dense)
              Badge(
                isLabelVisible: isOwner,
                offset: Offset(requests > 99 ? -5 : 0, 5),
                label: Text(requests > 99 ? '+99' : requests.toString(), style: AppFonts.x11Bold.copyWith(color: kNeutralColor100)),
                backgroundColor: isOwner ? kErrorColor : Colors.transparent,
                child: CustomButtons.icon(
                  icon: Icon(isOwner ? Icons.three_p_outlined : Icons.shopping_cart_outlined, size: 18),
                  onPressed: onBookService?.call ?? () {},
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: Paddings.regular),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('Price: ${Helper.formatAmount(service.price ?? 0)} TND', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
          ),
        ),
        leading: Icon(service.category?.icon ?? Icons.error_outline),
      );
    });
  }
}
