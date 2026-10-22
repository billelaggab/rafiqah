// lib/features/baby_tracker/presentation/screens/feeding_timer_screen.dart
import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/utils/constants.dart';

class FeedingTimerScreen extends ConsumerStatefulWidget {
  const FeedingTimerScreen({super.key});
  @override
  ConsumerState<FeedingTimerScreen> createState() => _FeedingTimerScreenState();
}

class _FeedingTimerScreenState extends ConsumerState<FeedingTimerScreen> {
  Timer? _timer;
  int _seconds = 0;
  String _side = 'left';
  bool _running = false;

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      setState(() => _running = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _seconds++));
    }
  }

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final type = _side == 'left' ? AppConstants.logFeedLeft : (_side == 'right' ? AppConstants.logFeedRight : AppConstants.logBottle);
    await db.babyDao.insertLog(BabyCareLogsCompanion.insert(
      timestamp: DateTime.now(),
      logType: type,
      durationMinutes: Value(_seconds ~/ 60),
    ));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
    setState(() { _seconds = 0; _running = false; });
    _timer?.cancel();
  }

  String _fmt(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مؤقت الرضاعة')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'left', label: Text('يسار')),
                ButtonSegment(value: 'right', label: Text('يمين')),
                ButtonSegment(value: 'bottle', label: Text('زجاجة')),
              ],
              selected: {_side},
              onSelectionChanged: (s) => setState(() => _side = s.first),
            ),
            const SizedBox(height: 32),
            Text(_fmt(_seconds), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _toggle, child: Text(_running ? 'إيقاف' : 'بدء')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _save, child: const Text('حفظ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
