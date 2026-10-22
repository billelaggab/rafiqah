// lib/core/database/daos/baby_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [BabyCareLogs])
class BabyDao extends DatabaseAccessor<AppDatabase> with _$BabyDaoMixin {
  BabyDao(super.db);

  Future<int> insertLog(BabyCareLogsCompanion entry) =>
      into(babyCareLogs).insert(entry);

  Future<List<BabyCareLog>> getLogs() =>
      (select(babyCareLogs)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();

  Stream<List<BabyCareLog>> watchLogs() =>
      (select(babyCareLogs)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch();

  Future<int> deleteAll() => delete(babyCareLogs).go();
}
