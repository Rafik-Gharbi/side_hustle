import 'package:get/get.dart';

class ReviewController extends GetxController {
  bool _isExpansionTileExpanded = false;

  bool get isExpansionTileExpanded => _isExpansionTileExpanded;

  set isExpansionTileExpanded(bool value) {
    _isExpansionTileExpanded = value;
    update();
  }
}
