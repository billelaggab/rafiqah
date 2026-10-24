// lib/features/ttc/presentation/screens/bbt_chart_screen.dart
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/widgets/empty_state.dart';

final bbtLogsProvider = StreamProvider<List<MenstrualLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.cycleDao.watchBbtLogs();
});

class BbtChartScreen extends ConsumerWidget {
  const BbtChartScreen({super.key});

  int _daysBetween(DateTime a, DateTime b) =>
      DateTime.utc(a.year, a.month, a.day)
          .difference(DateTime.utc(b.year, b.month, b.day))
          .inDays;

  Future<void> _recordBbt(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل حرارة اليوم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'الدرجة (°C)',
                hintText: 'مثال: 36.55',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تُقاس صباحًا قبل النهوض من السرير وبعد 3 ساعات نوم متواصل على الأقل.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              if (parsed == null || parsed < 35 || parsed > 42) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('أدخلي درجة بين 35 و42')),
                );
                return;
              }
              Navigator.pop(ctx, parsed);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (value == null || !context.mounted) return;
    try {
      await ref.read(databaseProvider).cycleDao.upsertDay(
            DateTime.now(),
            bbtTemperature: value,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ درجة الحرارة')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحفظ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(bbtLogsProvider);
    final dateFormat = DateFormat('MM/dd');

    return Scaffold(
      appBar: AppBar(title: const Text('حرارة الجسم القاعدية (BBT)')),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('تعذر تحميل القراءات: $e')),
        data: (logs) {
          if (logs.isEmpty) {
            return EmptyState(
              icon: Icons.thermostat,
              message: 'لا توجد قراءات BBT بعد.\n'
                  'سجّلي حرارة الصباح يوميًا لرؤية نمط التبويض.',
              action: ElevatedButton.icon(
                onPressed: () => _recordBbt(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('تسجيل قراءة اليوم'),
              ),
            );
          }

          final temps = logs.map((l) => l.bbtTemperature!).toList();
          final minTemp = temps.reduce((a, b) => a < b ? a : b) - 0.1;
          final maxTemp = temps.reduce((a, b) => a > b ? a : b) + 0.1;
          final first = logs.first.date;
          final maxX = _daysBetween(logs.last.date, first).toDouble();
          final step = math.max(1, (maxX / 4).ceil()).toInt();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 280,
                child: LineChart(
                  LineChartData(
                    minX: -0.5,
                    maxX: maxX + 0.5,
                    minY: minTemp,
                    maxY: maxTemp,
                    borderData: FlBorderData(show: true),
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final day = value.round();
                            if (day < 0 || day > maxX || day % step != 0) {
                              return const SizedBox.shrink();
                            }
                            final date =
                                DateTime(first.year, first.month, first.day + day);
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                dateFormat.format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (final log in logs)
                            FlSpot(
                              _daysBetween(log.date, first).toDouble(),
                              log.bbtTemperature!,
                            ),
                        ],
                        isCurved: false,
                        color: AppColors.primary,
                        barWidth: 2,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _recordBbt(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('تسجيل قراءة اليوم'),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'كيف تقرأين الرسم؟',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ارتفاع بسيط وثابت في الحرارة (حوالي 0.3°C) بعد التبويض '
                        'يشير إلى أن التبويض حدث. القراءة الواحدة لا تكفي؛ '
                        'نحتاج عدة أيام متتالية.',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'هذه القراءات لأغراض الوعي بالخصوبة وليست وسيلة منع حمل '
                        'موثوقة.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'القراءات المسجلة (${logs.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...logs.reversed.map(
                (log) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.thermostat),
                  title: Text('${log.bbtTemperature!.toStringAsFixed(2)} °C'),
                  subtitle: Text(
                    DateFormat('yyyy/MM/dd').format(log.date),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
