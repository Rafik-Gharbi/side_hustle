import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'en_us.dart';
import 'fr_fr.dart';

class AppLocalization extends Translations {
  final List<Locale> supportedLocal = <Locale>[
    const Locale('en', 'US'),
    const Locale('fr', 'FR'),
  ];

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en_US': enUs,
        'fr_FR': frFr,
      };
}
