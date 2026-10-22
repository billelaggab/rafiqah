// lib/features/baby_tracker/presentation/screens/baby_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/app_database.dart';

final babyLogsProvider = StreamProvider<List<BabyCareLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.babyDao.watchLogs();
});

class BabyTrackerScreen extends ConsumerWidget {
  const BabyTrackerScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(babyLogsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الرضيع')),
      body: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(list[i].logType),
            subtitle: Text(list[i].timestamp.toLocal().toString()),
            trailing: list[i].durationMinutes != null
                ? Text('${list[i].durationMinutes} د')
                : null,
          ),
        ),
      ),
    );
  }
}