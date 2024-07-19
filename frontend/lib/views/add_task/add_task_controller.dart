import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/main_app_controller.dart';
import '../../helpers/extensions/date_time_extension.dart';
import '../../models/category.dart';
import '../../models/dto/image_dto.dart';
import '../../models/governorate.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../services/authentication_service.dart';
import '../../services/logger_service.dart';

class AddTaskController extends GetxController {
  final Task? task;
  final formKey = GlobalKey<FormState>();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController delivrablesController = TextEditingController();
  Category? _category = MainAppController.find.categories.firstWhere((element) => element.parentId != -1);
  DateTime createdDate = DateTime.now();
  Governorate? _governorate = AuthenticationService.find.jwtUserData?.governorate;
  RxBool isAdding = false.obs;
  List<XFile>? attachments;

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
    // if (category == null) {
    //   final topFrequentCategories = MainAppController.find.getTopFrequentCategories(take: 1);
    //   category = topFrequentCategories.isNotEmpty ? topFrequentCategories.first : MainAppController.find.activeCategories.first.subcategories.first;
    // }
  }

  bool isImage(String fileName) {
    if (!fileName.contains('.')) return false;
    fileName = fileName.substring(fileName.lastIndexOf('.'));
    return fileName.contains('jpg') || fileName.contains('jpeg') || fileName.contains('png');
  }

  void setCreatedDate({bool next = false, bool previous = false}) {
    if (next) createdDate = createdDate.add(const Duration(days: 1));
    if (previous) createdDate = createdDate.subtract(const Duration(days: 1));
    update();
  }

  void appendCurrency(String value) {
    if (value == '${MainAppController.find.currency.value} ') {
      titleController.text = '';
    } else {
      titleController.text = '${MainAppController.find.currency.value} ${value.replaceAll('${MainAppController.find.currency.value} ', '')}';
    }
    update();
  }

  String resolveDisplayDate() {
    if (createdDate.isSameDate(DateTime.now())) return 'today'.tr;
    if (createdDate.isSameDate(DateTime.now().subtract(const Duration(days: 1)))) return 'yesterday'.tr;
    if (createdDate.isSameDate(DateTime.now().add(const Duration(days: 1)))) return 'tomorrow'.tr;
    return DateFormat.MMMEd().format(createdDate);
  }

  @override
  void onClose() {
    super.onClose();
    _clearFields();
  }

  void _loadTaskData() {
    titleController.text = task!.title;
    descriptionController.text = task!.description;
    priceController.text = task!.price.toString();
    delivrablesController.text = task!.delivrables ?? '';
    governorate = task!.governorate;
    category = task!.category;
    update();
  }

  void _clearFields() {
    titleController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    _category = MainAppController.find.categories.firstWhere((element) => element.parentId != -1);
    createdDate = DateTime.now();
  }

  Future<void> addTask() async {
    if (formKey.currentState?.validate() ?? false) {
      isAdding.value = true;
      final newtask = Task(
        id: task?.id,
        category: category,
        title: titleController.text,
        description: descriptionController.text,
        governorate: governorate,
        delivrables: delivrablesController.text,
        price: double.parse(priceController.text),
        attachments: attachments?.map((e) => ImageDTO(file: e, type: isImage(e.name.toLowerCase()) ? ImageType.image : ImageType.file)).toList(),
        owner: AuthenticationService.find.jwtUserData!,
      );
      await TaskRepository.find.addTask(newtask, withBack: true);
      isAdding.value = false;
    }
  }

  Future<void> uploadAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );
      if (result != null) {
        if (attachments == null) {
          attachments = result.xFiles;
        } else {
          attachments!.addAll(result.xFiles.where((element) => !attachments!.map((e) => e.name).contains(element.name)));
        }
        update();
      }
    } catch (e) {
      LoggerService.logger?.e('Error occured in uploadAttachments:\n$e');
    }
  }

  deleteTask(Task task) {}

  void removeAttachments(XFile xFile) {
    attachments?.remove(xFile);
    update();
  }
}
