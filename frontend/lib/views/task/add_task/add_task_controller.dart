import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/shared_preferences_keys.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/category.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/governorate.dart';
import '../../../models/task.dart';
import '../../../repositories/task_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/tutorials/add_task_tutorial.dart';

class AddTaskController extends GetxController {
  /// Not permanent, use with caution!
  static AddTaskController get find => Get.find<AddTaskController>();
  final scrollController = ScrollController();
  final Task? task;
  final formKey = GlobalKey<FormState>();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceMaxController = TextEditingController();
  final TextEditingController delivrablesController = TextEditingController();
  Category? _category = MainAppController.find.categories.firstWhere((element) => element.parentId != -1);
  DateTime _createdDate = DateTime.now();
  LatLng? _coordinates;
  Governorate? _governorate = AuthenticationService.find.jwtUserData?.governorate;
  RxBool isAdding = false.obs;
  List<XFile>? attachments;
  bool _isPriceRange = false;
  List<TargetFocus> targets = [];
  GlobalKey titleFieldKey = GlobalKey();
  GlobalKey categoryKey = GlobalKey();
  GlobalKey dueDateKey = GlobalKey();
  GlobalKey priceKey = GlobalKey();
  GlobalKey locationKey = GlobalKey();


  DateTime get createdDate => _createdDate;

  LatLng? get coordinates => _coordinates;

  bool get isPriceRange => _isPriceRange;

  set isPriceRange(bool value) {
    _isPriceRange = value;
    update();
  }

  set coordinates(LatLng? value) {
    _coordinates = value;
    update();
  }

  set createdDate(DateTime value) {
    _createdDate = value;
    update();
  }

  Governorate? get governorate => _governorate;

  Category? get category => _category;

  set category(Category? value) {
    _category = value;
    update();
  }

  set governorate(Governorate? value) {
    _governorate = value;
    update();
  }

  AddTaskController({this.task}) {
    if (task != null) _loadTaskData();
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value, () {
      if (!(SharedPreferencesService.find.get(hasFinishedAddTaskTutorialKey) == 'true')) {
        Helper.waitAndExecute(() => Get.isBottomSheetOpen == true && Get.isRegistered<AddTaskController>(), () {
          AddTaskTutorial.showTutorial();
          update();
        });
      }
    });
  }

  void setCreatedDate({bool next = false, bool previous = false}) {
    if (next && createdDate.isBefore(DateTime.now().add(const Duration(days: 29)))) createdDate = createdDate.add(const Duration(days: 1));
    if (previous && createdDate.isAfter(DateTime.now())) createdDate = createdDate.subtract(const Duration(days: 1));
  }

  void appendCurrency(String value) {
    if (value == '${MainAppController.find.currency.value} ') {
      titleController.text = '';
    } else {
      titleController.text = '${MainAppController.find.currency.value} ${value.replaceAll('${MainAppController.find.currency.value} ', '')}';
    }
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _clearFields();
  }

  void _loadTaskData() {
    titleController.text = task!.title;
    descriptionController.text = task!.description;
    priceController.text = task!.price?.toString() ?? '';
    priceMaxController.text = task!.priceMax?.toString() ?? '';
    delivrablesController.text = task!.delivrables ?? '';
    _governorate = task!.governorate;
    _category = task!.category;
    _coordinates = task!.coordinates;
    update();
  }

  void _clearFields() {
    titleController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    priceMaxController.text = '';
    _category = MainAppController.find.categories.firstWhere((element) => element.parentId != -1);
    _createdDate = DateTime.now();
  }

  Future<void> upsertTask() async {
    if (formKey.currentState?.validate() ?? false) {
      isAdding.value = true;
      final newtask = Task(
        id: task?.id,
        category: category,
        title: titleController.text,
        description: descriptionController.text,
        governorate: governorate,
        delivrables: delivrablesController.text,
        price: double.tryParse(priceController.text),
        priceMax: double.tryParse(priceMaxController.text),
        attachments: attachments?.map((e) => ImageDTO(file: e, type: Helper.isImage(e.name.toLowerCase()) ? ImageType.image : ImageType.file)).toList(),
        owner: AuthenticationService.find.jwtUserData!,
        coordinates: coordinates,
        dueDate: _createdDate,
      );
      if (task?.id == null) {
        if (newtask.price != null && newtask.price! > 0) {
          Helper.openConfirmationDialog(
            content: 'creating_task_coins_msg'.trParams({
              'coins': (Helper.calculateTaskCoinsPrice(newtask.price!)).toString(),
              'baseCoins': (AuthenticationService.find.jwtUserData?.totalCoins ?? 0).toString(),
            }),
            onConfirm: () async {
              if (Helper.calculateTaskCoinsPrice(newtask.price!) < (AuthenticationService.find.jwtUserData?.totalCoins ?? 0)) {
                await TaskRepository.find.addTask(newtask, withBack: true);
              } else {
                Helper.snackBar(message: 'insufficient_base_coins'.tr);
              }
            },
          );
        } else {
          await TaskRepository.find.addTask(newtask, withBack: true);
          FirebaseAnalytics.instance.logEvent(
            name: 'create_task',
            parameters: {
              'category': newtask.category?.name ?? 'undefined',
              'price': newtask.price ?? 0,
            },
          );
        }
      } else {
        if (newtask.price != null && newtask.price! > 0 && newtask.price! > (task!.price ?? 0)) {
          Helper.openConfirmationDialog(
            content: 'update_task_coins_msg'.trParams({
              'coins': (Helper.calculateTaskCoinsPrice(newtask.price!) - task!.deductedCoins).toString(),
              'baseCoins': (AuthenticationService.find.jwtUserData?.totalCoins ?? 0).toString(),
            }),
            onConfirm: () async {
              if ((Helper.calculateTaskCoinsPrice(newtask.price!) - task!.deductedCoins) < (AuthenticationService.find.jwtUserData?.totalCoins ?? 0)) {
                await TaskRepository.find.updateTask(newtask, withBack: true);
              } else {
                Helper.snackBar(message: 'insufficient_base_coins'.tr);
              }
            },
          );
        } else {
          await TaskRepository.find.updateTask(newtask, withBack: true);
        }
      }
      isAdding.value = false;
    }
  }

  Future<void> uploadAttachments() async {
    final files = await Helper.pickFiles();
    if (files != null) {
      if (attachments == null) {
        attachments = files;
      } else {
        attachments!.addAll(files.where((element) => !attachments!.map((e) => e.name).contains(element.name)));
      }
      update();
    }
  }

  void deleteTask(Task task) => Helper.openConfirmationDialog(
        content: 'delete_task_msg'.trParams({'taskTitle': task.title}),
        onConfirm: () async => await TaskRepository.find.deleteTask(task, withBack: true),
      );

  void removeAttachments(XFile xFile) {
    attachments?.remove(xFile);
    update();
  }
}
