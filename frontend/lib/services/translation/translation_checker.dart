import 'package:flutter/foundation.dart';

import 'ar_ksa.dart';
import 'ar_tn.dart';
import 'en_us.dart';
import 'fr_fr.dart';

class TranslationChecker {
  static Future<void> checkTranslations() async {
    // List all the keys from each translation
    List<String> enKeys = enUs.keys.toList();
    List<String> frKeys = frFr.keys.toList();
    List<String> arKeys = arKSA.keys.toList();
    List<String> arTNKeys = arTN.keys.toList();

    // Find keys missing in other languages
    List<String> missingInFr = enKeys.where((key) => !frKeys.contains(key)).toList();
    List<String> missingInAr = enKeys.where((key) => !arKeys.contains(key)).toList();
    List<String> missingInArTN = enKeys.where((key) => !arTNKeys.contains(key)).toList();

    // Print the results
    if (missingInFr.isNotEmpty) {
      debugPrint('Missing keys in French: $missingInFr');
    } else {
      debugPrint('No missing keys in French.');
    }

    if (missingInAr.isNotEmpty) {
      debugPrint('Missing keys in Arabic: $missingInAr');
    } else {
      debugPrint('No missing keys in Arabic.');
    }

    if (missingInArTN.isNotEmpty) {
      debugPrint('Missing keys in Arabic TN: $missingInArTN');
    } else {
      debugPrint('No missing keys in Arabic TN.');
    }
  }
}
