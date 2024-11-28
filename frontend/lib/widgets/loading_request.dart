import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/buildables.dart';
import '../networking/api_base_helper.dart';
import '../services/shared_preferences.dart';

class LoadingRequest extends StatelessWidget {
  final RxBool? isLoading;
  final Widget child;
  const LoadingRequest({super.key, required this.child, this.isLoading});

  bool get resolveLoading => (isLoading?.value ?? false) || ApiBaseHelper.find.isLoading || !SharedPreferencesService.find.isReady.value;

  @override
  Widget build(BuildContext context) => Obx(() => resolveLoading ? Buildables.buildLoadingWidget() : child);
}
