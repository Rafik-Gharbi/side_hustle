import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../services/theme/theme.dart';
import 'on_hover.dart';

enum ButtonType { elevatePrimary, elevateSecondary, text, icon, iconWithBackground }

// ignore: must_be_immutable
class CustomButtons extends StatelessWidget {
  final ButtonType? buttonType;
  final VoidCallback onPressed;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final double? width;
  final double? height;
  final RxBool? loading;
  final bool disabled;
  final Widget? icon;
  final bool? isIconLeft;
  final double? iconSize;
  final Color? iconColor;
  final Color? buttonColor;
  final Size? minimumSize;
  final EdgeInsets? padding;
  final BorderSide? borderSide;

  const CustomButtons.elevatePrimary({
    required this.onPressed,
    super.key,
    this.title,
    this.titleStyle,
    this.child,
    this.width,
    this.height,
    this.loading,
    this.disabled = false,
    this.buttonColor,
    this.padding,
    this.borderSide,
    this.icon,
    this.isIconLeft = true,
  })  : buttonType = ButtonType.elevatePrimary,
        iconSize = null,
        iconColor = null,
        minimumSize = null;

  const CustomButtons.elevateSecondary({
    required this.onPressed,
    super.key,
    this.title,
    this.titleStyle,
    this.child,
    this.width,
    this.height,
    this.loading,
    this.disabled = false,
    this.padding,
    this.icon,
    this.isIconLeft = true,
    this.buttonColor,
    this.borderSide,
  })  : buttonType = ButtonType.elevateSecondary,
        iconSize = null,
        iconColor = null,
        minimumSize = null;

  const CustomButtons.text({
    required this.onPressed,
    super.key,
    this.title,
    this.titleStyle,
    this.child,
    this.disabled = false,
    this.minimumSize,
  })  : assert(title != null || child != null, 'Text button should have a title or a child!'),
        buttonType = ButtonType.text,
        loading = null,
        icon = null,
        isIconLeft = null,
        borderSide = null,
        width = null,
        height = null,
        iconSize = null,
        iconColor = null,
        buttonColor = null,
        padding = null;

  const CustomButtons.icon({
    required this.onPressed,
    this.icon,
    super.key,
    this.disabled = false,
    this.iconSize,
    this.iconColor,
    this.child,
    this.padding,
  })  : assert(icon != null || child != null, 'Icon button should have an icon or a child'),
        buttonType = ButtonType.icon,
        title = null,
        titleStyle = null,
        width = null,
        isIconLeft = null,
        height = null,
        borderSide = null,
        loading = null,
        buttonColor = null,
        minimumSize = null;

  const CustomButtons.iconWithBackground({
    required this.onPressed,
    super.key,
    this.disabled = false,
    this.icon,
    this.buttonColor,
    this.padding,
    this.width,
    this.height,
    this.child,
  })  : assert(icon != null || child != null, 'Icon with background button should have an icon or a child'),
        buttonType = ButtonType.iconWithBackground,
        title = null,
        titleStyle = null,
        borderSide = null,
        isIconLeft = null,
        loading = null,
        iconSize = null,
        iconColor = null,
        minimumSize = null;

