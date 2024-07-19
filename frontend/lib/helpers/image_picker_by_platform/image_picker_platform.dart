import 'image_picker_stub.dart' // Stub implementation
    if (dart.library.io) 'image_picker_mobile.dart' // dart:io implementation - you can import dart:io in this file.
    if (dart.library.html) 'image_picker_web.dart'; // dart:html implementation - you can import dart:html in this file

abstract class ImagePickerPlatform {
  static late dynamic picker;

  static void init() => picker = getPicker();

  static dynamic getPlatformPicker() {
    init();
    return picker;
  }
}
