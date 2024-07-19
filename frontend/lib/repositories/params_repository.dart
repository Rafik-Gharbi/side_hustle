import 'package:get/get.dart';

import '../models/category.dart';
import '../models/governorate.dart';
import '../networking/api_base_helper.dart';
import '../services/logger_service.dart';

class ParamsRepository extends GetxService {
  static ParamsRepository get find => Get.find<ParamsRepository>();

  Future<List<Governorate>?> getAllGovernorates() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/params/governorates');
      return (result['governorates'] as List).map((e) => Governorate.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllGovernorates:\n$e');
    }
    return null;
  }

  Future<List<Category>?> getAllCategories() async {
    try {
      final result = await ApiBaseHelper().request(RequestType.get, '/params/categories');
      return (result['categories'] as List).map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      LoggerService.logger?.e('Error occured in getAllCategories:\n$e');
    }
    return null;
  }
}
