// lib/core/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';

/// الملف الشخصي المباشر (Stream) — مصدر واحد لكل الشاشات.
final profileProvider = StreamProvider<UserProfile?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.userProfileDao.watchProfile();
});
