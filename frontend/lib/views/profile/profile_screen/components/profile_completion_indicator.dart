import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../models/user.dart';
import '../../../../services/theme/theme.dart';

class ProfileCompletionIndicator extends StatelessWidget {
  final User user;

  const ProfileCompletionIndicator({super.key, required this.user});

  double get completionPercentage {
    final tasks = [
      user.email != null,
      user.name != null,
      user.phone != null,
      user.gender != null,
      user.birthdate != null,
      user.isMailVerified ?? false,
      user.governorate != null,
    ];
    final completedTasks = tasks.where((task) => task).length;
    return completedTasks / tasks.length;
  }

  List<String> get missingTasks {
    final tasks = {
      'add_email_task'.tr: user.email != null,
      'add_name_task'.tr: user.name != null,
      'add_phone_number_task'.tr: user.phone != null,
      'add_gender_task'.tr: user.gender != null,
      'add_birthdate_task'.tr: user.birthdate != null,
      'verify_email_task'.tr: user.isMailVerified ?? false,
      'select_governorate_task'.tr: user.governorate != null,
    };
    return tasks.entries.where((entry) => !entry.value).map((entry) => entry.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
      child: GestureDetector(
        onTap: () => _showMissingTasksDialog(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
              message: user.isProfileCompleted ? 'profile_completed'.tr : 'complete_profile'.tr,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: completionPercentage,
                      strokeWidth: 4.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completionPercentage == 1.0 ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    '${(completionPercentage * 100).toInt()}%',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMissingTasksDialog(BuildContext context) {
    final missing = missingTasks;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: kNeutralColor100,
        title: Text('profile_completion'.tr, style: AppFonts.x16Bold),
        content: missing.isEmpty
            ? Text('profile_is_completed'.tr, style: AppFonts.x14Regular)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('complete_profile_tasks'.tr, style: AppFonts.x14Regular),
                  const SizedBox(height: 10),
                  ...missing.map((task) => Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.red, size: 20),
                          const SizedBox(width: 5),
                          Text(task, style: AppFonts.x14Regular),
                        ],
                      )),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close'.tr, style: AppFonts.x14Bold),
          ),
        ],
      ),
    );
  }
}
