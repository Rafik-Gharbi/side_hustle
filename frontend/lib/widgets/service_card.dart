import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../models/service.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final void Function() onBookService;
  final void Function()? onDeleteService;
  final void Function()? onEditService;
  final bool isOwner;
  final int requests;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onBookService,
    this.onDeleteService,
    this.onEditService,
    this.isOwner = false,
    this.requests = -1,
  });

  @override
  Widget build(BuildContext context) {
    return isOwner
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
        : buildServiceCard();
  }

  ListTile buildServiceCard() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
      shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
      tileColor: kNeutralLightOpacityColor,
      splashColor: kPrimaryOpacityColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name ?? 'NA', style: AppFonts.x14Bold),
                Text(service.description ?? 'NA', softWrap: true, style: AppFonts.x14Regular),
              ],
            ),
          ),
          Badge(
            isLabelVisible: isOwner,
            offset: Offset(requests > 99 ? -5 : 0, 5),
            label: Text(requests > 99 ? '+99' : requests.toString(), style: AppFonts.x11Bold.copyWith(color: kNeutralColor100)),
            backgroundColor: isOwner ? kErrorColor : Colors.transparent,
            child: CustomButtons.icon(
              icon: Icon(isOwner ? Icons.three_p_outlined : Icons.shopping_cart_outlined, size: 18),
              onPressed: onBookService,
            ),
          ),
        ],
      ),
      subtitle: Align(
        alignment: Alignment.centerRight,
        child: Text('Price: ${Helper.formatAmount(service.price ?? 0)} TND', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
      ),
      leading: Icon(service.category?.icon ?? Icons.error_outline),
    );
  }
}
