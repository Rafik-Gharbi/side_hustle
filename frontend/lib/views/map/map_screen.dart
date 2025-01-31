import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/buildables.dart';
import '../../helpers/helper.dart';
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
            : Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: kNeutralColor100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButtons.icon(icon: const Icon(Icons.close_outlined), onPressed: () => Helper.goBack()),
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
                                        isTasks: controller.isTasks,
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
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter: controller.midPoint ?? defaultLocation,
                                initialZoom: controller.zoomLevel ?? 13,
                                interactionOptions: const InteractionOptions(flags: InteractiveFlag.doubleTapZoom | InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                                  tileProvider: CancellableNetworkTileProvider(),
                                ),
                                MarkerLayer(
                                  markers: [
                                    ...List.generate(
                                      controller.markers.length,
                                      (index) {
                                        final marker = controller.markers.toList()[index];
                                        return Marker(
                                          point: marker.coordinates,
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: BuildCustomMarker(marker, controller.mapController, onTap: () {}),
                                        );
                                      },
                                    ),
                                    if (controller.userCoordinates != null)
                                      Marker(
                                        width: 16,
                                        height: 16,
                                        point: controller.userCoordinates!,
                                        child: const Stack(
                                          children: [
                                            Center(child: CircleAvatar(foregroundColor: Colors.blue, radius: 8)),
                                            Center(child: CircleAvatar(backgroundColor: Colors.white, radius: 7.5)),
                                            Center(child: CircleAvatar(foregroundColor: Colors.blue, radius: 6)),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 50,
                              right: 20,
                              child: Column(
                                children: [
                                  FloatingActionButton(
                                    heroTag: 'zoomIn',
                                    backgroundColor: kPrimaryColor,
                                    onPressed: () => controller.mapController.move(controller.mapController.camera.center, controller.mapController.camera.zoom + 1),
                                    child: const Icon(Icons.zoom_in, color: kNeutralColor100),
                                  ),
                                  const SizedBox(height: 10),
                                  FloatingActionButton(
                                    heroTag: 'zoomOut',
                                    onPressed: () => controller.mapController.move(controller.mapController.camera.center, controller.mapController.camera.zoom - 1),
                                    child: const Icon(Icons.zoom_out, color: kNeutralColor100),
                                  ),
                                  const SizedBox(height: 10),
                                  FloatingActionButton(
                                    heroTag: 'centerOnUser',
                                    onPressed: () => controller.centerOnUser(),
                                    child: Icon(controller.userCoordinates == null ? Icons.location_searching_outlined : Icons.my_location, color: kNeutralColor100),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? Positioned.fill(
                            child: InkWell(
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: kNeutralColor.withOpacity(0.2)),
                                child: Center(child: lottie.Lottie.asset(Assets.fetchingData, width: 100)),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
      ),
    );
  }
}
