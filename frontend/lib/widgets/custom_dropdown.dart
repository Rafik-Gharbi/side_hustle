import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import 'on_hover.dart';

import '../services/theme/theme.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  final String? hint;
  final String? label;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final Function(bool)? isMenuOpen;
  final String? Function(T?)? validator;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? dropdownWidth;
  final double? dropdownMaxHeight;
  final int? elevation;
  final bool isRequired;
  final bool isDisabled;
  final bool labelIncluded;
  final bool noLabel;
  final bool labelAlongside;
  final bool addWidthFallBack;
  final double? textFontSize;
  final Widget? customButton;
  final Widget? icon;
  final EdgeInsets? itemPadding;
  final bool includeScrollbar;
  final Offset? offset;
  final EdgeInsetsGeometry? dropdownScrollPadding;
  final bool dropDownWithDecoration;
  final double itemHeight;
  final int flexLabel;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn;
  final Color? overlayColor;
  final String Function(T)? valueFrom;
  final bool withClearItem;
  final bool maxWidth;
  final Color? outlinedBorderColor;

  const CustomDropDownMenu({
    required this.items,
    required this.onChanged,
    this.valueFrom,
    this.selectedItem,
    this.withClearItem = false,
    this.maxWidth = false,
    this.hint,
    this.dropdownScrollPadding,
    this.customButton,
    this.icon,
    this.itemPadding,
    this.isMenuOpen,
    this.label,
    this.validator,
    this.includeScrollbar = false,
    this.noLabel = true,
    this.isRequired = false,
    this.isDisabled = false,
    this.labelIncluded = false,
    this.labelAlongside = false,
    this.dropDownWithDecoration = false,
    this.addWidthFallBack = false,
    this.buttonWidth,
    this.buttonHeight = 35,
    this.dropdownWidth,
    this.dropdownMaxHeight,
    this.offset,
    this.elevation,
    this.textFontSize,
    this.itemHeight = 48,
    this.flexLabel = 3,
    this.searchMatchFn,
    super.key,
    this.overlayColor,
    this.outlinedBorderColor,
  }) : assert(
          hint == null || customButton == null,
          'Please ether use hintWidget or customButton',
        );

  @override
  Widget build(BuildContext context) {
    final double? width = maxWidth
        ? null
        : buttonWidth != null && buttonWidth! < 300 && addWidthFallBack
            ? 300
            : buttonWidth ?? 300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!noLabel && !labelIncluded && !labelAlongside)
          Padding(
            padding: const EdgeInsets.only(bottom: Paddings.small),
            child: RichText(
              text: TextSpan(
                text: label,
                style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppFonts.x15Bold.copyWith(color: kErrorColor),
                    ),
                ],
              ),
            ),
          ),
        SizedBox(
          width: maxWidth
              ? null
              : labelAlongside
                  ? width! + 80
                  : width! / 2,
          // height: buttonHeight,
          child: labelIncluded
              ? _BuildDropDownButton(
                  itemHeight: itemHeight,
                  dropDownWithDecoration: dropDownWithDecoration,
                  items: items,
                  isMenuOpen: isMenuOpen,
                  dropdownScrollPadding: dropdownScrollPadding,
                  onChanged: onChanged,
                  buttonHeight: buttonHeight,
                  buttonWidth: width,
                  maxWidth: maxWidth,
                  customButton: customButton,
                  dropdownMaxHeight: dropdownMaxHeight,
                  dropdownWidth: dropdownWidth,
                  elevation: elevation,
                  hint: hint,
                  isDisabled: isDisabled,
                  icon: icon,
                  includeScrollbar: includeScrollbar,
                  isRequired: isRequired,
                  itemPadding: itemPadding,
                  label: label,
                  labelAlongside: labelAlongside,
                  labelIncluded: labelIncluded,
                  offset: offset,
                  flexLabel: flexLabel,
                  searchMatchFn: searchMatchFn,
                  overlayColor: overlayColor,
                  selectedItem: selectedItem,
                  valueFrom: valueFrom,
                  withClearItem: withClearItem,
                  validator: validator,
                  outlinedBorderColor: outlinedBorderColor,
                )
              : _BuildDropDownButton(
                  itemHeight: itemHeight,
                  dropDownWithDecoration: dropDownWithDecoration,
                  items: items,
                  isMenuOpen: isMenuOpen,
                  isDisabled: isDisabled,
                  onChanged: onChanged,
                  buttonHeight: buttonHeight,
                  buttonWidth: width,
                  customButton: customButton,
                  dropdownMaxHeight: dropdownMaxHeight,
                  maxWidth: maxWidth,
                  dropdownWidth: dropdownWidth,
                  elevation: elevation,
                  hint: hint,
                  icon: icon,
                  includeScrollbar: includeScrollbar,
                  isRequired: isRequired,
                  itemPadding: itemPadding,
                  label: label,
                  labelAlongside: labelAlongside,
                  labelIncluded: labelIncluded,
                  offset: offset,
                  flexLabel: flexLabel,
                  searchMatchFn: searchMatchFn,
                  overlayColor: overlayColor,
                  selectedItem: selectedItem,
                  valueFrom: valueFrom,
                  withClearItem: withClearItem,
                  validator: validator,
                  outlinedBorderColor: outlinedBorderColor,
                ),
        ),
      ],
    );
  }
}

