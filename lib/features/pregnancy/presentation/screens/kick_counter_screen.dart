// lib/features/pregnancy/presentation/screens/kick_counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/features/pregnancy/presentation/providers/kick_counter_notifier.dart';

class KickCounterScreen extends ConsumerWidget {
  const KickCounterScreen({super.key});

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kickCounterProvider);
    final notifier = ref.read(kickCounterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('عدّاد ركلات الجنين')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.alerted)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: const Text(
                  '⚠️ لم تُسجَّل 10 ركلات خلال ساعتين. راجعي طبيبك إذا قلقتِ.',
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            Text('الركلات: ${state.count}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('الوقت: ${_fmt(state.elapsedSeconds)}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: notifier.recordKick,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                shape: const CircleBorder(),
              ),
              child: const Text('ركلة', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: notifier.reset, child: const Text('إعادة تعيين')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: notifier.finish, child: const Text('إنهاء وحفظ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}