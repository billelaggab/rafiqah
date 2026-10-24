// lib/features/cycle_tracker/presentation/screens/cycle_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';
import 'package:rafiqah/core/widgets/empty_state.dart';
import 'package:rafiqah/features/cycle_tracker/presentation/providers/cycle_providers.dart';

class CycleTrackerScreen extends ConsumerStatefulWidget {
  const CycleTrackerScreen({super.key});

  @override
  ConsumerState<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends ConsumerState<CycleTrackerScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

  List<MenstrualLog> _bleedingLogs(List<MenstrualLog> logs) =>
      logs.where((l) => l.flowIntensity > 0).toList();

  List<DateTime> _periodStarts(List<MenstrualLog> logs) =>
      MedicalCalculator.periodStarts(
        _bleedingLogs(logs).map((l) => l.date),
      );

  Color? _phaseColor(DateTime day, List<DateTime> starts, int cycleLength) {
    if (starts.isEmpty) return null;
    DateTime? last;
    for (final start in starts) {
      if (!start.isAfter(day)) last = start;
    }
    if (last == null) return null;
    final dayIndex = DateTime.utc(day.year, day.month, day.day)
        .difference(DateTime.utc(last.year, last.month, last.day))
        .inDays;
    if (dayIndex < 0) return null;

    final ovulation = cycleLength - 14;
    if (dayIndex < 5) return AppColors.periodRed;
    if (dayIndex >= ovulation - 5 && dayIndex <= ovulation + 1) {
      return AppColors.ovulationGreen;
    }
    if (dayIndex < ovulation - 5) return AppColors.follicularYellow;
    return AppColors.lutealBlue;
  }

  Future<int?> _pickFlow() {
    return showDialog<int>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('شدة التدفق'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 1),
            child: const Text('خفيف'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 2),
            child: const Text('متوسط'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 3),
            child: const Text('غزير'),
          ),
        ],
      ),
    );
  }

  Future<void> _recordPeriod() async {
    final day = _selected ?? DateTime.now();
    final flow = await _pickFlow();
    if (flow == null || !mounted) return;
    try {
      await ref.read(databaseProvider).cycleDao.upsertDay(
            day,
            flowIntensity: flow,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تسجيل ${_dateFormat.format(day)}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحفظ: $e')),
      );
    }
  }

  Future<void> _recordBbt() async {
    final day = _selected ?? DateTime.now();
    final existing = await ref.read(databaseProvider).cycleDao.getLogForDay(day);
    if (!mounted) return;
    final controller = TextEditingController(
      text: existing?.bbtTemperature?.toStringAsFixed(2) ?? '',
    );
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حرارة الجسم القاعدية — ${_dateFormat.format(day)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
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
    if (value == null || !mounted) return;
    try {
      await ref.read(databaseProvider).cycleDao.upsertDay(
            day,
            bbtTemperature: value,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ درجة الحرارة')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحفظ: $e')),
      );
    }
  }

  Future<void> _delete(MenstrualLog log) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف السجل'),
        content: Text('حذف سجل ${_dateFormat.format(log.date)}؟'),
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
      await ref.read(databaseProvider).cycleDao.deleteLog(log.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحذف: $e')),
      );
    }
  }

  Future<void> _export(List<MenstrualLog> logs) async {
    final buffer = StringBuffer('date,flow,pain,bbt\n');
    for (final log in logs) {
      buffer.writeln(
        '${_dateFormat.format(log.date)},${log.flowIntensity},'
        '${log.painLevel},${log.bbtTemperature ?? ''}',
      );
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ السجل إلى الحافظة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(cycleLogsProvider);
    return logsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('تعذر تحميل السجل: $e')),
      data: (logs) {
        final bleeding = _bleedingLogs(logs);
        final starts = _periodStarts(logs);
        final average = MedicalCalculator.averageCycleLength(starts);
        DateTime? next;
        if (starts.isNotEmpty) {
          final today = DateTime.now();
          var candidate = DateTime(
            starts.last.year,
            starts.last.month,
            starts.last.day + average,
          );
          // نتجاوز التواريخ الماضية إن كانت آخر دورة قديمة.
          while (candidate.isBefore(
            DateTime(today.year, today.month, today.day),
          )) {
            candidate = DateTime(
              candidate.year,
              candidate.month,
              candidate.day + average,
            );
          }
          next = candidate;
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _HeaderCard(
              nextPeriod: next,
              averageCycle: average,
              dateFormat: _dateFormat,
            ),
            TableCalendar(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2035, 12, 31),
              focusedDay: _focused,
              enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
              selectedDayPredicate: (d) => isSameDay(_selected, d),
              onDaySelected: (selected, focused) => setState(() {
                _selected = selected;
                _focused = focused;
              }),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'شهر'},
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (ctx, day, _) {
                  final color = _phaseColor(day, starts, average);
                  if (color == null) return null;
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                _Legend(color: AppColors.periodRed, label: 'حيض'),
                _Legend(color: AppColors.follicularYellow, label: 'جريبية'),
                _Legend(color: AppColors.ovulationGreen, label: 'خصوبة'),
                _Legend(color: AppColors.lutealBlue, label: 'أصفريه'),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _recordPeriod,
                      icon: const Icon(Icons.water_drop),
                      label: const Text('تسجيل الحيض'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'تسجيل حرارة الجسم',
                    onPressed: _recordBbt,
                    icon: const Icon(Icons.thermostat),
                  ),
                  IconButton(
                    tooltip: 'نسخ السجل',
                    onPressed: logs.isEmpty ? null : () => _export(logs),
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            if (logs.isEmpty)
              const EmptyState(
                icon: Icons.calendar_month,
                message: 'لا توجد سجلات بعد — سجّلي أول يوم من دورتك',
              )
            else
              ...logs.map(
                (log) => ListTile(
                  onLongPress: () => _delete(log),
                  leading: CircleAvatar(
                    backgroundColor: log.flowIntensity > 0
                        ? AppColors.periodRed
                        : AppColors.lutealBlue,
                    foregroundColor: Colors.black87,
                    child: Text('${log.date.day}'),
                  ),
                  title: Text(_dateFormat.format(log.date)),
                  subtitle: Text(
                    [
                      log.flowIntensity > 0
                          ? 'التدفق: ${_flowLabel(log.flowIntensity)}'
                          : 'بدون نزيف',
                      if (log.painLevel > 0) 'الألم: ${log.painLevel}/3',
                      if (log.bbtTemperature != null)
                        'BBT: ${log.bbtTemperature}°C',
                    ].join(' • '),
                  ),
                  trailing: IconButton(
                    tooltip: 'حذف',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(log),
                  ),
                ),
              ),
            if (bleeding.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'ملاحظة: الأيام المسجّلة كبداية دورة تُستخدم لحساب متوسط طول '
                  'الدورة ونافذة الخصوبة. استخدمي الضغط المطوّل للحذف.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  String _flowLabel(int value) => switch (value) {
        1 => 'خفيف',
        2 => 'متوسط',
        3 => 'غزير',
        _ => 'غير محدد',
      };
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.nextPeriod,
    required this.averageCycle,
    required this.dateFormat,
  });

  final DateTime? nextPeriod;
  final int averageCycle;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'متوسط طول الدورة: $averageCycle يومًا',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              nextPeriod == null
                  ? 'سجّلي أول يوم من دورتك لبدء التوقعات'
                  : 'الدورة القادمة: ${dateFormat.format(nextPeriod!)}',
            ),
          ],
        ),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
