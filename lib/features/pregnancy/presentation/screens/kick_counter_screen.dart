// lib/features/pregnancy/presentation/screens/kick_counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/utils/constants.dart';
import 'package:rafiqah/features/pregnancy/presentation/providers/kick_counter_notifier.dart';

class KickCounterScreen extends ConsumerStatefulWidget {
  const KickCounterScreen({super.key});

  @override
  ConsumerState<KickCounterScreen> createState() => _KickCounterScreenState();
}

class _KickCounterScreenState extends ConsumerState<KickCounterScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(kickCounterProvider.notifier).sync();
    }
  }

  String _fmt(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }

  Future<void> _finish() async {
    try {
      await ref.read(kickCounterProvider.notifier).finish();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الجلسة')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر حفظ الجلسة: $e')),
      );
    }
  }

  Future<void> _reset() async {
    final state = ref.read(kickCounterProvider);
    if (state.count == 0 && !state.running) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة التعيين'),
        content: const Text('سيتم مسح العدّاد الحالي دون حفظه. هل تريدين المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      ref.read(kickCounterProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kickCounterProvider);
    final notifier = ref.read(kickCounterProvider.notifier);

    ref.listen<bool>(
      kickCounterProvider.select((s) => s.running),
      (previous, next) {
        if (next) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('عدّاد ركلات الجنين')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'استلقي على جانبك الأيسر، وركّزي على حركة الجنين. '
                'الهدف: ${AppConstants.kickTarget} ركلات خلال ساعتين. '
                'إذا لم تشعري بالحركة المعتادة، راجعي طبيبتك فورًا.',
              ),
            ),
          ),
          if (state.alerted)
            Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '⚠️ لم تُسجَّل ${AppConstants.kickTarget} ركلات خلال ساعتين. '
                  'هذا لا يعني بالضرورة وجود مشكلة، لكن راجعي طبيبتك اليوم.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.alerted
                    ? AppColors.warning.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: state.alerted ? AppColors.warning : AppColors.primary,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.count}',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'من ${AppConstants.kickTarget} ركلات',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _fmt(state.elapsedSeconds),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: notifier.recordKick,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: const Text(
              'سجّلي ركلة',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: const Text('إعادة تعيين'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.count > 0 ? _finish : null,
                  child: const Text('إنهاء وحفظ'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا يُستخدم هذا العدّاد لتشخيص حالة الجنين. القرار الطبي يعتمد على '
            'تقييم الطبيبة والمراقبة السريرية.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
