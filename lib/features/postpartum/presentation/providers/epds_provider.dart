// lib/features/postpartum/presentation/providers/epds_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';

final epdsHistoryProvider = StreamProvider<List<EpdsResult>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.postpartumDao.watchResults();
});
