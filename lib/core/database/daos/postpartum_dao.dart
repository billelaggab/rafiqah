// lib/core/database/daos/postpartum_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [EpdsResults])
class PostpartumDao extends DatabaseAccessor<AppDatabase>
    with _$PostpartumDaoMixin {
  PostpartumDao(super.db);

  Future<int> insertResult(EpdsResultsCompanion entry) =>
      into(epdsResults).insert(entry);

  Future<EpdsResult?> getLatest() => (select(epdsResults)
        ..orderBy([(t) => OrderingTerm.desc(t.takenAt)])
        ..limit(1))
      .getSingleOrNull();

  Stream<List<EpdsResult>> watchResults() => (select(epdsResults)
        ..orderBy([(t) => OrderingTerm.desc(t.takenAt)]))
      .watch();

  Future<int> deleteAll() => delete(epdsResults).go();
}
