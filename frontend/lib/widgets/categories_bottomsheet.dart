import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/buildables.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';
import 'loading_card_effect.dart';

class CategoriesBottomsheet extends StatefulWidget {
  final void Function(List<Category> category) onSelectCategory;
  final int maxSelect;
  final List<Category>? selected;
  final DateTime? nextUpdate;

  const CategoriesBottomsheet({super.key, required this.onSelectCategory, this.maxSelect = 1, this.selected, this.nextUpdate});

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
    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: kNeutralColor100),
        child: Padding(
          padding: const EdgeInsets.only(bottom: Paddings.extraLarge),
          child: SizedBox(
            height: Get.height * 0.9,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Paddings.regular, horizontal: Paddings.large),
              child: SingleChildScrollView(
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
                            icon: const Icon(Icons.check_circle_outlined),
                            onPressed: () {
                              if (canUpdate) widget.onSelectCategory.call(selectedCategories);
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
                      hintText: 'search_category'.tr,
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
        ),
      ),
    );
  }

  Widget buildCategoryWidget({required bool canUpdate, bool isSelected = false, required void Function() onTap, required Category category, bool isChild = false}) {
    return InkWell(
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
                      radius: 30,
                      backgroundColor: isSelected
                          ? kPrimaryColor
                          : isChild
                              ? kAccentDarkColor
                              : kNeutralColor,
                      child: Center(child: Buildables.buildCategoryIcon(category.icon, size: 40, color: kNeutralColor100)),
                    ),
                  ),
                  if (category.description.isNotEmpty)
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.info_outline, size: 16),
                    ),
                ],
              ),
              const SizedBox(height: Paddings.small),
              Text(
                '${category.name} (${category.subscribed})',
                style: AppFonts.x12Regular,
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
