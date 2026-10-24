// lib/features/mode_selector/data/mode_repository.dart
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/features/mode_selector/domain/app_mode.dart';

class ModeRepository {
  ModeRepository(this._db);
  final AppDatabase _db;

  Future<AppMode> getCurrentMode() async {
    final p = await _db.userProfileDao.getProfile();
    final id = p?.currentMode ?? '';
    return id.isEmpty ? AppMode.pregnancy : AppMode.fromId(id);
  }

  Future<void> setMode(AppMode mode) => _db.userProfileDao.setMode(mode.id);
}
