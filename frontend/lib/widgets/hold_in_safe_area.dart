import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

import '../helpers/helper.dart';

class HoldInSafeArea extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool bottom;
  const HoldInSafeArea({super.key, required this.child, this.padding, this.bottom = false});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Material(
          color: Helper.isMobile ? kPrimaryColor : Colors.transparent,
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
