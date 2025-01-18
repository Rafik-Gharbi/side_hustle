import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/helper.dart';
import '../../../services/theme/theme.dart';
import '../../../services/translation/app_localization.dart';

class LanguageSelector extends StatefulWidget {
  final Locale? selectedLocale;
  const LanguageSelector({super.key, this.selectedLocale });

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  Locale _current = const Locale('en', 'US');

  @override
  void initState() {
    _current = widget.selectedLocale ?? Get.locale ?? const Locale('en', 'US');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context);
  }

  List<Widget> _languageItems() {
    List<Widget> list = [];
    for (final locale in AppLocalization().supportedLocal) {
      list.add(
        ListTile(
          title: Text(Helper.getReadableLanguage(locale.languageCode, locale.countryCode)),
          trailing: _current == locale ? const Icon(Icons.check, color: Colors.green) : null,
          selected: _current == locale,
          onTap: () {
            Get.back();
            _current = locale;
            MainAppController.find.changeLanguage(lang: _current);
            setState(() {});
          },
        ),
      );
    }

    return list;
  }

  Widget _buildTiles(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(color: kNeutralColor100, borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusSize.extraLarge))),
        child: Padding(
          padding: const EdgeInsets.all(Paddings.exceptional),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('supported_languages'.tr, style: AppFonts.x16Bold),
                const SizedBox(height: Paddings.regular),
                ..._languageItems(),
              ],
            ),
          ),
        ),
      );
}
