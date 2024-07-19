import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/buildables.dart';
import '../networking/api_base_helper.dart';
import '../services/shared_preferences.dart';

class LoadingRequest extends StatelessWidget {
  final bool? isLoading;
  final Widget child;
  const LoadingRequest({super.key, required this.child, this.isLoading});

  @override
  Widget build(BuildContext context) => GetBuilder<ApiBaseHelper>(
        builder: (controller) => (isLoading ?? false) || controller.isLoading || !SharedPreferencesService.find.isReady ? Buildables.buildLoadingWidget() : child,
      );
}
