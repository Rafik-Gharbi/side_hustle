import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../helpers/helper.dart';
import '../../models/filter_model.dart';
import '../../models/store.dart';
import '../../models/task.dart';
import '../../repositories/store_repository.dart';
import '../../repositories/task_repository.dart';
import '../../services/authentication_service.dart';
import '../../viewmodel/user_viewmodel.dart';

class MapScreenController extends GetxController {
  AnimatedMapController? mapController;
  List<MarkerModel> markers = [];
  List<Task> tasks = [];
  List<Store> stores = [];
  double? zoomLevel;
  LatLng? midPoint;
  bool isInitialized = false;
  FilterModel _filterModel = FilterModel();
  bool _isTasks;
  RxBool isLoading = false.obs;
  LatLng? userCoordinates;

  bool get isTasks => _isTasks;

  set isTasks(bool value) {
    _isTasks = value;
    isLoading.value = true;
    _init().then((_) => isLoading.value = false);
  }

  FilterModel get filterModel => _filterModel;

  set filterModel(FilterModel value) {
    _filterModel = value;
    _init();
  }

  MapScreenController(this._isTasks) {
    _init();
  }

  Future<void> _init() async {
    Map<String, dynamic>? result;
    _filterModel.searchMode = UserViewmodel.searchMode;
    if (isTasks) {
      tasks = await TaskRepository.find.filterTasks(withCoordinates: true, filter: filterModel, limit: -1) ?? [];
      result = _calculateMidPoint(tasks.where((element) => element.coordinates != null).map((e) => e.coordinates!).toList());
      markers = tasks
          .where((element) => element.coordinates != null)
          .map((e) => MarkerModel(coordinates: e.coordinates!, title: e.title, price: e.price ?? 0, isTask: true, task: e))
          .toList();
    } else {
      stores = await StoreRepository.find.filterStores(withCoordinates: true) ?? [];
      result = _calculateMidPoint(stores.where((element) => element.coordinates != null).map((e) => e.coordinates!).toList());
      markers = stores
          .where((element) => element.coordinates != null)
          .map((e) => MarkerModel(coordinates: e.coordinates!, title: e.name ?? 'NA', price: Helper.getStoreCheapestService(e), isTask: false, store: e))
          .toList();
    }
    midPoint = result?['midPoint'];
    zoomLevel = result?['zoomLevel'];
    userCoordinates = AuthenticationService.find.jwtUserData?.coordinates;
    isInitialized = true;
    update();
  }

  Map<String, dynamic>? _calculateMidPoint(List<LatLng> coordinateList) {
    Map<String, dynamic> calculateMidpoint(List<LatLng> coordinates) {
      if (coordinates.isEmpty) return {};
      double minLat = double.infinity;
      double maxLat = double.negativeInfinity;
      double minLng = double.infinity;
      double maxLng = double.negativeInfinity;

      for (LatLng coord in coordinates) {
        minLat = math.min(minLat, coord.latitude);
        maxLat = math.max(maxLat, coord.latitude);
        minLng = math.min(minLng, coord.longitude);
        maxLng = math.max(maxLng, coord.longitude);
      }

      return {
        'midPoint': LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
        'minLat': minLat,
        'maxLat': maxLat,
        'minLng': minLng,
        'maxLng': maxLng,
      };
    }

    double calculateZoomLevel(LatLng midpoint, double minLat, double maxLat, double minLng, double maxLng) {
      double distanceLatitude = math.max(midpoint.latitude - minLat, maxLat - midpoint.latitude);
      double distanceLongitude = math.max(midpoint.longitude - minLng, maxLng - midpoint.longitude);
      double distance = math.max(distanceLongitude, distanceLatitude);
      if (distance == 0 || distance < 0.01) return 14;
      if (distance < 0.1) return 12;
      if (distance < 0.2) return 11;
      if (distance < 0.3) return 10;
      if (distance < 0.4) return 9.5;
      if (distance < 7) return distance / 150 * 120;
      return 4;
    }

    Map<String, dynamic> result = calculateMidpoint(coordinateList);
    if (result.isEmpty) return null;
    LatLng midpoint = result['midPoint'];
    double zoomLevel = calculateZoomLevel(midpoint, result['minLat'], result['maxLat'], result['minLng'], result['maxLng']);
    try {
      mapController!.animateTo(dest: midpoint, zoom: zoomLevel);
    } catch (e) {
      debugPrint('Error moving map camera');
    }
    return {'midPoint': midpoint, 'zoomLevel': zoomLevel};
  }

  Future<void> centerOnUser() async {
    userCoordinates = await Helper.getPosition();
    mapController!.animateTo(dest: userCoordinates!, zoom: 14);
  }
}

class MarkerModel {
  final LatLng coordinates;
  final String title;
  final double price;
  final Task? task;
  final Store? store;
  final bool isTask;

  MarkerModel({this.task, this.store, required this.coordinates, required this.title, required this.price, required this.isTask});
}
