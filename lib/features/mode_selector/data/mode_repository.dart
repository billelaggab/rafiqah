// lib/features/mode_selector/data/mode_repository.dart
import 'package:rafiqah/core/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';

class ModeRepository {
  ModeRepository(this._db);
  final AppDatabase _db;

  Future<AppMode> getCurrentMode() async {
    final p = await _db.userProfileDao.getProfile();
    return AppMode.fromId(p?.currentMode ?? 'pregnancy');
  }

  Future<void> setMode(AppMode mode) async {
    final p = await _db.userProfileDao.getProfile();
    if (p == null) {
      await _db.userProfileDao.insertProfile(
        UserProfilesCompanion.insert(currentMode: mode.id),
      );
    } else {
      await (_db.update(_db.userProfiles)..where((t) => t.id.equals(p.id)))
          .write(UserProfilesCompanion(currentMode: Value(mode.id)));
    }
  }
}
