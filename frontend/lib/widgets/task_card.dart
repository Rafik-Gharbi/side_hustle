import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../database/database_repository/task_database_repository.dart';
import '../helpers/buildables.dart';
import '../helpers/helper.dart';
import '../models/task.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import '../views/profile/account/login_dialog.dart';
import '../views/task/task_details/task_details_screen.dart';
import 'custom_buttons.dart';
import 'overflowed_text_with_tooltip.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function()? onRemoveFavorite;
  final void Function()? onDeleteTask;
  final void Function()? onEditTask;
  final void Function()? onOpenProposals;
  final int condidates;
  final bool dense;
  final bool isHighlighted;
  final Color? backgroundColor;

  const TaskCard({
    super.key,
    required this.task,
    this.onRemoveFavorite,
    this.onDeleteTask,
    this.onEditTask,
    this.onOpenProposals,
    this.condidates = 0,
    this.dense = false,
    this.backgroundColor,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) => OpenContainer(
        closedElevation: 0,
        closedColor: kNeutralColor100,
        transitionDuration: const Duration(milliseconds: 600),
        openBuilder: (_, __) => TaskDetailsScreen(task: task),
        closedBuilder: (_, openContainer) => AuthenticationService.find.jwtUserData?.id != null && AuthenticationService.find.jwtUserData?.id == task.owner.id
            ? SwipeActionCell(
                key: ObjectKey(task),
                backgroundColor: Colors.transparent,
                trailingActions: [
                  SwipeAction(
                    performsFirstActionWithFullSwipe: true,
                    icon: Icon(Icons.delete_forever_rounded, color: kNeutralColor100),
                    onTap: (handler) => onDeleteTask?.call(),
                    color: kErrorColor,
                  ),
                  SwipeAction(
                    performsFirstActionWithFullSwipe: true,
                    icon: Icon(Icons.edit_outlined, color: kNeutralColor100),
                    onTap: (handler) => onEditTask?.call(),
                    color: kSelectedColor,
                  ),
                ],
                child: buildTaskCard(openContainer, context),
              )
            : buildTaskCard(openContainer, context),
      );

  Widget buildTaskCard(VoidCallback openContainer, BuildContext context) {
    bool highlightTile = false;
    bool isInitialized = false;
    return StatefulBuilder(builder: (_, setState) {
      if (context.mounted && !isInitialized && highlightTile != isHighlighted) {
        Future.delayed(const Duration(milliseconds: 600), () => context.mounted ? setState(() => highlightTile = isHighlighted) : null);
      }
      isInitialized = true;
      return Padding(
        padding: EdgeInsets.only(bottom: dense ? 0 : Paddings.regular),
        child: DecoratedBox(
          decoration: BoxDecoration(color: highlightTile ? kPrimaryOpacityColor : backgroundColor ?? kNeutralLightColor, borderRadius: smallRadius),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
            tileColor: backgroundColor ?? kNeutralLightColor,
            shape: dense
                ? OutlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor))
                : RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
            splashColor: kPrimaryOpacityColor,
            onTap: openContainer,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: Get.width - (dense ? 180 : 160), child: OverflowedTextWithTooltip(title: task.title, style: AppFonts.x14Bold, expand: false)),
                      if (task.category != null && !dense) Text(task.category!.name, style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                    ],
                  ),
                ),
                // Bookmark task
                if (task.owner.id != AuthenticationService.find.jwtUserData?.id && !dense)
                  StatefulBuilder(builder: (context, setState) {
                    Future<void> toggleFavorite() async {
                      final result = await MainAppController.find.toggleFavoriteTask(task);
                      setState(() => task.isFavorite = result);
                      if (!result) onRemoveFavorite?.call();
                      TaskDatabaseRepository.find.backupTask(task, isFavorite: true);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(left: Paddings.regular),
                      child: CustomButtons.icon(
                        icon: Icon(task.isFavorite ? Icons.bookmark_outlined : Icons.bookmark_add_outlined, size: 18),
                        onPressed: () => AuthenticationService.find.isUserLoggedIn.value
                            ? toggleFavorite()
                            : Helper.snackBar(
                                message: 'login_save_task_msg'.tr,
                                overrideButton: TextButton(
                                  onPressed: () => Get.bottomSheet(const LoginDialog(), isScrollControlled: true).then((value) {
                                    AuthenticationService.find.currentState = LoginWidgetState.login;
                                    AuthenticationService.find.clearFormFields();
                                  }),
                                  child: Text('login'.tr),
                                ),
                              ),
                      ),
                    );
                  })
                else if (AuthenticationService.find.isUserLoggedIn.value && task.owner.id == AuthenticationService.find.jwtUserData?.id && !dense)
                  Column(
                    children: [
                      Badge(
                        offset: Offset(condidates > 99 ? -5 : 0, 5),
                        label: condidates == -1
                            ? Icon(Icons.done_outlined, size: 16, color: kNeutralColor100)
                            : Text(condidates > 99 ? '+99' : condidates.toString(), style: AppFonts.x11Bold.copyWith(color: kNeutralColor100)),
                        backgroundColor: condidates == -1 ? kConfirmedColor : kErrorColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Paddings.regular),
                          child: CustomButtons.icon(
                            icon: const Icon(Icons.three_p_outlined, size: 24),
                            onPressed: () => condidates > 0 || condidates == -1 ? onOpenProposals?.call() : Helper.snackBar(message: 'no_proposals_submitted'.tr),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.x12Regular),
                const SizedBox(height: Paddings.regular),
                if (task.price != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (task.distance != null && task.distance!.isNotEmpty)
                        Text('${'distance'.tr}: ${Helper.formatAmount(double.parse(task.distance!))} ${'kilometers'.tr}', style: AppFonts.x10Regular.copyWith(color: kNeutralColor))
                      else
                        const SizedBox(),
                      Text(
                        '${'price'.tr}: ${Helper.formatAmount(task.price!)} ${task.priceMax != null ? '- ${Helper.formatAmount(task.priceMax!)} ' : ''}${MainAppController.find.currency.value}',
                        style: AppFonts.x12Bold.copyWith(color: kNeutralColor),
                      ),
                    ],
                  ),
              ],
            ),
            leading: task.category != null ? Buildables.buildCategoryIcon(task.category!.icon) : null,
          ),
        ),
      );
    });
  }
}
