import 'package:get/get.dart';

import '../../../models/store.dart';
import '../../../models/task.dart';
import '../../../repositories/favorite_repository.dart';

class FavoriteController extends GetxController {
  RxBool isLoading = true.obs;
  List<Task> savedTaskList = [];
  List<Store> savedStoreList = [];

  FavoriteController() {
    _init();
  }

  void removeTaskFromList(Task task) {
    savedTaskList.remove(task);
    update();
  }

  void removeStoreFromList(Store store) {
    savedStoreList.remove(store);
    update();
  }

  Future<void> _init() async {
    final result = await FavoriteRepository.find.listFavorite();
    savedTaskList = result?.savedTasks ?? [];
    savedStoreList = result?.savedStores ?? [];
    isLoading.value = false;
    update();
  }
}
