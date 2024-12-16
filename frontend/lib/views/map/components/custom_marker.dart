import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/store_card.dart';
import '../map_controller.dart';
import 'task_map_card.dart';

class BuildCustomMarker extends StatefulWidget {
  final MarkerModel? marker;
  final MapController mapController;
  final bool isHighlighted;
  final void Function() onTap;

  const BuildCustomMarker(this.marker, this.mapController, {super.key, this.isHighlighted = false, required this.onTap});

  @override
  State<BuildCustomMarker> createState() => _BuildCustomMarkerState();
}

class _BuildCustomMarkerState extends State<BuildCustomMarker> {
  Future<bool> openMarkerPopup(MarkerModel marker, {bool close = false}) async {
    final bool = widget.mapController.move(marker.coordinates, 14);
    if (!close) {
      Get.bottomSheet(
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: DecoratedBox(
            decoration: const BoxDecoration(color: kNeutralLightColor),
            child: SizedBox(
              height: marker.isTask ? 150 : 200,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Paddings.exceptional, top: Paddings.regular),
                child: marker.isTask
                    ? TaskMapCard(key: Key('task-marker-${marker.task!.id}'), task: marker.task!)
                    : StoreCard(key: Key('store-marker-${marker.store!.id}'), store: marker.store!, isDense: true),
              ),
            ),
          ),
        ),
        isScrollControlled: true,
      );
    } else if (Get.isBottomSheetOpen ?? false) {
      Helper.goBack();
    }
    return bool;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 30,
      child: SizedBox(
        width: 90,
        height: 30,
        child: InkWell(
          onTap: () => openMarkerPopup(widget.marker!),
          child: DecoratedBox(
            decoration: BoxDecoration(color: widget.isHighlighted ? kBlackColor : kNeutralColor100, borderRadius: circularRadius, border: regularBorder),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
              child: Center(
                child: FittedBox(
                  child: GetBuilder<MainAppController>(
                    builder: (mainAppController) => Text(
                      '${Helper.formatAmount(widget.marker?.price ?? 0)} ${mainAppController.currency.value}',
                      style: AppFonts.x14Bold.copyWith(color: widget.isHighlighted ? kNeutralColor100 : kBlackColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
