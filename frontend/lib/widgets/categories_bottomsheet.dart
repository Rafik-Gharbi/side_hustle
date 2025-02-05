import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../constants/colors.dart';
import '../constants/shared_preferences_keys.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/buildables.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../services/shared_preferences.dart';
import '../services/theme/theme.dart';
import '../services/theme/theme_service.dart';
import '../services/tutorials/categories_tutorial.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';
import 'loading_card_effect.dart';
import 'main_screen_with_bottom_navigation.dart';

class CategoriesBottomsheet extends StatefulWidget {
  final void Function(List<Category> category) onSelectCategory;
  final int maxSelect;
  final List<Category>? selected;
  final DateTime? nextUpdate;
  final bool isAdding;

  const CategoriesBottomsheet({super.key, required this.onSelectCategory, this.maxSelect = 1, this.selected, this.nextUpdate, this.isAdding = false});

  @override
  State<CategoriesBottomsheet> createState() => _CategoriesBottomsheetState();
}

class _CategoriesBottomsheetState extends State<CategoriesBottomsheet> {
  List<Category> parentCategories = [];
  List<bool> isExpandedParents = [];
  List<Category> filteredCategories = [];
  List<Category> selectedCategories = [];
  String searchCategory = '';
  RxBool isLoading = true.obs;
  bool hasFinishedCategoryTutorial = false;
  bool hasOpenedTutorial = false;

