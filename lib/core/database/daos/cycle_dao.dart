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

  Future<int> deleteAll() => delete(menstrualLogs).go();
}
