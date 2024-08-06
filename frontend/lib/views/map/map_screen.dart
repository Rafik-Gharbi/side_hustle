import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../models/filter_model.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/hold_in_safe_area.dart';
import '../task/task_filter/more_filters_popup.dart';
import 'components/custom_marker.dart';
import 'map_controller.dart';

class MapScreen extends StatelessWidget {
  final bool isTasks;
  const MapScreen({super.key, this.isTasks = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      init: MapScreenController(isTasks),
      builder: (controller) => HoldInSafeArea(
        child: !controller.isInitialized
            ? Buildables.buildLoadingWidget()
            : Column(
                children: [
                  const SizedBox(height: Paddings.exceptional * 2),
                  DecoratedBox(
                    decoration: const BoxDecoration(color: kNeutralColor100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: Get.back),
                          Text('map'.tr, style: AppFonts.x15Bold),
                          Row(
                            children: [
                              CustomButtons.icon(
                                icon: Icon(controller.isTasks ? Icons.task_outlined : Icons.store_outlined),
                                onPressed: () => controller.isTasks = !controller.isTasks,
                              ),
                              CustomButtons.icon(
                                icon: const Icon(Icons.filter_alt_outlined),
                                onPressed: () => Get.dialog(
                                  MoreFiltersPopup(
                                    updateFilter: (filter) => controller.filterModel = filter,
                                    clearFilter: () => controller.filterModel = FilterModel(),
                                    filter: controller.filterModel,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        initialCenter: controller.midPoint ?? defaultLocation,
                        initialZoom: controller.zoomLevel ?? 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                          tileProvider: CancellableNetworkTileProvider(),
                        ),
                        MarkerLayer(
                          markers: List.generate(
                            controller.markers.length,
                            (index) {
                              final marker = controller.markers.toList()[index];
                              return Marker(
                                point: marker.coordinates,
                                alignment: Alignment.center,
                                width: 90,
                                height: 30,
                                child: BuildCustomMarker(marker, controller.mapController, onTap: () {}),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
