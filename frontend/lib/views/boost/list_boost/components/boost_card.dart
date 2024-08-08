import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../controllers/main_app_controller.dart';
import '../../../../helpers/helper.dart';
import '../../../../models/boost.dart';
import '../../../../models/service.dart';
import '../../../../models/task.dart';
import '../../../../services/theme/theme.dart';
import '../../../../widgets/service_card.dart';
import '../../../../widgets/task_card.dart';

class BoostCard extends StatelessWidget {
  final Boost boost;
  final bool Function(Boost) isExpanded;
  final void Function(Boost) expand;
  final void Function(Boost) toggleBoostActive;
  final void Function() onEditBoost;
  final Task Function(Boost) getTask;
  final Service Function(Boost) getService;

  const BoostCard({
    super.key,
    required this.boost,
    required this.isExpanded,
    required this.expand,
    required this.getTask,
    required this.getService,
    required this.toggleBoostActive,
    required this.onEditBoost,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: ObjectKey(boost),
      backgroundColor: Colors.transparent,
      trailingActions: [
        SwipeAction(
          performsFirstActionWithFullSwipe: true,
          icon: const Icon(Icons.edit_outlined, color: kNeutralColor100),
          onTap: (handler) => onEditBoost(),
          color: kSelectedColor,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
        child: AnimatedContainer(
          duration: Durations.medium1,
          height: isExpanded(boost) ? 230 : 110,
          child: Column(
            children: [
              ListTile(
                onTap: () => expand(boost),
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Budget ${Helper.formatAmount(boost.budget)} ${MainAppController.find.currency.value}', style: AppFonts.x14Bold),
                        Text(
                          boost.isTask ? 'Task: ${getTask(boost).title}' : 'Service: ${getService(boost).name}',
                          style: AppFonts.x14Regular,
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: boost.isActive,
                        activeColor: kPrimaryColor,
                        inactiveTrackColor: kNeutralOpacityColor,
                        inactiveThumbColor: kNeutralColor,
                        trackOutlineColor: boost.isActive ? null : WidgetStatePropertyAll(kNeutralOpacityColor),
                        onChanged: (_) => toggleBoostActive(boost),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                        children: [
                          WidgetSpan(child: Icon(Icons.location_city_outlined, size: 16, color: kNeutralColor)),
                          TextSpan(text: ' ${boost.governorate != null ? boost.governorate!.name : 'All Tunisia'}'),
                          const TextSpan(text: ' ⦿ '),
                          WidgetSpan(child: Icon(Icons.people_alt_outlined, size: 16, color: kNeutralColor)),
                          TextSpan(text: ' ${boost.minAge != null && boost.maxAge != null ? '${boost.minAge} - ${boost.maxAge}' : '18 - 65+'}'),
                          const TextSpan(text: ' ⦿ '),
                          WidgetSpan(child: Icon(Icons.male_outlined, size: 16, color: kNeutralColor)),
                          TextSpan(text: ' ${boost.gender != null ? boost.gender!.name : 'All genders'}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Paddings.small),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ends in ${Helper.formatDate(boost.endDate)}', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          Icon(isExpanded(boost) ? Icons.expand_less_outlined : Icons.expand_more_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded(boost))
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (boost.isTask) TaskCard(task: getTask(boost)) else ServiceCard(service: getService(boost), isOwner: true),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
