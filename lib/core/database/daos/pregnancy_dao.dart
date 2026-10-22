// lib/core/database/daos/pregnancy_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [KickSessions, ContractionLogs])
class PregnancyDao extends DatabaseAccessor<AppDatabase> with _$PregnancyDaoMixin {
  PregnancyDao(super.db);

  Future<int> insertKickSession(KickSessionsCompanion entry) =>
      into(kickSessions).insert(entry);

  Future<List<KickSession>> getKickSessions() =>
      (select(kickSessions)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).get();

  Stream<List<KickSession>> watchKickSessions() =>
      (select(kickSessions)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).watch();

  Future<int> insertContraction(ContractionLogsCompanion entry) =>
      into(contractionLogs).insert(entry);

  Future<List<ContractionLog>> getContractions() =>
      (select(contractionLogs)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).get();

  Stream<List<ContractionLog>> watchContractions() =>
      (select(contractionLogs)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).watch();

  Future<int> deleteAll() async {
    await delete(kickSessions).go();
    return delete(contractionLogs).go();
  }
}
