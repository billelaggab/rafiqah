// lib/core/database/daos/user_profile_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase> with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfile?> getProfile() =>
      (select(userProfiles)..limit(1)).getSingleOrNull();

  Stream<UserProfile?> watchProfile() =>
      (select(userProfiles)..limit(1)).watchSingleOrNull();

  Future<int> insertProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  Future<bool> updateProfile(UserProfilesCompanion entry) =>
      update(userProfiles).replace(entry);

  Future<int> deleteAll() => delete(userProfiles).go();

  Future<void> acceptDisclaimer() async {
    final p = await getProfile();
    if (p == null) {
      await insertProfile(UserProfilesCompanion.insert(
        currentMode: 'pregnancy',
        disclaimerAccepted: const Value(true),
      ));
    } else {
      await (update(userProfiles)..where((t) => t.id.equals(p.id)))
          .write(const UserProfilesCompanion(disclaimerAccepted: Value(true)));
    }
  }
}
