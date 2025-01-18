import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../widgets/custom_bottomsheet.dart';
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
      CustomBottomsheet(
        height: marker.isTask ? 150 : 200,
        topRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: Paddings.regular).copyWith(bottom: Paddings.exceptional, top: Paddings.regular),
        child: marker.isTask
            ? TaskMapCard(key: Key('task-marker-${marker.task!.id}'), task: marker.task!)
            : StoreCard(key: Key('store-marker-${marker.store!.id}'), store: marker.store!, isDense: true),
      ).showBottomSheet(isScrollControlled: true);
    } else if (Get.isBottomSheetOpen ?? false) {
      Helper.goBack();
    }
    return bool;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: InkWell(
        onTap: () => openMarkerPopup(widget.marker!),
        child: DecoratedBox(
          decoration: BoxDecoration(color: widget.isHighlighted ? kBlackColor : kNeutralColor100, borderRadius: circularRadius, border: regularBorder),
          child: Padding(
            padding: const EdgeInsets.all(Paddings.small),
            child: Center(
              child: GetBuilder<MainAppController>(
                  builder: (mainAppController) => widget.marker!.isTask
                      ? widget.marker!.task?.category != null
                          ? Buildables.buildCategoryIcon(widget.marker!.task!.category!.icon, size: 20)
                          : const Icon(Icons.task_outlined, size: 20)
                      : const Icon(Icons.store_outlined, size: 20)),
            ),
          ),
        ),
      ),
    );
  }
}
