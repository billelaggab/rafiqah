// lib/core/database/tables/contraction_logs.dart
import 'package:drift/drift.dart';

class ContractionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get durationSeconds => integer()();
  IntColumn get intervalSeconds => integer()();
  IntColumn get intensity => integer()();
}