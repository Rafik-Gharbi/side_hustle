import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
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
                  onSelect.call(governorate);
                  Helper.goBack();
                },
                child: OnHover(
                  builder: (isHovered) {
                    final isSelected = selectedItem != null && selectedItem!.name == governorate.name;
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: smallRadius,
                        color: isHovered
                            ? kNeutralLightColor.withAlpha(150)
                            : isSelected
                                ? kPrimaryColor
                                : null,
                      ),
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            governorate.name,
                            style: AppFonts.x14Regular.copyWith(color: isSelected ? kNeutralColor100 : kBlackColor, fontWeight: isSelected ? FontWeight.bold : null),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