class _BuildDropDownButton<T> extends StatelessWidget {
  final String? hint;
  final String? label;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final Function(bool)? isMenuOpen;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? dropdownWidth;
  final double? dropdownMaxHeight;
  final int? elevation;
  final bool isRequired;
  final bool labelIncluded;
  final bool labelAlongside;
  final bool dropDownWithDecoration;
  final Widget? customButton;
  final Widget? icon;
  final EdgeInsets? itemPadding;
  final bool includeScrollbar;
  final bool isDisabled;
  final Offset? offset;
  final EdgeInsetsGeometry? dropdownScrollPadding;
  final double? itemHeight;
  final int flexLabel;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn;
  final Color? overlayColor;
  final String Function(T)? valueFrom;
  final bool withClearItem;
  final bool maxWidth;
  final String? Function(T?)? validator;
  final Color? outlinedBorderColor;

  const _BuildDropDownButton({
    required this.items,
    required this.onChanged,
    required this.flexLabel,
    this.selectedItem,
    this.withClearItem = false,
    this.maxWidth = false,
    this.hint,
    this.validator,
    this.isDisabled = false,
    this.dropdownScrollPadding,
    this.label,
    this.isMenuOpen,
    this.buttonWidth,
    this.buttonHeight,
    this.dropdownWidth,
    this.dropdownMaxHeight,
    this.elevation,
    this.isRequired = false,
    this.labelIncluded = false,
    this.labelAlongside = false,
    this.dropDownWithDecoration = true,
    this.customButton,
    this.icon,
    this.itemPadding,
    this.includeScrollbar = false,
    this.offset,
    this.itemHeight,
    this.searchMatchFn,
    this.overlayColor,
    this.valueFrom,
    this.outlinedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final hintText = (hint ?? '') + (isRequired ? ' (${'required'.tr})' : '');
    return DecoratedBox(
      decoration: BoxDecoration(color: kNeutralColor100, borderRadius: smallRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (labelAlongside)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(label ?? 'Please provide a label', style: AppFonts.x14Regular.copyWith(color: kNeutralColor)),
            ),
          Flexible(
            fit: maxWidth ? FlexFit.tight : FlexFit.loose,
            child: SizedBox(
              width: maxWidth ? null : (buttonWidth ?? 100) / 2,
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: const ScrollbarThemeData().copyWith(thumbColor: WidgetStateProperty.all(kPrimaryColor)),
                  hoverColor: Colors.transparent,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2<T>(
                    dropdownStyleData: DropdownStyleData(
                      offset: offset ?? const Offset(0, -1),
                      elevation: elevation ?? 8,
                      scrollPadding: dropdownScrollPadding,
                      maxHeight: dropdownMaxHeight,
                      width: dropdownWidth,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(RadiusSize.regular), color: Colors.white),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(1.5),
                        thickness: const WidgetStatePropertyAll(3),
                        thumbVisibility: WidgetStatePropertyAll(includeScrollbar),
                      ),
                    ),
                    customButton: customButton,
                    isExpanded: true,
                    validator: validator,
                    selectedItemBuilder: (context) => [
                      for (int i = 0; i < items.length; i++)
                        Center(
                          widthFactor: 1,
                          child: Text(
                            selectedItem != null && valueFrom != null ? valueFrom!.call(selectedItem as T) : selectedItem?.toString() ?? hintText,
                            style: AppFonts.x14Regular.copyWith(color: selectedItem != null ? kBlackColor : kNeutralColor.withAlpha(150)),
                          ),
                        ),
                    ],
                    items: isDisabled
                        ? []
                        : items
                            .map<DropdownMenuItem<T>>(
                              (value) => DropdownMenuItem<T>(
                                value: value,
                                child: OnHover(
                                  builder: (isHovered) => DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: isHovered
                                          ? kNeutralLightColor.withAlpha(150)
                                          : selectedItem != null && selectedItem == value
                                              ? kPrimaryColor
                                              : null,
                                      borderRadius: smallRadius,
                                    ),
                                    child: Center(
                                      child: Text(valueFrom?.call(value) ?? value.toString(), style: AppFonts.x14Regular.copyWith(color: selectedItem != null && selectedItem == value ? kNeutralColor100 : kBlackColor)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: isDisabled ? (value) {} : onChanged,
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: icon ?? Icon(Icons.expand_more, size: 25, color: kNeutralColor),
                      ),
                      openMenuIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: icon ?? Icon(Icons.expand_less, size: 25, color: kNeutralColor),
                      ),
                    ),
                    hint: labelIncluded
                        ? Row(
                            children: [
                              if (labelIncluded) ...[
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: flexLabel,
                                  child: Center(child: Text(label ?? '', style: AppFonts.x14Regular)),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: .6,
                                  height: 50,
                                  child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor)),
                                ),
                              ],
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    hintText,
                                    style: AppFonts.x14Regular.copyWith(color: selectedItem != null ? kBlackColor : kNeutralColor.withAlpha(150)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: buttonHeight,
                            child: Text(
                              selectedItem != null && valueFrom != null ? valueFrom!.call(selectedItem as T) : selectedItem?.toString() ?? hintText,
                              style: AppFonts.x14Regular.copyWith(color: selectedItem != null ? kBlackColor : kNeutralColor.withAlpha(150)),
                            ),
                          ),
                    buttonStyleData: ButtonStyleData(
                      // height: buttonHeight,
                      width: maxWidth ? null : buttonWidth,
                      decoration: isDisabled
                          ? BoxDecoration(
                              color: kNeutralColor,
                              border: Border.all(color: kNeutralColor, width: .6),
                              borderRadius: const BorderRadius.all(Radius.circular(RadiusSize.regular)),
                            )
                          : null,
                      overlayColor: overlayColor != null ? WidgetStatePropertyAll(overlayColor) : null,
                    ),
                    menuItemStyleData: MenuItemStyleData(height: itemHeight!, padding: itemPadding ?? const EdgeInsets.all(Paddings.small)),
                    onMenuStateChange: (isOpen) {
                      isMenuOpen?.call(isOpen);
                      if (!isOpen) searchController.clear();
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.regular),
                      alignLabelWithHint: true,
                      border: dropDownWithDecoration
                          ? OutlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius)
                          : UnderlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius),
                      errorBorder: dropDownWithDecoration
                          ? OutlineInputBorder(borderSide: const BorderSide(color: kErrorColor), borderRadius: smallRadius)
                          : UnderlineInputBorder(borderSide: const BorderSide(color: kErrorColor), borderRadius: smallRadius),
                      enabledBorder: dropDownWithDecoration
                          ? OutlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius)
                          : UnderlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius),
                      focusedBorder: dropDownWithDecoration
                          ? OutlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius)
                          : UnderlineInputBorder(borderSide: BorderSide(color: outlinedBorderColor ?? kNeutralLightColor), borderRadius: smallRadius),
                      floatingLabelStyle: AppFonts.x14Regular.copyWith(height: 0.2),
                      hintStyle: AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(150)),
                    ),
                    dropdownSearchData: searchMatchFn == null
                        ? null
                        : DropdownSearchData(
                            searchController: searchController,
                            searchMatchFn: searchMatchFn,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.small),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: searchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: 'search_item'.tr,
                                  hintStyle: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: kNeutralColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: kNeutralColor)),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
