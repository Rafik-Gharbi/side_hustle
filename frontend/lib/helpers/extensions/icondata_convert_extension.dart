import 'package:flutter/material.dart';

import '../../constants/icon_map.dart';
import '../../services/logger_service.dart';

extension IconDataConvertor on String {
  IconData getIconData() {
    try {
      return materialSymbolsMap.values.singleWhere((element) => element.codePoint == int.parse(this) && element.fontFamily == 'MaterialSymbolsRounded');
    } catch (e) {
      try {
        return IconData(int.parse(this), fontFamily: 'MaterialIcons');
      } catch (e) {
        LoggerService.logger?.e('Error parsing: $e');
        return Icons.error;
      }
    }
  }
}