  @override
  Widget build(BuildContext context) {
    Widget getButton(bool? loading) {
      switch (buttonType) {
        case ButtonType.elevatePrimary:
          return ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: borderSide ?? BorderSide.none,
                ),
              ),
              padding: WidgetStateProperty.all(padding ?? EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(
                Size(
                  width ?? 50,
                  height ?? 50,
                ),
              ),
              backgroundColor: buttonColor != null
                  ? WidgetStateProperty.all(buttonColor)
                  : disabled
                      ? WidgetStateProperty.all(kNeutralColor)
                      : WidgetStateProperty.all(kPrimaryColor),
            ),
            onPressed: disabled || (loading ?? false)
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed();
                  },
            child: icon != null
                ? SizedBox(
                    width: width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (isIconLeft!)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                            child: icon,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: (loading ?? false)
                                ? Center(
                                    child: SizedBox(
                                      width: (height ?? 50) - 20,
                                      height: (height ?? 50) - 20,
                                      child: CircularProgressIndicator(color: kNeutralColor100),
                                    ),
                                  )
                                : Text(
                                    title ?? '',
                                    style: (titleStyle ?? AppFonts.x16Bold).copyWith(
                                      color: buttonColor != null
                                          ? Helper.isColorDarkEnoughForWhiteText(buttonColor!)
                                              ? kBlackColor
                                              : kNeutralColor100
                                          : kNeutralColor100,
                                    ),
                                  ),
                          ),
                        ),
                        if (!isIconLeft!)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                            child: icon,
                          ),
                      ],
                    ),
                  )
                : child ??
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: (loading ?? false)
                          ? Center(
                              child: SizedBox(
                                width: (height ?? 50) - 20,
                                height: (height ?? 50) - 20,
                                child: CircularProgressIndicator(color: kNeutralColor100),
                              ),
                            )
                          : Text(
                              title ?? '',
                              style: (titleStyle ?? AppFonts.x16Bold).copyWith(
                                color: buttonColor != null
                                    ? Helper.isColorDarkEnoughForWhiteText(buttonColor!)
                                        ? Colors.black
                                        : Colors.white
                                    : Colors.white,
                              ),
                            ),
                    ),
          );
        case ButtonType.elevateSecondary:
          return OnHover(
            builder: (isHovered) => ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    side: borderSide ?? BorderSide(color: kNeutralLightColor),
                  ),
                ),
                padding: WidgetStateProperty.all(padding ?? EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all(
                  Size(
                    width ?? 50,
                    height ?? 50,
                  ),
                ),
                surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                backgroundColor: disabled ? WidgetStateProperty.all(Theme.of(context).scaffoldBackgroundColor) : WidgetStateProperty.all(buttonColor ?? kNeutralColor100),
              ),
              onPressed: disabled || (loading ?? false)
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onPressed();
                    },
              child: icon != null
                  ? SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (isIconLeft!)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              child: icon,
                            ),
                          (loading ?? false)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
                                  child: SizedBox(
                                    width: (height ?? 50) - 20,
                                    height: (height ?? 50) - 20,
                                    child: const CircularProgressIndicator(color: kPrimaryColor),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                  child: Text(
                                    title ?? '',
                                    style: titleStyle ?? AppFonts.x15Bold,
                                  ),
                                ),
                          if (!isIconLeft!)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                              child: icon,
                            ),
                        ],
                      ),
                    )
                  : child ??
                      ((loading ?? false)
                          ? SizedBox(
                              width: height != null && height! > 50 ? 50 : (height ?? 50) - 20,
                              height: height != null && height! > 50 ? 50 : (height ?? 50) - 20,
                              child: const CircularProgressIndicator(color: kPrimaryColor),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                title ?? '',
                                style: titleStyle ?? AppFonts.x15Bold.copyWith(fontWeight: isHovered ? FontWeight.bold : FontWeight.normal),
                              ),
                            )),
            ),
          );
        case ButtonType.text:
          return OnHover(
            builder: (isHovered) => TextButton(
              onPressed: disabled || (loading ?? false)
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onPressed();
                    },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: Paddings.regular)),
                minimumSize: minimumSize != null ? WidgetStateProperty.all(minimumSize) : null,
              ),
              child: child ??
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: DecoratedBox(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isHovered ? kSelectedColor : (titleStyle?.color ?? kSecondaryColor)))),
                      child: Text(
                        title ?? '',
                        style: disabled
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: titleStyle?.fontSize ?? 17)
                            : (titleStyle ?? AppFonts.x16Regular).copyWith(
                                color: isHovered ? kSelectedColor : titleStyle?.color,
                                decorationColor: isHovered ? kSelectedColor : titleStyle?.color,
                              ),
                      ),
                    ),
                  ),
            ),
          );
        case ButtonType.icon:
          return IconButton(
            icon: child ?? icon!,
            disabledColor: kNeutralColor,
            padding: padding ?? EdgeInsets.zero,
            iconSize: iconSize != null && iconSize! > 0 ? iconSize! : 24.0,
            color: iconColor ?? kSecondaryColor,
            onPressed: disabled || (loading ?? false)
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed();
                  },
          );
        case ButtonType.iconWithBackground:
          return ElevatedButton(
            onPressed: disabled || (loading ?? false)
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onPressed();
                  },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(RadiusSize.regular))),
              minimumSize: Size(width ?? 50, height ?? 50),
              elevation: 0,
              padding: padding ?? const EdgeInsets.all(Paddings.regular),
              backgroundColor: disabled ? Theme.of(context).scaffoldBackgroundColor : buttonColor ?? kPrimaryColor,
            ),
            child: child ?? icon,
          );
        default:
          return Container();
      }
    }

    return loading != null ? Obx(() => getButton(loading!.value)) : getButton(null);
  }
}
