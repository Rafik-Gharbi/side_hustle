import 'package:get/get.dart';

import '../../models/task.dart';
import '../../repositories/favorite_repository.dart';

class FavoriteController extends GetxController {
  bool isLoading = true;
  List<Task> savedTaskList = [];

  FavoriteController() {
    _init();
  }

  void removeTaskFromList(Task task) {
    savedTaskList.remove(task);
    update();
  }

  Future<void> _init() async {
    savedTaskList = await FavoriteRepository.find.listFavorite();
    isLoading = false;
    update();
  }
}
