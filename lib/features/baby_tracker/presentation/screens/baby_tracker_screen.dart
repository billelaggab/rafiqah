// lib/features/baby_tracker/presentation/screens/baby_tracker_screen.dart
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/constants.dart';
import 'package:rafiqah/core/widgets/empty_state.dart';

final babyLogsProvider = StreamProvider<List<BabyCareLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.babyDao.watchLogs();
});

class BabyTrackerScreen extends ConsumerWidget {
  const BabyTrackerScreen({super.key});

  String _label(String type) => switch (type) {
        AppConstants.logFeedLeft => 'رضاعة — الثدي الأيسر',
        AppConstants.logFeedRight => 'رضاعة — الثدي الأيمن',
        AppConstants.logBottle => 'رضاعة — زجاجة',
        AppConstants.logDiaper => 'حفاض',
        AppConstants.logSleep => 'نوم',
        _ => type,
      };

  IconData _icon(String type) => switch (type) {
        AppConstants.logFeedLeft ||
        AppConstants.logFeedRight ||
        AppConstants.logBottle =>
          Icons.local_drink,
        AppConstants.logDiaper => Icons.baby_changing_station,
        AppConstants.logSleep => Icons.bedtime,
        _ => Icons.child_care,
      };

  Future<void> _addLog(BuildContext context, WidgetRef ref) async {
    final type = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('إضافة سجل')),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('رضاعة'),
              onTap: () => Navigator.pop(ctx, 'feeding'),
            ),
            ListTile(
              leading: const Icon(Icons.baby_changing_station),
              title: const Text('حفاض'),
              onTap: () => Navigator.pop(ctx, AppConstants.logDiaper),
            ),
            ListTile(
              leading: const Icon(Icons.bedtime),
              title: const Text('نوم'),
              onTap: () => Navigator.pop(ctx, AppConstants.logSleep),
            ),
          ],
        ),
      ),
    );
    if (type == null || !context.mounted) return;

    if (type == 'feeding') {
      await _addFeeding(context, ref);
    } else if (type == AppConstants.logDiaper) {
      await _addDiaper(context, ref);
    } else if (type == AppConstants.logSleep) {
      await _addSleep(context, ref);
    }
  }

  Future<void> _addFeeding(BuildContext context, WidgetRef ref) async {
    final side = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('نوع الرضاعة'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, AppConstants.logFeedLeft),
            child: const Text('الثدي الأيسر'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, AppConstants.logFeedRight),
            child: const Text('الثدي الأيمن'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, AppConstants.logBottle),
            child: const Text('زجاجة'),
          ),
        ],
      ),
    );
    if (side == null || !context.mounted) return;

    final controller = TextEditingController();
    final isBottle = side == AppConstants.logBottle;
    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBottle ? 'كمية الحليب (مل)' : 'مدة الرضاعة (دقائق)'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: isBottle ? 'الكمية بالمل' : 'المدة بالدقائق',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value == null || value <= 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('أدخلي قيمة أكبر من صفر')),
                );
                return;
              }
              Navigator.pop(ctx, value);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (amount == null || !context.mounted) return;

    await _insert(
      context,
      ref,
      BabyCareLogsCompanion.insert(
        timestamp: DateTime.now(),
        logType: side,
        durationMinutes:
            isBottle ? const Value.absent() : Value(amount.round()),
        amountMl: isBottle ? Value(amount) : const Value.absent(),
      ),
    );
  }

  Future<void> _addDiaper(BuildContext context, WidgetRef ref) async {
    final status = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('حالة الحفاض'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'wet'),
            child: const Text('مبلل'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'dirty'),
            child: const Text('متسخ'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'mixed'),
            child: const Text('مبلل ومتسخ'),
          ),
        ],
      ),
    );
    if (status == null || !context.mounted) return;
    await _insert(
      context,
      ref,
      BabyCareLogsCompanion.insert(
        timestamp: DateTime.now(),
        logType: AppConstants.logDiaper,
        diaperStatus: Value(status),
      ),
    );
  }

  Future<void> _addSleep(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final minutes = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('مدة النوم (دقائق)'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'الدقائق'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value == null || value <= 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('أدخلي عدد دقائق أكبر من صفر')),
                );
                return;
              }
              Navigator.pop(ctx, value);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (minutes == null || !context.mounted) return;
    await _insert(
      context,
      ref,
      BabyCareLogsCompanion.insert(
        timestamp: DateTime.now(),
        logType: AppConstants.logSleep,
        durationMinutes: Value(minutes),
      ),
    );
  }

  Future<void> _insert(
    BuildContext context,
    WidgetRef ref,
    BabyCareLogsCompanion entry,
  ) async {
    if (!context.mounted) return;
    try {
      await ref.read(databaseProvider).babyDao.insertLog(entry);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحفظ: $e')),
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    BabyCareLog log,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف السجل'),
        content: const Text('هل تريدين حذف هذا السجل؟'),
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
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(databaseProvider).babyDao.deleteLog(log.id);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر الحذف: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(babyLogsProvider);
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الرضيع')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addLog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('إضافة سجل'),
      ),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('تعذر تحميل السجل: $e')),
        data: (list) => list.isEmpty
            ? EmptyState(
                icon: Icons.child_care,
                message: 'لا توجد سجلات بعد',
                action: ElevatedButton.icon(
                  onPressed: () => _addLog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة أول سجل'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final log = list[i];
                  final details = <String>[
                    if (log.durationMinutes != null)
                      '${log.durationMinutes} دقيقة',
                    if (log.amountMl != null)
                      '${log.amountMl!.toStringAsFixed(0)} مل',
                    if (log.diaperStatus != null)
                      switch (log.diaperStatus!) {
                        'wet' => 'مبلل',
                        'dirty' => 'متسخ',
                        'mixed' => 'مبلل ومتسخ',
                        _ => log.diaperStatus!,
                      },
                  ];
                  return ListTile(
                    onLongPress: () => _delete(context, ref, log),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Icon(
                        _icon(log.logType),
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(_label(log.logType)),
                    subtitle: Text(
                      '${dateFormat.format(log.timestamp.toLocal())}'
                      '${details.isEmpty ? '' : ' • ${details.join(' • ')}'}',
                    ),
                    trailing: IconButton(
                      tooltip: 'حذف',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(context, ref, log),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
