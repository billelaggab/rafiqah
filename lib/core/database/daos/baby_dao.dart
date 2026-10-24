// lib/core/database/daos/baby_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [BabyCareLogs, BabyMeasurements])
class BabyDao extends DatabaseAccessor<AppDatabase> with _$BabyDaoMixin {
  BabyDao(super.db);

  Future<int> insertLog(BabyCareLogsCompanion entry) =>
      into(babyCareLogs).insert(entry);

  Future<List<BabyCareLog>> getLogs() =>
      (select(babyCareLogs)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();

  Stream<List<BabyCareLog>> watchLogs() =>
      (select(babyCareLogs)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch();

  Future<int> deleteLog(int id) =>
      (delete(babyCareLogs)..where((t) => t.id.equals(id))).go();

  Future<int> deleteMeasurement(int id) =>
      (delete(babyMeasurements)..where((t) => t.id.equals(id))).go();

  Future<int> insertMeasurement(BabyMeasurementsCompanion entry) =>
      into(babyMeasurements).insert(entry);

  Future<List<BabyMeasurement>> getMeasurements() =>
      (select(babyMeasurements)
            ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]))
          .get();

  Stream<List<BabyMeasurement>> watchMeasurements() =>
      (select(babyMeasurements)
            ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]))
          .watch();

  Future<int> deleteAll() async {
    await delete(babyCareLogs).go();
    return delete(babyMeasurements).go();
  }
}
