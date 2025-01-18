import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../services/theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? fieldController;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? labelText;
  final TextInputType? textInputType;
  final bool isTextArea;
  final int textAreaLines;
  final bool isOptional;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double? height;
  final FocusNode? focusNode;
  final bool? readOnly;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final bool isChat;
  final double? topPadding;
  final double? textFontSize;
  final int? maxLength;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final bool outlinedBorder;
  final bool enableFloatingLabel;
  final Color fillColor;
  final Color? outlinedBorderColor;
  final BorderRadius? borderRadius;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final InputDecoration? decoration;

  const CustomTextField({
    super.key,
    this.suffixIcon,
    this.hintTextStyle,
    this.hintText,
    this.isChat = false,
    this.labelText,
    this.fieldController,
    this.validator,
    this.onTap,
    this.borderRadius,
    this.fillColor = Colors.transparent,
    this.outlinedBorderColor,
    this.onChanged,
    this.onSubmitted,
    this.textInputType,
    this.isTextArea = false,
    this.isPassword = false,
    this.isOptional = true,
    this.readOnly,
    this.height,
    this.width,
    this.focusNode,
    this.enabled = true,
    this.topPadding,
    this.textFontSize,
    this.maxLength,
    this.textAlign,
    this.autofocus = false,
    this.prefixIcon,
    this.outlinedBorder = false,
    this.enableFloatingLabel = true,
    this.onTapOutside,
    this.textCapitalization,
    this.inputFormatters,
    this.decoration,
    this.textAreaLines = 5,
  });

  @override
  // ignore: no_logic_in_create_state
  CustomTextFieldState createState() => CustomTextFieldState(isPassword);
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late String hintText;

  CustomTextFieldState(this._obscureText);
  @override
  void initState() {
    super.initState();
    hintText = (widget.hintText ?? '') + (widget.isOptional ? '' : ' (${'required'.tr})');
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          // if (widget.isOptional)
          //   Positioned(
          //     top: 10,
          //     right: 5,
          //     child: Text(
          //       'lbl_optional'.tr,
          //       style: const TextStyle(fontSize: 8),
          //     ),
          //   ),
          ClipRRect(
            borderRadius: widget.borderRadius ?? smallRadius,
            child: Container(
              height: widget.height,
              margin: EdgeInsets.only(top: widget.topPadding ?? 0),
              padding: widget.enableFloatingLabel ? const EdgeInsets.only(top: 3) : null,
              width: widget.width ?? MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: widget.fillColor, borderRadius: smallRadius),
              child: Center(
                child: TextFormField(
                  maxLength: widget.maxLength,
                  onTapOutside: widget.onTapOutside,
                  inputFormatters: widget.inputFormatters,
                  style: TextStyle(fontSize: widget.textFontSize),
                  enabled: widget.enabled,
                  textDirection: widget.textInputType == TextInputType.phone ? TextDirection.ltr : null,
                  focusNode: widget.focusNode,
                  textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
                  keyboardType: widget.textInputType,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  autofocus: widget.autofocus,
                  maxLines: widget.isTextArea ? widget.textAreaLines : 1,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly ?? widget.onTap != null,
                  validator: widget.validator,
                  onFieldSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  decoration: widget.decoration ??
                      InputDecoration(
                        contentPadding: widget.outlinedBorder
                            ? const EdgeInsets.symmetric(horizontal: Paddings.large).copyWith(top: Paddings.extraLarge)
                            : const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                        labelText: widget.labelText,
                        alignLabelWithHint: true,
                        label: widget.enableFloatingLabel ? Text(hintText, style: widget.hintTextStyle ?? AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(200))) : null,
                        border: widget.outlinedBorder
                            ? OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor))
                            : UnderlineInputBorder(borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor)),
                        enabledBorder: widget.outlinedBorder
                            ? OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor))
                            : UnderlineInputBorder(borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor)),
                        focusedBorder: widget.outlinedBorder
                            ? OutlineInputBorder(borderRadius: smallRadius, borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor))
                            : UnderlineInputBorder(borderSide: BorderSide(color: widget.outlinedBorderColor ?? kNeutralLightColor)),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelStyle: widget.hintTextStyle ?? AppFonts.x14Regular.copyWith(height: 0.2),
                        hintText: hintText,
                        hintStyle: widget.hintTextStyle ?? AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(150)),
                        prefixIcon: widget.prefixIcon,
                        constraints: BoxConstraints(maxHeight: widget.height ?? double.infinity),
                        suffixIconConstraints: BoxConstraints(maxHeight: widget.height ?? 40, maxWidth: 50),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                          child: widget.suffixIcon ??
                              (widget.isPassword
                                  ? InkWell(
                                      onTap: () => setState(() => _obscureText = !_obscureText),
                                      child: widget.height != null
                                          ? Icon(
                                              _obscureText ? Icons.visibility : Icons.visibility_off,
                                              size: 0.5 * widget.height!,
                                              color: Theme.of(context).primaryColor,
                                            )
                                          : Icon(
                                              _obscureText ? Icons.visibility : Icons.visibility_off,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                    )
                                  : null),
                        ),
                      ),
                  controller: widget.fieldController,
                  obscureText: _obscureText,
                ),
              ),
            ),
          ),
        ],
      );
}
