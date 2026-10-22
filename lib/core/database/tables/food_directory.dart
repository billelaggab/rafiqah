// lib/core/database/tables/food_directory.dart
import 'package:drift/drift.dart';

class FoodDirectory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameArabic => text().withLength(min: 2, max: 100)();
  TextColumn get category => text()();
  IntColumn get safetyLevel => integer()();
  TextColumn get reasonMedical => text()();
  TextColumn get pregnancyAdvice => text()();
  TextColumn get postpartumAdvice => text()();
}