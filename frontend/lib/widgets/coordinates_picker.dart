import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../overrided_dependencies/flutter_location_picker/classes.dart';
import '../../overrided_dependencies/flutter_location_picker/location_picker.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/form_validators.dart';
import '../helpers/helper.dart';
import '../services/theme/theme.dart';
import 'custom_text_field.dart';

class CoordinatesPicker extends StatefulWidget {
  final TextEditingController? longitudeController;
  final TextEditingController? latitudeController;
  final Function(LatLng)? onSubmit;
  final Function(bool)? keepPrivacy;
  final bool withPicker;
  final bool? currentKeepPrivacy;
  final LatLng? currentPosition;
  final bool isRequired;

  const CoordinatesPicker({
    super.key,
    this.longitudeController,
    this.latitudeController,
    this.onSubmit,
    this.withPicker = true,
    this.isRequired = true,
    this.keepPrivacy,
    this.currentPosition,
    this.currentKeepPrivacy,
  });

  @override
  State<CoordinatesPicker> createState() => _CoordinatesPickerState();
}

class _CoordinatesPickerState extends State<CoordinatesPicker> {
  late TextEditingController longitudeController;
  late TextEditingController latitudeController;
  LatLng? selectedLocation;
  double? latitude;
  double? longitude;
  bool keepPrivacy = false;
  RxBool isLoadingPosition = false.obs;

  @override
  void initState() {
    super.initState();
    keepPrivacy = widget.currentKeepPrivacy ?? false;
    longitudeController = widget.longitudeController ?? TextEditingController(text: widget.currentPosition?.longitude.toString() ?? '');
    latitudeController = widget.latitudeController ?? TextEditingController(text: widget.currentPosition?.latitude.toString() ?? '');
  }

  void _showLocationPicker() => Get.dialog(
        Material(
          child: FlutterLocationPicker(
            initZoom: 11,
            initPosition: const LatLong(34.740556, 10.762222), // Sfax coordinates
            minZoomLevel: 5,
            maxZoomLevel: 16,
            zoomButtonsColor: kNeutralLightColor,
            locationButtonsColor: kNeutralLightColor,
            searchBarBackgroundColor: kNeutralLightColor,
            locationButtonBackgroundColor: kPrimaryColor,
            zoomButtonsBackgroundColor: kPrimaryColor,
            showSearchBar: false,
            selectedLocationButtonTextstyle: AppFonts.x15Bold.copyWith(color: kNeutralColor100),
            selectLocationButtonStyle: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
            //trackMyPosition: true,
            onPicked: (pickedData) {
              longitudeController.text = pickedData.latLong.longitude.toString();
              latitudeController.text = pickedData.latLong.latitude.toString();
              widget.onSubmit?.call(LatLng(pickedData.latLong.latitude, pickedData.latLong.longitude));
              Helper.goBack();
            },
          ),
        ),
      );

  Future<void> _getUserPosition() async {
    isLoadingPosition.value = true;
    final coordinates = await Helper.getPosition();
    if (coordinates == null) return;
    longitudeController.text = coordinates.longitude.toString();
    latitudeController.text = coordinates.latitude.toString();
    widget.onSubmit?.call(coordinates);
    isLoadingPosition.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              CustomTextField(
                width: (Get.width - 50) / 2,
                fieldController: longitudeController,
                hintText: 'longitude'.tr,
                suffixIcon: isLoadingPosition.value
                    ? Transform.scale(scale: 0.4, child: const CircularProgressIndicator())
                    : const Icon(
                        Icons.my_location_outlined,
                        size: 18,
                      ),
                readOnly: true,
                onTap: widget.withPicker ? _showLocationPicker : _getUserPosition,
                validator: widget.isRequired ? FormValidators.notEmptyOrNullValidator : null,
              ),
              const SizedBox(width: Paddings.regular),
              CustomTextField(
                width: (Get.width - 50) / 2,
                fieldController: latitudeController,
                hintText: 'latitude'.tr,
                suffixIcon: isLoadingPosition.value
                    ? Transform.scale(scale: 0.4, child: const CircularProgressIndicator())
                    : const Icon(
                        Icons.my_location_outlined,
                        size: 18,
                      ),
                readOnly: true,
                onTap: widget.withPicker ? _showLocationPicker : _getUserPosition,
                validator: widget.isRequired ? FormValidators.notEmptyOrNullValidator : null,
              ),
            ],
          ),
        ),
        if (widget.keepPrivacy != null)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
            minVerticalPadding: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('keep_location_privacy'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                    const SizedBox(width: Paddings.small),
                    Tooltip(message: 'keep_location_privacy_msg'.tr, child: Icon(Icons.info_outline, size: 14, color: kNeutralColor)),
                  ],
                ),
                Transform.scale(
                  scale: 0.5,
                  child: Switch(
                    value: keepPrivacy,
                    activeColor: kPrimaryColor,
                    inactiveTrackColor: kNeutralLightColor,
                    inactiveThumbColor: kNeutralOpacityColor,
                    trackOutlineColor: keepPrivacy ? null : WidgetStatePropertyAll(kNeutralOpacityColor),
                    onChanged: (_) => setState(() {
                      keepPrivacy = !keepPrivacy;
                      widget.keepPrivacy?.call(keepPrivacy);
                    }),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
