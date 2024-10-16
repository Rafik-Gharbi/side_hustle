import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../controllers/main_app_controller.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';

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
  final searchFocusNode = FocusNode();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  List<Category> selectedCategories = [];
  String searchCategory = '';

  @override
  void initState() {
    super.initState();
    categories = MainAppController.find.categories.where((element) => element.parentId == -1).toList();
    filteredCategories = _initializeFilteredCategories();
    selectedCategories = widget.selected ?? [];
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void filterCategories(String value) {
    searchCategory = value;
    if (value.isEmpty) {
      filteredCategories = categories;
    } else {
      filteredCategories = categories
          .where(
            (element) =>
                element.name.toLowerCase().contains(value.toLowerCase()) ||
                MainAppController.find.getCategoryChildren(element).any((childCategory) => childCategory.name.toLowerCase().contains(value.toLowerCase())),
          )
          .toList();
    }
    setState(() {});
  }

  List<Category> _initializeFilteredCategories() {
    List<Category> result = [];
    result.addAll(categories);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => searchFocusNode.requestFocus());
    final canUpdate = widget.nextUpdate != null ? widget.nextUpdate!.isBefore(DateTime.now()) : true;
    return SafeArea(
      minimum: const EdgeInsets.only(top: Paddings.exceptional),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusSize.extraLarge))),
        child: Padding(
          padding: const EdgeInsets.only(top: Paddings.regular),
          child: SizedBox(
            height: Get.height * 0.9,
            width: Get.width,
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
                          icon: const Icon(Icons.check_circle_outlined),
                          onPressed: () {
                            if (canUpdate) widget.onSelectCategory.call(selectedCategories);
                            Get.back();
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
                              child: InkWell(
                                onTap: () => debugPrint('Subscribe tapped'),
                                child: Text('subscribe'.tr, style: AppFonts.x12Bold.copyWith(decoration: TextDecoration.underline)),
                              ),
                            ),
                            TextSpan(text: 'premium_more_categories'.tr),
                          ],
                        ),
                      ),
                    ] else if (widget.nextUpdate != null)
                      Text('update_categories_in_date'.trParams({'date': Helper.formatDate(widget.nextUpdate!)}), style: AppFonts.x12Regular),
                  ],
                  const SizedBox(height: Paddings.regular),
                  CustomTextField(
                    hintText: 'search_category'.tr,
                    focusNode: searchFocusNode,
                    // textStyle: AppFonts.x14Regular.copyWith(height: 0.1),
                    // border: UnderlineInputBorder(borderSide: BorderSide(color: kNeutralLightColor)),
                    onChanged: (value) => Helper.onSearchDebounce(() => filterCategories(value)),
                  ),
                  const SizedBox(height: Paddings.regular),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final parentCategory = filteredCategories[index];
                        bool isExpanded = true;
                        return Theme(
                          data: ThemeData(dividerColor: kNeutralLightColor),
                          child: StatefulBuilder(
                            builder: (context, setStateCategory) => ExpansionTile(
                              initiallyExpanded: true,
                              onExpansionChanged: (value) => setStateCategory(() => isExpanded = value),
                              trailing: Icon(isExpanded ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: isExpanded ? kNeutralColor : null),
                              title: Text(parentCategory.name, style: AppFonts.x16Bold),
                              children: [
                                GridView.extent(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  maxCrossAxisExtent: 140.0,
                                  mainAxisSpacing: Paddings.regular,
                                  crossAxisSpacing: Paddings.regular,
                                  padding: const EdgeInsets.all(Paddings.large),
                                  children: MainAppController.find
                                      .getCategoryChildren(parentCategory)
                                      .where((element) => searchCategory.isNotEmpty ? element.name.toLowerCase().contains(searchCategory.toLowerCase()) : true)
                                      .map(
                                    (subCategory) {
                                      final isSelected = selectedCategories.any((element) => element.id == subCategory.id);
                                      return InkWell(
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
                                              Get.back();
                                            }
                                          }
                                        },
                                        child: Center(
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: isSelected ? kPrimaryColor : kNeutralColor,
                                                child: Center(child: Icon(subCategory.icon, color: kNeutralColor100)),
                                              ),
                                              const SizedBox(height: Paddings.small),
                                              Text(
                                                '${subCategory.name} (${subCategory.subscribed})',
                                                style: AppFonts.x12Regular,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
