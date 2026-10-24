// lib/core/database/tables/epds_results.dart
import 'package:drift/drift.dart';

class EpdsResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get takenAt => dateTime()();
  IntColumn get score => integer()();
  TextColumn get answers => text()();
}
