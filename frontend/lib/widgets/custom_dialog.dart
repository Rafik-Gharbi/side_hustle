import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomDialog<T> extends StatelessWidget {
  final bool dismissible;

  const CustomDialog({super.key, this.dismissible = true});

  Future<T?> show() async => await Get.dialog<T>(
        Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (dismissible) {
                  Get.until((route) => route.isCurrent);
                  Get.back<bool>(result: false);
                }
              },
              child: GestureDetector(onTap: () {}, child: this),
            ),
            backgroundColor: Colors.transparent),
      );
}
