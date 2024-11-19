import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/buildables.dart';
import '../networking/api_base_helper.dart';
import '../services/shared_preferences.dart';

class LoadingRequest extends StatefulWidget {
  final bool? isLoading;
  final Widget child;
  const LoadingRequest({super.key, required this.child, this.isLoading});

  @override
  State<LoadingRequest> createState() => _LoadingRequestState();
}

class _LoadingRequestState extends State<LoadingRequest> {
  RxBool loading = true.obs;

  @override
  void initState() {
    super.initState();
    loading.value = (widget.isLoading ?? false) || ApiBaseHelper.find.isLoading || !SharedPreferencesService.find.isReady;
  }

  @override
  void didUpdateWidget(LoadingRequest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) loading.value = (widget.isLoading ?? false) || ApiBaseHelper.find.isLoading || !SharedPreferencesService.find.isReady;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loading.value = (widget.isLoading ?? false) || ApiBaseHelper.find.isLoading || !SharedPreferencesService.find.isReady;
  }

  @override
  Widget build(BuildContext context) => Obx(() => loading.value ? Buildables.buildLoadingWidget() : widget.child);
}
