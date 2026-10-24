// lib/core/database/daos/cycle_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [MenstrualLogs])
class CycleDao extends DatabaseAccessor<AppDatabase> with _$CycleDaoMixin {
  CycleDao(super.db);

  Future<int> insertLog(MenstrualLogsCompanion entry) =>
      into(menstrualLogs).insert(entry);

  Future<List<MenstrualLog>> getAllLogs() =>
      (select(menstrualLogs)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Stream<List<MenstrualLog>> watchLogs() =>
      (select(menstrualLogs)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<List<MenstrualLog>> getBbtLogs() =>
      (select(menstrualLogs)
            ..where((t) => t.bbtTemperature.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Stream<List<MenstrualLog>> watchBbtLogs() =>
      (select(menstrualLogs)
            ..where((t) => t.bbtTemperature.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .watch();

  Future<MenstrualLog?> getLogForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    return (select(menstrualLogs)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end))
          ..limit(1))
        .getSingleOrNull();
  }

  /// يسجّل/يحدّث بيانات يوم واحد (بدل تكرار سجلات لنفس اليوم).
  Future<void> upsertDay(
    DateTime day, {
    int? flowIntensity,
    int? painLevel,
    double? bbtTemperature,
    String? symptoms,
  }) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    final existing = await (select(menstrualLogs)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerThanValue(end))
          ..limit(1))
        .getSingleOrNull();

    if (existing == null) {
      await into(menstrualLogs).insert(
        MenstrualLogsCompanion.insert(
          date: start,
          flowIntensity: flowIntensity ?? 0,
          painLevel: Value(painLevel ?? 0),
          bbtTemperature: Value(bbtTemperature),
          symptoms: Value(symptoms),
        ),
      );
    } else {
      await (update(menstrualLogs)..where((t) => t.id.equals(existing.id)))
          .write(
        MenstrualLogsCompanion(
          flowIntensity: flowIntensity == null
              ? const Value.absent()
              : Value(flowIntensity),
          painLevel:
              painLevel == null ? const Value.absent() : Value(painLevel),
          bbtTemperature: bbtTemperature == null
              ? const Value.absent()
              : Value(bbtTemperature),
          symptoms:
              symptoms == null ? const Value.absent() : Value(symptoms),
        ),
      );
    }
  }

  Future<int> deleteLog(int id) =>
      (delete(menstrualLogs)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAll() => delete(menstrualLogs).go();
}
