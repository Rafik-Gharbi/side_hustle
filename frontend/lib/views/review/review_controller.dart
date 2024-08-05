import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final ExpansionTileController ratingExpansionController = ExpansionTileController();
  bool _isExpansionTileExpanded = false;

  bool get isExpansionTileExpanded => _isExpansionTileExpanded;

  set isExpansionTileExpanded(bool value) {
    _isExpansionTileExpanded = value;
    update();
  }
}