  @override
  void initState() {
    super.initState();
    MainAppController.find.updateCategories().then(
      (value) {
        parentCategories = MainAppController.find.categories.where((element) => element.parentId == -1).toList();
        isExpandedParents = [for (var i = 0; i < parentCategories.length; i++) false];
        filteredCategories = _initializeFilteredCategories();
        selectedCategories = widget.selected ?? [];
        isLoading.value = false;
        setState(() {});
      },
    );
    Future.delayed(Durations.extralong2, () {
      hasFinishedCategoryTutorial = SharedPreferencesService.find.get(hasFinishedCategoryTutorialKey) == 'true';
      if (!hasFinishedCategoryTutorial) {
        CategoriesTutorial.showTutorial();
        Helper.waitAndExecute(() => CategoriesTutorial.targets.isNotEmpty && !isLoading.value, () {
          if (!hasOpenedTutorial) {
            setState(() => hasOpenedTutorial = true);
            MainScreenWithBottomNavigation.isOnTutorial.value = true;
            TutorialCoachMark(
              targets: CategoriesTutorial.targets,
              colorShadow: kNeutralOpacityColor,
              textSkip: 'skip'.tr,
              textStyleSkip: AppFonts.x12Bold.copyWith(color: kBlackReversedColor),
              additionalWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                child: Obx(
                  () => CheckboxListTile(
                    dense: true,
                    checkColor: kNeutralColor100,
                    contentPadding: EdgeInsets.zero,
                    side: BorderSide(color: kNeutralColor100),
                    title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                    value: CategoriesTutorial.notShowAgain.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) => CategoriesTutorial.notShowAgain.value = value ?? false,
                  ),
                ),
              ),
              onSkip: () {
                if (CategoriesTutorial.notShowAgain.value) {
                  SharedPreferencesService.find.add(hasFinishedCategoryTutorialKey, 'true');
                }
                MainScreenWithBottomNavigation.isOnTutorial.value = false;
                setState(() => hasOpenedTutorial = false);
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedCategoryTutorialKey, 'true'),
            ).show(context: context);
          }
        });
      }
    });
  }

  void filterCategories(String value) {
    isLoading.value = true;
    searchCategory = value;
    if (value.isEmpty) {
      filteredCategories = parentCategories;
    } else {
      filteredCategories = parentCategories
          .where(
            (element) =>
                element.name.toLowerCase().contains(value.toLowerCase()) ||
                MainAppController.find.getCategoryChildren(element).any((childCategory) => childCategory.name.toLowerCase().contains(value.toLowerCase())),
          )
          .toList();
    }
    isLoading.value = false;
    setState(() {});
  }

  List<Category> _initializeFilteredCategories() {
    List<Category> result = [];
    result.addAll(parentCategories);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final canUpdate = widget.nextUpdate != null ? widget.nextUpdate!.isBefore(DateTime.now()) : true;
    return PopScope(
      canPop: !hasOpenedTutorial,
      child: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: kNeutralColor100),
          child: SizedBox(
            height: Get.height * 0.9,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Paddings.regular, horizontal: Paddings.large),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.maxSelect > 1) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 40),
                                Text('subscribe_categories'.tr, style: AppFonts.x16Bold),
                                CustomButtons.icon(
                                  icon: Icon(Icons.check_circle_outlined, color: selectedCategories.isEmpty ? kDisabledColor : kBlackColor),
                                  disabled: selectedCategories.isEmpty,
                                  onPressed: () {
                                    if (canUpdate && selectedCategories.isNotEmpty) widget.onSelectCategory.call(selectedCategories);
                                    Helper.goBack();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: Paddings.large),
                            if (canUpdate) ...[
                              Text(
                                '${'select_x_categories'.trParams({'max': widget.maxSelect.toString()})}: ${'y_of_x_selected'.trParams({
                                      'selected': selectedCategories.length.toString(),
                                      'max': widget.maxSelect.toString()
                                    })}',
                                style: AppFonts.x12Regular,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  style: AppFonts.x12Regular,
                                  children: [
                                    WidgetSpan(
                                      baseline: TextBaseline.alphabetic,
                                      alignment: PlaceholderAlignment.baseline,
                                      child: InkWell(
                                        onTap: () => debugPrint('Subscribe tapped'),
                                        child: Text('subscribe'.tr, style: AppFonts.x12Bold.copyWith(decoration: TextDecoration.underline)),
                                      ),
                                    ),
                                    TextSpan(text: ' ${'premium_more_categories'.tr}'),
                                  ],
                                ),
                              ),
                            ] else if (widget.nextUpdate != null)
                              Text('update_categories_in_date'.trParams({'date': Helper.formatDate(widget.nextUpdate!)}), style: AppFonts.x12Regular),
                          ],
                          const SizedBox(height: Paddings.regular),
                          CustomTextField(
                            key: CategoriesTutorial.searchFieldKey,
                            hintText: 'search_category'.tr,
                            outlinedBorder: true,
                            onChanged: (value) => Helper.onSearchDebounce(() => filterCategories(value)),
                          ),
                          const SizedBox(height: Paddings.regular),
                          LoadingCardEffect(
                            isLoading: isLoading,
                            type: LoadingCardEffectType.categoryBottomSheet,
                            child: Wrap(
                              children: List.generate(
                                filteredCategories.length,
                                (index) {
                                  final parentCategory = filteredCategories[index];
                                  return StatefulBuilder(
                                    builder: (context, setStateCategory) {
                                      void toggleExpandParent(bool value) {
                                        if (value) {
                                          isExpandedParents = [for (var i = 0; i < parentCategories.length; i++) false];
                                          setState(() {});
                                        }
                                        setStateCategory(() => isExpandedParents[index] = value);
                                      }

                                      return AnimatedContainer(
                                        duration: Durations.medium3,
                                        width: isExpandedParents[index] ? Get.width : (Get.width - 30) / 3,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                                        child: isExpandedParents[index]
                                            ? Theme(
                                                data: ThemeData(dividerColor: kNeutralLightColor),
                                                child: ExpansionTile(
                                                  initiallyExpanded: true,
                                                  onExpansionChanged: (value) => toggleExpandParent(value),
                                                  trailing: Icon(Icons.close, color: isExpandedParents[index] ? kNeutralColor : null),
                                                  title: Text(parentCategory.name, style: AppFonts.x16Bold, overflow: TextOverflow.ellipsis),
                                                  childrenPadding: EdgeInsets.zero,
                                                  children: [
                                                    GridView.extent(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      maxCrossAxisExtent: 140.0,
                                                      childAspectRatio: 0.85,
                                                      mainAxisSpacing: Paddings.regular,
                                                      crossAxisSpacing: Paddings.regular,
                                                      padding: const EdgeInsets.all(Paddings.large),
                                                      children: MainAppController.find
                                                          .getCategoryChildren(parentCategory)
                                                          .where((element) => searchCategory.isNotEmpty ? element.name.toLowerCase().contains(searchCategory.toLowerCase()) : true)
                                                          .map(
                                                        (subCategory) {
                                                          final isSelected = selectedCategories.any((element) => element.id == subCategory.id);
                                                          return buildCategoryWidget(
                                                            canUpdate: canUpdate,
                                                            isSelected: isSelected,
                                                            category: subCategory,
                                                            isChild: true,
                                                            onTap: () {
                                                              if (canUpdate) {
                                                                if (isSelected) {
                                                                  selectedCategories.remove(subCategory);
                                                                } else if (selectedCategories.length < widget.maxSelect) {
                                                                  selectedCategories.add(subCategory);
                                                                }
                                                                setState(() {});
                                                                if (canUpdate && widget.maxSelect == 1 && selectedCategories.length == widget.maxSelect) {
                                                                  widget.onSelectCategory.call(selectedCategories);
                                                                  Helper.goBack();
                                                                }
                                                              }
                                                            },
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : buildCategoryWidget(
                                                key: index == 0 ? CategoriesTutorial.categoryKey : null,
                                                canUpdate: canUpdate,
                                                category: parentCategory,
                                                onTap: () => setStateCategory(() => toggleExpandParent(true)),
                                              ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (selectedCategories.isNotEmpty && canUpdate)
                  SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                      child: DecoratedBox(
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralOpacityColor))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Paddings.regular, horizontal: Paddings.regular),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                                child: Text(
                                  '${'select_x_categories'.trParams({'max': widget.maxSelect.toString()})}: ${'y_of_x_selected'.trParams({
                                        'selected': selectedCategories.length.toString(),
                                        'max': widget.maxSelect.toString()
                                      })}',
                                  style: AppFonts.x12Regular,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    selectedCategories.length,
                                    (index) => SizedBox(
                                      width: 110,
                                      child: buildCategoryWidget(
                                        canUpdate: canUpdate,
                                        dense: true,
                                        isSelected: true,
                                        onTap: () => setState(() => selectedCategories.remove(selectedCategories[index])),
                                        category: selectedCategories[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryWidget(
      {required bool canUpdate, bool isSelected = false, required void Function() onTap, required Category category, bool isChild = false, GlobalKey? key, bool dense = false}) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: SingleChildScrollView(
        child: Tooltip(
          message: category.description,
          showDuration: const Duration(seconds: 5),
          margin: const EdgeInsets.symmetric(horizontal: Paddings.large),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Paddings.small),
                    child: CircleAvatar(
                      radius: dense ? 21 : 30,
                      backgroundColor: isSelected
                          ? kPrimaryColor
                          : isChild
                              ? kAccentDarkColor
                              : kNeutralColor,
                      child: Center(
                        child: Buildables.buildCategoryIcon(category.icon,
                            size: dense ? 28 : 40,
                            color: ThemeService.find.isDark
                                ? isChild
                                    ? null
                                    : kNeutralColor100
                                : kNeutralColor100),
                      ),
                    ),
                  ),
                  if (category.description.isNotEmpty && !dense)
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.info_outline, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: Paddings.small),
              Text(
                '${category.name} ${widget.isAdding ? '(${category.subscribed})' : ''}',
                style: AppFonts.x12Regular.copyWith(fontSize: dense ? 10 : 12),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
