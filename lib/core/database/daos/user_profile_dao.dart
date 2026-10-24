// lib/core/database/daos/user_profile_dao.dart
part of '../app_database.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfile?> getProfile() =>
      (select(userProfiles)..limit(1)).getSingleOrNull();

  Stream<UserProfile?> watchProfile() =>
      (select(userProfiles)..limit(1)).watchSingleOrNull();

  Future<int> insertProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  Future<bool> updateProfile(UserProfilesCompanion entry) async {
    if (entry.id.present) {
      return update(userProfiles).replace(entry);
    }
    final current = await getProfile();
    if (current == null) {
      await insertProfile(entry);
      return true;
    }
    await (update(userProfiles)..where((t) => t.id.equals(current.id)))
        .write(entry);
    return true;
  }

  Future<int> deleteAll() => delete(userProfiles).go();

  Future<void> acceptDisclaimer() async {
    final p = await getProfile();
    if (p == null) {
      await insertProfile(UserProfilesCompanion.insert(
        currentMode: '',
        disclaimerAccepted: const Value(true),
      ));
    } else {
      await (update(userProfiles)..where((t) => t.id.equals(p.id)))
          .write(const UserProfilesCompanion(disclaimerAccepted: Value(true)));
    }
  }

  Future<void> completeOnboarding({
    DateTime? lmpDate,
    DateTime? eddDate,
    int? cycleLength,
  }) async {
    final p = await getProfile();
    final values = UserProfilesCompanion(
      onboardingCompleted: const Value(true),
      lmpDate: Value(lmpDate),
      eddDate: Value(eddDate),
      cycleLength: cycleLength == null ? const Value.absent() : Value(cycleLength),
    );
    if (p == null) {
      await insertProfile(UserProfilesCompanion.insert(
        currentMode: '',
        lmpDate: Value(lmpDate),
        eddDate: Value(eddDate),
        cycleLength: cycleLength == null ? const Value(28) : Value(cycleLength),
        onboardingCompleted: const Value(true),
      ));
    } else {
      await (update(userProfiles)..where((t) => t.id.equals(p.id)))
          .write(values);
    }
  }

  Future<void> setMode(String mode) async {
    final p = await getProfile();
    if (p == null) {
      await insertProfile(UserProfilesCompanion.insert(currentMode: mode));
    } else {
      await (update(userProfiles)..where((t) => t.id.equals(p.id)))
          .write(UserProfilesCompanion(currentMode: Value(mode)));
    }
  }
}
