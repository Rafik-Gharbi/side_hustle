import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

import '../helpers/helper.dart';

class HoldInSafeArea extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool bottom;
  final Color? backgroundColor;
  const HoldInSafeArea({super.key, required this.child, this.padding, this.bottom = false, this.backgroundColor});

  @override
  Widget build(BuildContext context) => Material(
        color: backgroundColor ?? (Helper.isMobile ? kPrimaryColor : Colors.transparent),
        child: DecoratedBox(
          decoration: BoxDecoration(color: kNeutralColor100),
          child: SafeArea(
            bottom: bottom,
            child: Padding(
              padding: kIsWeb ? EdgeInsets.zero : padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      );
}
