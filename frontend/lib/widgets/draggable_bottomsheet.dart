import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import '../constants/colors.dart';

class DraggableBottomsheet extends StatelessWidget {
  final Widget child;
  final double dragHandlerPadding;
  final double? overrideMaxHeight;
  final double? overrideMinHeight;

  const DraggableBottomsheet({super.key, required this.child, this.dragHandlerPadding = 40, this.overrideMaxHeight, this.overrideMinHeight});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: SolidBottomSheet(
          maxHeight: overrideMaxHeight ?? Get.height * 0.90,
          minHeight: overrideMinHeight ?? Get.height * 0.5,
          draggableBody: true,
          headerBar: Material(
            color: kNeutralColor100,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: SizedBox(
              height: dragHandlerPadding,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: kNeutralColor, borderRadius: BorderRadius.circular(10)),
                  child: const SizedBox(width: 60, height: 5),
                ),
              ),
            ),
          ),
          body: child,
        ),
      );
}
