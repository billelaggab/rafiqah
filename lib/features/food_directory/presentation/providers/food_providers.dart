// lib/features/food_directory/presentation/providers/food_providers.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';

/// بحث مؤجَّل (debounce) لتجنب إعادة بناء القائمة مع كل حرف.
class FoodSearchNotifier extends Notifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  void updateQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = value;
    });
  }

  void clear() {
    _debounce?.cancel();
    state = '';
  }
}

final foodSearchQueryProvider =
    NotifierProvider<FoodSearchNotifier, String>(FoodSearchNotifier.new);

/// فلتر السلامة: null = الكل، 1 = آمن، 2 = بحذر، 3 = ممنوع.
class FoodFilterNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setFilter(int? value) => state = value;
}

final foodFilterProvider =
    NotifierProvider<FoodFilterNotifier, int?>(FoodFilterNotifier.new);

final foodListProvider = FutureProvider<List<FoodDirectoryData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = ref.watch(foodSearchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(foodFilterProvider);

  final all = await db.foodDao.getAll();
  if (query.isEmpty && filter == null) return all;

  return all.where((food) {
    final matchesQuery = query.isEmpty ||
        food.nameArabic.toLowerCase().contains(query) ||
        food.category.toLowerCase().contains(query);
    final matchesFilter = filter == null || food.safetyLevel == filter;
    return matchesQuery && matchesFilter;
  }).toList();
});
