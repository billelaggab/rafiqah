// lib/features/baby_tracker/presentation/screens/who_growth_screen.dart
import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';

import '../../domain/who_growth.dart';

final babyMeasurementsProvider = StreamProvider<List<BabyMeasurement>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.babyDao.watchMeasurements();
});

class WhoGrowthScreen extends ConsumerStatefulWidget {
  const WhoGrowthScreen({super.key});

  @override
  ConsumerState<WhoGrowthScreen> createState() => _WhoGrowthScreenState();
}

class _WhoGrowthScreenState extends ConsumerState<WhoGrowthScreen> {
  bool _isBoys = true;

  List<FlSpot> _spots(List<WhoGrowth> data, double Function(WhoGrowth) sel) =>
      [for (final d in data) FlSpot(d.month.toDouble(), sel(d))];

  Future<void> _addMeasurement() async {
    final ageController = TextEditingController();
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    final headController = TextEditingController();

    final input =
        await showDialog<({int age, double? weight, double? height, double? head})>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة قياس'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'عمر الطفل بالأشهر (0-12)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'الوزن (كغ) — اختياري',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: heightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'الطول (سم) — اختياري',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: headController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'محيط الرأس (سم) — اختياري',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final age = int.tryParse(ageController.text.trim());
              final weight = double.tryParse(
                weightController.text.trim().replaceAll(',', '.'),
              );
              final height = double.tryParse(
                heightController.text.trim().replaceAll(',', '.'),
              );
              final head = double.tryParse(
                headController.text.trim().replaceAll(',', '.'),
              );
              if (age == null || age < 0 || age > 12) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('أدخلي عمرًا بين 0 و12 شهرًا')),
                );
                return;
              }
              if (weight == null && height == null && head == null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('أدخلي قياسًا واحدًا على الأقل')),
                );
                return;
              }
              Navigator.pop(
                ctx,
                (age: age, weight: weight, height: height, head: head),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (input == null || !mounted) return;

    try {
      await _saveMeasurement(
        age: input.age,
        weight: input.weight,
        height: input.height,
        head: input.head,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ القياس')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر حفظ القياس: $e')),
      );
    }
  }

  Future<void> _saveMeasurement({
    required int age,
    double? weight,
    double? height,
    double? head,
  }) async {
    await ref.read(databaseProvider).babyDao.insertMeasurement(
          BabyMeasurementsCompanion.insert(
            measuredAt: DateTime.now(),
            ageMonths: Value(age),
            weightKg: Value(weight),
            heightCm: Value(height),
            headCm: Value(head),
          ),
        );
  }

  Future<void> _deleteMeasurement(BabyMeasurement measurement) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف القياس'),
        content: Text(
          'حذف قياس عمر ${measurement.ageMonths ?? '?'} شهرًا؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref
          .read(databaseProvider)
          .babyDao
          .deleteMeasurement(measurement.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحذف: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurements = ref.watch(babyMeasurementsProvider);
    final data = _isBoys ? whoBoysWeight : whoGirlsWeight;
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(title: const Text('منحنيات نمو الرضيع (WHO)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('ذكر')),
              ButtonSegment(value: false, label: Text('أنثى')),
            ],
            selected: {_isBoys},
            onSelectionChanged: (selection) =>
                setState(() => _isBoys = selection.first),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 12,
                minY: 0,
                maxY: 15,
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
                      interval: 2,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} ش',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots(data, (d) => d.p3),
                    color: AppColors.primaryLight,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: _spots(data, (d) => d.p50),
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: _spots(data, (d) => d.p97),
                    color: AppColors.primaryLight,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  ...measurements.when(
                    loading: () => <LineChartBarData>[],
                    error: (_, __) => <LineChartBarData>[],
                    data: (list) {
                      final spots = list
                          .where((m) => m.ageMonths != null && m.weightKg != null)
                          .map(
                            (m) => FlSpot(
                              m.ageMonths!.toDouble(),
                              m.weightKg!,
                            ),
                          )
                          .toList()
                        ..sort((a, b) => a.x.compareTo(b.x));
                      if (spots.isEmpty) return <LineChartBarData>[];
                      return [
                        LineChartBarData(
                          spots: spots,
                          color: AppColors.secondary,
                          barWidth: 1,
                          dotData: const FlDotData(show: true),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _Legend(color: AppColors.primaryLight, label: 'المئين 3 و97'),
              _Legend(color: AppColors.primary, label: 'المئين 50'),
              _Legend(color: AppColors.secondary, label: 'قياسات طفلك'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'المنحنيات المرجعية لمنظمة الصحة العالمية للوزن مقابل العمر (0-12 شهرًا). '
            'المئين 50 هو الوسيط؛ القيم بين 3 و97 غالبًا طبيعية، لكن التقييم '
            'يعتمد على نمط النمو الكامل.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addMeasurement,
            icon: const Icon(Icons.add),
            label: const Text('إضافة قياس جديد'),
          ),
          const SizedBox(height: 16),
          Text('قياساتي', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          measurements.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('تعذر تحميل القياسات: $e'),
            data: (list) {
              if (list.isEmpty) {
                return const Text('لا توجد قياسات محفوظة بعد.');
              }
              return Column(
                children: list.reversed.map((m) {
                  final details = <String>[
                    if (m.weightKg != null) '${m.weightKg} كغ',
                    if (m.heightCm != null) '${m.heightCm} سم',
                    if (m.headCm != null) 'محيط الرأس ${m.headCm} سم',
                  ];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        m.ageMonths == null ? '?' : '${m.ageMonths}',
                      ),
                    ),
                    title: Text(
                      m.ageMonths == null
                          ? 'قياس'
                          : 'عمر ${m.ageMonths} شهرًا',
                    ),
                    subtitle: Text(
                      '${dateFormat.format(m.measuredAt.toLocal())}'
                      '${details.isEmpty ? '' : ' • ${details.join(' • ')}'}',
                    ),
                    trailing: IconButton(
                      tooltip: 'حذف',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteMeasurement(m),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 4,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
