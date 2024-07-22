import 'package:drift/drift.dart';
import 'package:image_picker/image_picker.dart';

import '../../database/database.dart';
import '../../networking/api_base_helper.dart';

enum ImageType { image, file }

class ImageDTO {
  final XFile file;
  final ImageType type;

  ImageDTO({required this.file, required this.type});

  factory ImageDTO.fromJson(Map<String, dynamic> json, {bool isStoreImage = false}) => ImageDTO(
        file: XFile(isStoreImage ? ApiBaseHelper.find.getImageStore(json['url'])  : ApiBaseHelper.find.getImageTask(json['url'])),
        type: ImageType.values.singleWhere((element) => element.name == json['type']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['file'] = file.name;
    data['type'] = type;
    return data;
  }

  TaskAttachmentTableCompanion toAttachmentCompanion({int? taskId}) => TaskAttachmentTableCompanion(
        type: Value(type.name),
        url: Value(file.path),
        taskId: Value(taskId),
      );
}
