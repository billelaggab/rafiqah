// lib/core/database/daos/food_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [FoodDirectory])
class FoodDao extends DatabaseAccessor<AppDatabase> with _$FoodDaoMixin {
  FoodDao(super.db);

  Future<List<FoodDirectoryData>> search(String query) {
    final q = select(foodDirectory)
      ..where((t) => t.nameArabic.like('%$query%'))
      ..orderBy([(t) => OrderingTerm.asc(t.nameArabic)]);
    return q.get();
  }

  Future<List<FoodDirectoryData>> getBySafety(int level) =>
      (select(foodDirectory)..where((t) => t.safetyLevel.equals(level))).get();

  Future<List<FoodDirectoryData>> getAll() =>
      (select(foodDirectory)..orderBy([(t) => OrderingTerm.asc(t.nameArabic)])).get();

  Future<int> count() async {
    final c = countAll();
    final q = selectOnly(foodDirectory)..addColumns([c]);
    final row = await q.getSingle();
    return row.read(c) ?? 0;
  }

  Future<void> seed(List<Map<String, dynamic>> foods) async {
    await batch((b) {
      for (final f in foods) {
        b.insert(
          foodDirectory,
          FoodDirectoryCompanion.insert(
            nameArabic: f['nameArabic'] as String,
            category: f['category'] as String,
            safetyLevel: f['safetyLevel'] as int,
            reasonMedical: f['reasonMedical'] as String,
            pregnancyAdvice: f['pregnancyAdvice'] as String,
            postpartumAdvice: f['postpartumAdvice'] as String,
          ),
        );
      }
    });
  }
}
