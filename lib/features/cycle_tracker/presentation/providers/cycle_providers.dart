// lib/features/cycle_tracker/presentation/providers/cycle_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/database/app_database.dart';

final cycleLogsProvider = StreamProvider<List<MenstrualLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.cycleDao.watchLogs();
});