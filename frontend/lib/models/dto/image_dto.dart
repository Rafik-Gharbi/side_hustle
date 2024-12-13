import 'package:drift/drift.dart';
import 'package:image_picker/image_picker.dart';

import '../../database/database.dart';
import '../../helpers/helper.dart';
import '../../networking/api_base_helper.dart';

enum ImageType { image, file }

class ImageDTO {
  final XFile file;
  final ImageType type;

  ImageDTO({required this.file, required this.type});

  factory ImageDTO.fromJson(Map<String, dynamic> json, {String? path}) => ImageDTO(
        file: XFile(path ?? ApiBaseHelper.find.getUserImage(json['url'])),
        type: ImageType.values.singleWhere((element) => element.name == json['type']),
      );

  factory ImageDTO.fromXFile(XFile file) => ImageDTO(
        file: file,
        type: file.mimeType != null
            ? ImageType.values.singleWhere((element) => element.name == file.mimeType)
            : Helper.isImage(file.name)
                ? ImageType.image
                : ImageType.file,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['file'] = file.name;
    data['type'] = type;
    return data;
  }

  TaskAttachmentTableCompanion toAttachmentCompanion({String? taskId}) => TaskAttachmentTableCompanion(
        type: Value(type.name),
        url: Value(file.path),
        taskId: Value(taskId),
      );

  ServiceGalleryTableCompanion toGalleryCompanion({String? serviceId}) => ServiceGalleryTableCompanion(
        type: Value(type.name),
        url: Value(file.path),
        serviceId: Value(serviceId),
      );
}
