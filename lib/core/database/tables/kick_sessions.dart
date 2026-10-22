// lib/core/database/tables/kick_sessions.dart
import 'package:drift/drift.dart';

class KickSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get kickCount => integer()();
  IntColumn get durationSeconds => integer()();
}