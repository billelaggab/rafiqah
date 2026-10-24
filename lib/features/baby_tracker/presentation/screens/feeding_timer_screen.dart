// lib/features/baby_tracker/presentation/screens/feeding_timer_screen.dart
import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/constants.dart';

class FeedingTimerScreen extends ConsumerStatefulWidget {
  const FeedingTimerScreen({super.key});

  @override
  ConsumerState<FeedingTimerScreen> createState() => _FeedingTimerScreenState();
}

class _FeedingTimerScreenState extends ConsumerState<FeedingTimerScreen> {
  Timer? _timer;
  DateTime? _startedAt;
  int _seconds = 0;
  String _side = 'left';
  bool _running = false;

  void _toggle() {
    if (_running) {
      _stop();
    } else {
      _startedAt = DateTime.now();
      setState(() {
        _running = true;
        _seconds = 0;
      });
      WakelockPlus.enable();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final start = _startedAt;
        if (start == null) return;
        setState(() {
          _seconds = DateTime.now().difference(start).inSeconds;
        });
      });
    }
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    _startedAt = null;
    WakelockPlus.disable();
    if (mounted) setState(() => _running = false);
  }

  Future<void> _save() async {
    if (_seconds <= 0) return;
    final type = switch (_side) {
      'left' => AppConstants.logFeedLeft,
      'right' => AppConstants.logFeedRight,
      _ => AppConstants.logBottle,
    };
    try {
      await ref.read(databaseProvider).babyDao.insertLog(
            BabyCareLogsCompanion.insert(
              timestamp: DateTime.now(),
              logType: type,
              durationMinutes: Value((_seconds / 60).ceil()),
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ جلسة الرضاعة')),
      );
      _stop();
      setState(() => _seconds = 0);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحفظ: $e')),
      );
    }
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
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
              onSelectionChanged: _running
                  ? null
                  : (selection) => setState(() => _side = selection.first),
            ),
            const SizedBox(height: 32),
            Text(
              _fmt(_seconds),
              style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _running ? 'الشاشة تبقى مضاءة أثناء الجلسة' : 'جاهز للبدء',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggle,
                  child: Text(_running ? 'إيقاف' : 'بدء'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _seconds > 0 ? _save : null,
                  child: const Text('حفظ'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'المدة المسجلة هي مدة الجلسة، وليست كمية الحليب. '
              'يمكنك إضافة كمية الزجاجة من شاشة تتبع الرضيع.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
