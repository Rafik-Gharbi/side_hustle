import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_platform.dart';

class ImagePickerMobile implements ImagePickerPlatform {
  ImagePickerMobile() {
    ImagePickerPlatform.picker = ImagePicker();
    debugPrint('ImagePickerMobile is initialized');
  }
}

dynamic getPicker() => ImagePicker();
