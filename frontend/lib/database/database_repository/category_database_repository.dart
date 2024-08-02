import 'package:get/get.dart';

import '../../models/category.dart';
import '../../services/logger_service.dart';
import '../database.dart';

class CategoryDatabaseRepository extends GetxService {
  static CategoryDatabaseRepository get find => Get.find<CategoryDatabaseRepository>();
  final Database database = Database.getInstance();

  Future<List<Category>> select() async {
    List<CategoryTableData> result = await database.select(database.categoryTable).get();
    List<Category> categories = result.map((e) => Category.fromCategoryData(category: e)).toList();

    return categories;
  }

  Future<Category?> getCategoryById(int categoryId) async {
    try {
      final CategoryTableData category = (await (database.select(database.categoryTable)..where((tbl) => tbl.id.equals(categoryId))).get()).first;
      return Category.fromCategoryData(category: category);
    } catch (e) {
      LoggerService.logger?.e(e);
      return null;
    }
  }

  Future<int> delete(Category category) async => await database.delete(database.categoryTable).delete(category.toCategoryCompanion());

  Future<int> deleteAll() async => await database.delete(database.categoryTable).go();

  Future<void> update(CategoryTableCompanion categoryCompanion) async => await database.update(database.categoryTable).replace(categoryCompanion);

  Future<Category?> insert(CategoryTableCompanion categoryCompanion) async {
    final int categoryId = await database.into(database.categoryTable).insert(categoryCompanion);
    final categoryCategory = await getCategoryById(categoryId);
    return categoryCategory;
  }

  Future<void> backupCategories(List<Category> categories) async {
    LoggerService.logger?.i('Backing up categories...');
    await deleteAll();
    for (var element in categories) {
      await insert(element.toCategoryCompanion());
    }
  }
}
