// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

import 'image_picker_platform.dart';

class ImagePickerWeb implements ImagePickerPlatform {
  ImagePickerWeb() {
    if (kIsWeb) {
      ImagePickerPlatform.picker = ImagePickerPlugin();
      debugPrint('ImagePickerWeb is initialized');
    }
  }
}

dynamic getPicker() => ImagePickerPlugin();
