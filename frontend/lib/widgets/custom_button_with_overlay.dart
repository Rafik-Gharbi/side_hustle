import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';

class CustomButtonWithOverlay extends StatefulWidget {
  final Widget button;
  final Widget menu;
  final Offset offset;
  final double buttonWidth;
  final void Function()? onCloseOverlay;
  final void Function()? onOpenOverlay;

  const CustomButtonWithOverlay({
    required this.button,
    required this.menu,
    required this.offset,
    super.key,
    this.buttonWidth = 60,
    this.onCloseOverlay,
    this.onOpenOverlay,
  });

  @override
  State<CustomButtonWithOverlay> createState() => _CustomButtonWithOverlayState();
}

class _CustomButtonWithOverlayState extends State<CustomButtonWithOverlay> {
  final LayerLink _layerLink = LayerLink();
  bool showAbove = false;
  Offset buttonPosition = Offset.zero;
  final dropdownHeight = 300.0;
  Size buttonSize = Size.zero;
  Offset currentOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    currentOffset = widget.offset;
    if (Helper.isArabic) currentOffset = Offset(currentOffset.dx + currentOffset.distance - 5, currentOffset.dy);
  }

  void _showDropdown(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Get the position and size of the button
    buttonPosition = renderBox.localToGlobal(Offset.zero);
    buttonSize = renderBox.size;

    // Determine whether dropdown should open above or below based on available space
    final availableSpaceBelow = overlay.size.height - buttonPosition.dy - buttonSize.height;
    final availableSpaceAbove = buttonPosition.dy;

    // Adjust the position of the dropdown based on available space
    showAbove = dropdownHeight > availableSpaceBelow && availableSpaceAbove > availableSpaceBelow;
  }

  void toggleOverlay(BuildContext context) {
    if (Get.isDialogOpen ?? false) {
      Helper.goBack();
      widget.onCloseOverlay?.call();
    } else {
      _showDropdown(context);
      widget.onOpenOverlay?.call();
      if (showAbove) currentOffset = Offset(widget.offset.dx, widget.offset.dy - buttonSize.height);
      Get.dialog(
        barrierColor: Colors.transparent,
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => toggleOverlay(context),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              top: showAbove ? null : 0,
              right: Helper.isArabic ? null : 0,
              left: Helper.isArabic ? 0 : null,
              bottom: showAbove ? 0 : null,
              child: CompositedTransformFollower(
                link: _layerLink,
                followerAnchor: showAbove ? Alignment.bottomLeft : Alignment.topLeft,
                showWhenUnlinked: false,
                offset: currentOffset,
                child: ClipRRect(
                  borderRadius: smallRadius,
                  child: Material(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(Paddings.small),
                      child: widget.menu,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.buttonWidth,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            borderRadius: smallRadius,
            onTap: () => toggleOverlay(context),
            child: widget.button,
          ),
        ),
      );
}
