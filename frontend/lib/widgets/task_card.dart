import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/task.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import '../views/task_details/task_details_screen.dart';
import 'custom_buttons.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function()? onRemoveFavorite;

  const TaskCard({super.key, required this.task, this.onRemoveFavorite});

  @override
  Widget build(BuildContext context) => OpenContainer(
        closedElevation: 0,
        transitionDuration: const Duration(milliseconds: 600),
        openBuilder: (_, __) => TaskDetailsScreen(task: task),
        closedBuilder: (_, openContainer) => Padding(
          padding: const EdgeInsets.only(bottom: Paddings.regular),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
            shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
            tileColor: kNeutralLightOpacityColor,
            splashColor: kPrimaryOpacityColor,
            onTap: openContainer,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: AppFonts.x14Bold),
                    if (task.category != null) Text(task.category!.name, style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                  ],
                ),
                StatefulBuilder(builder: (context, setState) {
                  Future<void> toggleFavorite() async {
                    final result = await MainAppController.find.toggleFavoriteTask(task);
                    setState(() => task.isFavorite = result);
                    if (!result) onRemoveFavorite?.call();
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                const SizedBox(height: Paddings.regular),
                if (task.price != null)
                  Align(alignment: Alignment.bottomRight, child: Text('Price: ${Helper.formatAmount(task.price!)} TND', style: AppFonts.x10Regular.copyWith(color: kNeutralColor))),
              ],
            ),
            leading: task.category != null ? Icon(task.category!.icon) : null,
          ),
        ),
      );
}
