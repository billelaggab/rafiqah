// lib/features/food_directory/presentation/providers/food_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/database/app_database.dart';

final foodSearchQueryProvider = StateProvider<String>((ref) => '');

final foodListProvider = FutureProvider<List<FoodDirectoryData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final q = ref.watch(foodSearchQueryProvider);
  if (q.trim().isEmpty) return db.foodDao.getAll();
  return db.foodDao.search(q.trim());
});