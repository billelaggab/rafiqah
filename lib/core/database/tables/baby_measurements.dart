// lib/core/database/tables/baby_measurements.dart
import 'package:drift/drift.dart';

class BabyMeasurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get measuredAt => dateTime()();
  IntColumn get ageMonths => integer().nullable()();
  RealColumn get weightKg => real().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get headCm => real().nullable()();
}
