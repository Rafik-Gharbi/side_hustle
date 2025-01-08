import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ar_ksa.dart';
import 'ar_tn.dart';
import 'en_us.dart';
import 'fr_fr.dart';

class AppLocalization extends Translations {
  final List<Locale> supportedLocal = <Locale>[
    const Locale('en', 'US'),
    const Locale('fr', 'FR'),
    const Locale('ar', 'KSA'),
    const Locale('ar', 'TN'),
  ];

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        'en_US': enUs,
        'fr_FR': frFr,
        'ar_KSA': arKSA,
        'ar_TN': arTN,
      };
}
