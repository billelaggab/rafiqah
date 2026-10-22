// lib/core/database/tables/menstrual_logs.dart
import 'package:drift/drift.dart';

class MenstrualLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get flowIntensity => integer()();
  IntColumn get painLevel => integer().withDefault(const Constant(0))();
  RealColumn get bbtTemperature => real().nullable()();
  TextColumn get symptoms => text().nullable()();
}