// lib/features/pregnancy/presentation/screens/fetal_growth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/providers/profile_provider.dart';

import '../../domain/fetal_growth.dart';

class FetalGrowthScreen extends ConsumerWidget {
  const FetalGrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final profile = profileAsync.valueOrNull;
    final edd = profile?.eddDate;
    final lmp = profile?.lmpDate ??
        (edd == null ? null : DateTime(edd.year, edd.month, edd.day - 280));
    final now = DateTime.now();
    final currentWeek = lmp == null
        ? null
        : (DateTime.utc(now.year, now.month, now.day)
                    .difference(DateTime.utc(lmp.year, lmp.month, lmp.day))
                    .inDays /
                7)
            .floor()
            .clamp(1, 42);

    FetalGrowth? current;
    if (currentWeek != null) {
      for (final item in fetalGrowthData) {
        if (item.week <= currentWeek) current = item;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تطور الجنين')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          if (currentWeek != null && current != null)
            Card(
              margin: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أنتِ في الأسبوع $currentWeek',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'حجم الجنين يقارب ${current.fruit} — '
                      'الطول ${current.size} والوزن ${current.weight}.',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'هذه قيم متوسطة؛ النمو يختلف من طفل لآخر.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'أضيفي تاريخ آخر دورة أو موعد الولادة من الإعدادات لعرض '
                'أسبوعك الحالي.',
              ),
            ),
          ...fetalGrowthData.map((f) {
            final isCurrent = current?.week == f.week && currentWeek != null;
            return ListTile(
              tileColor: isCurrent
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : null,
              leading: CircleAvatar(
                backgroundColor: isCurrent
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  '${f.week}',
                  style: TextStyle(
                    color: isCurrent ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'الأسبوع ${f.week}: حجم ${f.fruit}',
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text('الطول: ${f.size} • الوزن: ${f.weight}'),
            );
          }),
        ],
      ),
    );
  }
}
