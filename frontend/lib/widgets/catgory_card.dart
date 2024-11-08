import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/buildables.dart';
import '../models/category.dart';
import '../models/filter_model.dart';
import '../services/theme/theme.dart';
import '../views/task/task_list/task_list_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    double size = (Get.width - 60) / 4;
    return ClipRRect(
      borderRadius: smallRadius,
      child: InkWell(
        splashColor: kPrimaryColor.withOpacity(0.5),
        onTap: () => Get.toNamed(TaskListScreen.routeName, arguments: TaskListScreen(filterModel: FilterModel(category: category))),
        child: DecoratedBox(
          decoration: BoxDecoration(borderRadius: smallRadius, color: kNeutralLightColor.withOpacity(0.6)),
          child: SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Buildables.buildCategoryIcon(category.icon, size: 40),
                  const SizedBox(height: Paddings.small),
                  Text(
                    category.name,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: category.name.length > 10 ? AppFonts.x10Bold : AppFonts.x11Bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
