import 'package:get/get.dart';
import 'package:validators/validators.dart';

import '../constants/constants.dart';

class FormValidators {
  static String? notNullObjectValidator(Object? value) => value == null ? 'field_not_empty'.tr : null;

  static String? notEmptyOrNullValidator(String? value) => value == null || value.toLowerCase().trim().isEmpty ? 'field_not_empty'.tr : null;

  static String? notEmptyOrNullIntValidator(String? value) => notEmptyOrNullValidator(value) ?? (!isInt(value!) ? 'invalid_number'.tr : null);

  static String? notEmptyOrNullFloatValidator(String? value) => notEmptyOrNullValidator(value) ?? (!isFloat(value!) ? 'must_be_number'.tr : null);

  static String? requiredFloatLessThanValidator(String? value, double max) =>
      notEmptyOrNullValidator(value) ?? (!isFloat(value!) ? 'must_be_number'.tr : null) ?? (double.parse(value!) > max ? 'max_value_is'.trParams({'value': max.toString()}) : null);

  static String? emailValidator(String? value) => (value?.isEmpty ?? true)
      ? 'email_required'.tr
      : isEmail(value!)
          ? null
          : 'email_invalid'.tr;

  static String? phoneNumberValidator(String? value, {String? phonePrefix}) {
    if (phonePrefix != null && (value?.startsWith(phonePrefix) ?? false)) value = value!.substring(value.indexOf(phonePrefix) + phonePrefix.length);
    return value == null || value.isEmpty
        ? 'phone_required'.tr
        : RegExp(phoneRegex).hasMatch((phonePrefix ?? '') + value.replaceAll(' ', ''))
            ? null
            : 'phone_invalid'.tr;
  }

  static String? passwordValidator(String? value, {String? currentPassword}) => currentPassword != null && currentPassword.isNotEmpty && currentPassword == value
      ? 'diffrent_new_password'.tr
      : minNumberOfCharsValidator(value, minPasswordNumberOfCharacters);

  static String? minNumberOfCharsValidator(String? value, int N, {bool isNumber = false}) =>
      (isNumber ? notEmptyOrNullFloatValidator(value) : notEmptyOrNullValidator(value)) ?? (value!.length < N ? 'field_should_include'.trParams({'number': N.toString()}) : null);

  static String? exactNumberOfIntValidator(String? value, int N, {bool isNumber = false}) =>
      (isNumber ? notEmptyOrNullIntValidator(value) : notEmptyOrNullValidator(value)) ?? (value!.length != N ? 'field_length_exact'.trParams({'number': N.toString()}) : null);

  static String? confirmPasswordValidator(String? value, String? newPassword) => notEmptyOrNullValidator(value) ?? (value != newPassword ? 'invalid_confirmation'.tr : null);
}
