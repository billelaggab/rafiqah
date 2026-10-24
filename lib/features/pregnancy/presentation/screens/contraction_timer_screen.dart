// lib/features/pregnancy/presentation/screens/contraction_timer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/services/geo_routing_service.dart';
import 'package:rafiqah/features/pregnancy/presentation/providers/contraction_notifier.dart';

class ContractionTimerScreen extends ConsumerStatefulWidget {
  const ContractionTimerScreen({super.key});

  @override
  ConsumerState<ContractionTimerScreen> createState() =>
      _ContractionTimerScreenState();
}

class _ContractionTimerScreenState extends ConsumerState<ContractionTimerScreen>
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
      ref.read(contractionProvider.notifier).sync();
    }
  }

  String _fmt(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }

  Future<void> _openHospital() async {
    final opened = await GeoRoutingService.openNearby(
      FacilityType.maternityHospital,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح الخرائط. ابحثي يدويًا.')),
      );
    }
  }

  Future<void> _callEmergency() async {
    final opened = await GeoRoutingService.openEmergencyDialer();
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق الهاتف.')),
      );
    }
  }

  Future<void> _end() async {
    try {
      await ref.read(contractionProvider.notifier).endContraction();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر حفظ الانقباضة: $e')),
      );
    }
  }

  Future<void> _reset() async {
    final state = ref.read(contractionProvider);
    if (state.contractions.isEmpty && !state.isContracting) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة التعيين'),
        content: const Text(
          'سيتم مسح الانقباضات من هذه الجلسة فقط. هل تريدين المتابعة؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      ref.read(contractionProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contractionProvider);
    final notifier = ref.read(contractionProvider.notifier);

    ref.listen<bool>(
      contractionProvider.select((s) => s.isContracting),
      (previous, next) {
        if (next) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('مؤقت الانقباضات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'قاعدة 5-1-1: انقباضات كل 5 دقائق، مدة كل انقباضة دقيقة، '
                'لمدة ساعة كاملة. عند تحققها، توجهي للمستشفى.',
              ),
            ),
          ),
          if (state.alert) ...[
            Card(
              color: AppColors.error,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '🔴 تحققت قاعدة 5-1-1 — توجهي للمستشفى',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openHospital,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.error,
                      ),
                      icon: const Icon(Icons.local_hospital),
                      label: const Text('أقرب مستشفى ولادة'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _callEmergency,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      icon: const Icon(Icons.phone),
                      label: const Text('اتصلي بالطوارئ (112)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.isContracting
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: state.isContracting
                      ? AppColors.error
                      : AppColors.primary,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _fmt(state.currentDuration),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    state.isContracting ? 'انقباضة جارية' : 'جاهزة',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: state.isContracting
                ? _end
                : notifier.startContraction,
            style: ElevatedButton.styleFrom(
              backgroundColor: state.isContracting
                  ? AppColors.error
                  : AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              state.isContracting ? 'إنهاء الانقباضة' : 'بدء انقباضة',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _reset,
            child: const Text('إعادة تعيين السجل'),
          ),
          const Divider(height: 32),
          if (state.contractions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'لا توجد انقباضات مسجلة بعد.',
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            Text(
              'الانقباضات (${state.contractions.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...state.contractions.asMap().entries.toList().reversed.map((entry) {
              final c = entry.value;
              final index = entry.key + 1;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.error.withValues(alpha: 0.12),
                  foregroundColor: Colors.black87,
                  child: Text('$index'),
                ),
                title: Text('المدة: ${_fmt(c.durationSeconds)}'),
                subtitle: Text(
                  c.intervalSeconds > 0
                      ? 'الفاصل: ${_fmt(c.intervalSeconds)} — '
                          '${c.startTime.toLocal().toString().split('.').first}'
                      : 'الانقباضة الأولى',
                ),
              );
            }),
          ],
          const SizedBox(height: 16),
          const Text(
            'التطبيق لا يقيّم حالة الجنين ولا يغني عن الفحص الطبي. '
            'إذا كان النزيف أو الألم شديدًا، اتصلي بالطوارئ فورًا.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
