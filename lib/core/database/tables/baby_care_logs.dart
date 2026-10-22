// lib/core/database/tables/baby_care_logs.dart
import 'package:drift/drift.dart';

class BabyCareLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get logType => text()();
  IntColumn get durationMinutes => integer().nullable()();
  RealColumn get amountMl => real().nullable()();
  TextColumn get diaperStatus => text().nullable()();
}