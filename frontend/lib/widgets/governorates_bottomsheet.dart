import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../models/governorate.dart';
import '../services/theme/theme.dart';
import 'on_hover.dart';

class GovernorateBottomsheet extends StatelessWidget {
  final Governorate? selectedItem;
  final void Function(Governorate) onSelect;

  const GovernorateBottomsheet({super.key, required this.selectedItem, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: regularRadius,
      color: kNeutralColor100,
      child: Padding(
        padding: const EdgeInsets.all(Paddings.exceptional),
        child: ListView.builder(
          itemCount: MainAppController.find.governorates.length,
          itemBuilder: (context, index) {
            final governorate = MainAppController.find.governorates[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: Paddings.small),
              child: InkWell(
                onTap: () {
                  onSelect.call( governorate);
                  Get.back();
                },
                child: OnHover(
                  builder: (isHovered) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: smallRadius,
                      color: isHovered
                          ? kNeutralLightColor.withAlpha(150)
                          : selectedItem != null && selectedItem!.name == governorate.name
                              ? kPrimaryColor
                              : null,
                    ),
                    child: SizedBox(
                      height: 40,
                      child: Center(child: Text(governorate.name, style: AppFonts.x14Regular)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
