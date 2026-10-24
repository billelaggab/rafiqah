// lib/features/ttc/presentation/screens/ttc_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/providers/profile_provider.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';
import 'package:rafiqah/core/widgets/empty_state.dart';
import 'package:rafiqah/features/cycle_tracker/presentation/providers/cycle_providers.dart';

import 'bbt_chart_screen.dart';

class TtcScreen extends ConsumerWidget {
  const TtcScreen({super.key});

  int _daysBetween(DateTime a, DateTime b) => DateTime.utc(a.year, a.month, a.day)
      .difference(DateTime.utc(b.year, b.month, b.day))
      .inDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final logsAsync = ref.watch(cycleLogsProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('تعذر تحميل البيانات: $e')),
      data: (profile) {
        final logs = logsAsync.valueOrNull ?? const [];
        final bleedingDays = logs
            .where((l) => l.flowIntensity > 0)
            .map((l) => l.date)
            .toList();
        final starts = MedicalCalculator.periodStarts(bleedingDays);
        if (profile?.lmpDate != null) {
          starts.add(profile!.lmpDate!);
        }
        starts.sort();

        if (starts.isEmpty) {
          return const EmptyState(
            icon: Icons.thermostat,
            message: 'سجّلي أول يوم من دورتك أو أضيفي تاريخ آخر دورة '
                'من الإعدادات لحساب نافذة الخصوبة.',
          );
        }

        final cycleLength = profile?.cycleLength ?? 28;
        final average = MedicalCalculator.averageCycleLength(
          starts,
          fallback: cycleLength,
        );
        final today = DateTime.now();
        var cycleStart = starts.last;
        // إذا كانت آخر دورة قديمة، ننتقل للدورة المتوقعة التالية.
        while (_daysBetween(today, cycleStart) > average) {
          cycleStart = DateTime(
            cycleStart.year,
            cycleStart.month,
            cycleStart.day + average,
          );
        }

        final window = MedicalCalculator.calculateFertileWindow(
          periodStartDate: cycleStart,
          cycleLength: average,
        );
        final isPast = window.fertileEnd.isBefore(
          DateTime(today.year, today.month, today.day),
        );
        final nextWindow = isPast
            ? MedicalCalculator.calculateFertileWindow(
                periodStartDate: DateTime(
                  cycleStart.year,
                  cycleStart.month,
                  cycleStart.day + average,
                ),
                cycleLength: average,
              )
            : null;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دورتك الحالية',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('متوسط طول الدورة: $average يومًا'),
                    Text('بداية الدورة الحالية: ${dateFormat.format(cycleStart)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (nextWindow != null)
              Card(
                color: AppColors.warning.withValues(alpha: 0.08),
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.warning),
                  title: const Text('انتهت نافذة الخصوبة لهذه الدورة'),
                  subtitle: Text(
                    'النافذة المتوقعة القادمة: '
                    '${dateFormat.format(nextWindow.fertileStart)} '
                    '→ ${dateFormat.format(nextWindow.fertileEnd)}',
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نافذة الخصوبة المتوقعة',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${dateFormat.format(window.fertileStart)} '
                        '→ ${dateFormat.format(window.fertileEnd)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يوم التبويض المتوقع: '
                        '${dateFormat.format(window.ovulationDay)}',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نصائح للتخطيط للحمل',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text('• ابدئي بحمض الفوليك 400 ميكروغرام يوميًا'),
                    Text('• تجنبي التدخين والكحول'),
                    Text('• حافظي على نوم منتظم وتقليل التوتر'),
                    Text('• لا تعتمدي على تطبيقات تحديد جنس الجنين — لا أساس علمي لها'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BbtChartScreen()),
              ),
              icon: const Icon(Icons.show_chart),
              label: const Text('متابعة حرارة الجسم القاعدية (BBT)'),
            ),
            const SizedBox(height: 8),
            const Text(
              'التوقعات إرشادية فقط ولا تُغني عن متابعة الطبيبة، خصوصًا إذا '
              'كانت دورتك غير منتظمة.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
