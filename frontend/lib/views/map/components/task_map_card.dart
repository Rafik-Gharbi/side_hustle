import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../models/task.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/overflowed_text_with_tooltip.dart';
import '../../task/task_details/task_details_screen.dart';

class TaskMapCard extends StatelessWidget {
  final Task task;
  const TaskMapCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (_, __) => TaskDetailsScreen(task: task),
      closedBuilder: (_, openContainer) => DecoratedBox(
        decoration: BoxDecoration(color: kNeutralLightColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Leading category icon
              if (task.category != null) SizedBox(width: 50, child: Icon(task.category!.icon)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: Get.width - 160, child: OverflowedTextWithTooltip(title: task.title, style: AppFonts.x14Bold, expand: false)),
                            if (task.category != null) Text(task.category!.name, style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                          ],
                        ),
                        // Bookmark task
                        if (task.owner.id != AuthenticationService.find.jwtUserData?.id)
                          StatefulBuilder(builder: (context, setState) {
                            Future<void> toggleFavorite() async {
                              final result = await MainAppController.find.toggleFavoriteTask(task);
                              setState(() => task.isFavorite = result);
                              // if (!result) onRemoveFavorite?.call();
                              // TaskDatabaseRepository.find.backupTask(task, isFavorite: true);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(left: Paddings.regular),
                              child: CustomButtons.icon(
                                icon: Icon(task.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined, size: 18),
                                onPressed: () => AuthenticationService.find.isUserLoggedIn.value ? toggleFavorite() : Helper.snackBar(message: 'login_save_task_msg'.tr),
                              ),
                            );
                          }),
                      ],
                    ),
                    Text(task.description, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                    const SizedBox(height: Paddings.regular),
                    if (task.price != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (task.distance != null && task.distance!.isNotEmpty)
                            Text('Distance: ${task.distance} meters', style: AppFonts.x10Regular.copyWith(color: kNeutralColor))
                          else
                            const SizedBox(),
                          Text('Price: ${Helper.formatAmount(task.price!)} TND', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
