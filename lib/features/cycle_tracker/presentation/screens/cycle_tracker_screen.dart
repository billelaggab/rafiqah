// lib/features/cycle_tracker/presentation/screens/cycle_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';
import 'package:rafiqah/features/cycle_tracker/presentation/providers/cycle_providers.dart';

class CycleTrackerScreen extends ConsumerStatefulWidget {
  const CycleTrackerScreen({super.key});

  @override
  ConsumerState<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends ConsumerState<CycleTrackerScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  int _avgCycle = 28;

  List<DateTime> _periodStarts(List<MenstrualLog> logs) {
    // distinct dates sorted
    final dates = logs.map((l) => DateTime(l.date.year, l.date.month, l.date.day)).toSet().toList()
      ..sort();
    return dates;
  }

  Color? _phaseColor(DateTime day, List<DateTime> starts) {
    if (starts.isEmpty) return null;
    // find most recent period start on or before day
    DateTime? last;
    for (final s in starts) {
      if (!s.isAfter(day)) last = s;
    }
    if (last == null) return null;
    final diff = day.difference(last).inDays % _avgCycle;
    if (diff < 5) return Colors.red.shade200; // menstruation
    if (diff < 13) return Colors.yellow.shade200; // follicular
    if (diff == 13 || diff == 14) return Colors.green.shade200; // ovulation
    return Colors.blue.shade200; // luteal
  }

  Future<void> _addLog() async {
    final db = ref.read(databaseProvider);
    await db.cycleDao.insertLog(MenstrualLogsCompanion.insert(
      date: _selected ?? DateTime.now(),
      flowIntensity: 2,
    ));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التسجيل')));
  }

  Future<void> _export(List<MenstrualLog> logs) async {
    final buf = StringBuffer();
    for (final l in logs) {
      buf.writeln('${l.date.toLocal().toString().split(' ').first} — شدة: ${l.flowIntensity}');
    }
    await Clipboard.setData(ClipboardData(text: buf.toString()));
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ السجل للحافظة')));
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(cycleLogsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('متابعة الدورة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              final logs = logsAsync.valueOrNull ?? [];
              _export(logs);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          logsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (logs) {
              final starts = _periodStarts(logs);
              if (starts.length >= 2) {
                final gaps = <int>[];
                for (int i = 1; i < starts.length; i++) {
                  gaps.add(starts[i].difference(starts[i - 1]).inDays);
                }
                _avgCycle = (gaps.reduce((a, b) => a + b) / gaps.length).round();
              }
              DateTime? next;
              if (starts.isNotEmpty) {
                try {
                  next = MedicalCalculator.predictNextPeriod(starts);
                } catch (_) {}
              }
              return Column(
                children: [
                  if (next != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('الدورة القادمة متوقعة: ${next.toLocal().toString().split(' ').first}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focused,
                    selectedDayPredicate: (d) => isSameDay(_selected, d),
                    onDaySelected: (sel, foc) => setState(() {
                      _selected = sel;
                      _focused = foc;
                    }),
                    calendarFormat: CalendarFormat.month,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (ctx, day, _) {
                        final color = _phaseColor(day, starts);
                        if (color == null) return null;
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          child: Center(child: Text('${day.day}')),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(onPressed: _addLog, child: const Text('تسجيل يوم حيض')),
          ),
          Expanded(
            child: logsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(list[i].date.toLocal().toString().split(' ').first),
                  subtitle: Text('شدة التدفق: ${list[i].flowIntensity}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}