import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/boost.dart';
import '../../../models/governorate.dart';
import '../../../models/user.dart';
import '../../../repositories/boost_repository.dart';
import '../../../repositories/params_repository.dart';

class AddBoostController extends GetxController {
  Boost? boost;
  String? taskId;
  String? serviceId;
  RxDouble budgetRange = 10.0.obs;
  Governorate? _governorate;
  int? _minAge;
  int? _maxAge;
  Gender? _gender;
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  int _maxUsers = 1000;
  RxBool isLoading = false.obs;

  int? get minAge => _minAge;

  int? get maxAge => _maxAge;

  Gender? get gender => _gender;

  Governorate? get governorate => _governorate;

  DateTime get endDate => _endDate;

  set endDate(DateTime value) {
    _endDate = value;
    update();
  }

  set governorate(Governorate? value) {
    _governorate = value;
    update();
  }

  set gender(Gender? value) {
    _gender = value;
    update();
  }

  set maxAge(int? value) {
    _maxAge = value;
    update();
  }

  set minAge(int? value) {
    _minAge = value;
    update();
  }

  AddBoostController({this.boost, this.taskId, this.serviceId}) {
    assert(taskId != null || serviceId != null || boost?.taskServiceId != null, 'taskId or serviceId is required');
    if (boost != null) {
      if (boost!.isTask) {
        taskId = boost!.taskServiceId;
      } else {
        serviceId = boost!.taskServiceId;
      }
    }
    _getMaxUsersReach();
    if (boost != null) _loadFieldsData();
  }

  Future<void> upsertBoost() async {
    isLoading.value = true;
    final newBoost = Boost(
      id: boost?.id,
      budget: budgetRange.value.toInt().toDouble(),
      endDate: endDate,
      gender: gender,
      governorate: governorate,
      maxAge: maxAge,
      minAge: minAge,
      taskServiceId: taskId ?? serviceId!,
      isTask: taskId != null,
    );
    Get.bottomSheet(
      isScrollControlled: true,
      Buildables.buildPaymentOptionsBottomsheet(
        totalPrice: newBoost.budget,
        taskId: taskId,
        serviceId: serviceId,
        onSuccessPayment: () async {
          bool? result;
          if (boost?.id != null) {
            result = await BoostRepository.find.updateBoost(boost: newBoost);
          } else {
            result = await BoostRepository.find.addBoost(boost: newBoost, taskServiceId: taskId ?? serviceId!, isTask: taskId != null);
          }
          if (result) {
            // Helper.goBack();
            Helper.snackBar(message: 'boost_status_successfully'.trParams({'status': boost?.id != null ? 'updated' : 'added'}));
          }
        },
      ),
    ).then((_) => isLoading.value = false);
  }

  void manageAgeAudience({required RangeValues range}) {
    _minAge = range.start.toInt();
    _maxAge = range.end.toInt();
    update();
  }

  void _loadFieldsData() {
    budgetRange.value = boost!.budget;
    endDate = boost!.endDate;
    gender = boost!.gender;
    governorate = boost!.governorate;
    maxAge = boost!.maxAge;
    minAge = boost!.minAge;
    update();
  }

  int getEstimationReachMin() => _maxUsers / 10 * budgetRange.value.toInt() ~/ 100;

  int getEstimationReachMax() => _maxUsers * budgetRange.value.toInt() ~/ 100;

  void _getMaxUsersReach() {
    _maxUsers = ParamsRepository.find.getMaxActiveUsers();
  }
}
