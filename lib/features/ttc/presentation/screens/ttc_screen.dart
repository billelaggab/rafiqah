// lib/features/ttc/presentation/screens/ttc_screen.dart
import 'package:flutter/material.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';
import 'bbt_chart_screen.dart';

class TtcScreen extends ConsumerWidget {
  const TtcScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('التخطيط للحمل')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (p) {
          if (p?.lmpDate == null) {
            return const Center(child: Text('أدخلي بيانات الدورة أولاً'));
          }
          const cycle = 28;
          final fw = MedicalCalculator.calculateFertileWindow(
            periodStartDate: p!.lmpDate!,
            cycleLength: cycle,
          );
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('يوم التبويض: ${fw.ovulationDay.toLocal().toString().split(' ').first}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('نافذة الخصوبة: ${fw.fertileStart.toLocal().toString().split(' ').first} → ${fw.fertileEnd.toLocal().toString().split(' ').first}'),
                const SizedBox(height: 24),
                const Text('نصائح:', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('• تناولي حمض الفوليك يوميًا'),
                const Text('• تجنبي التدخين والكحول'),
                const Text('• قللي التوتر ونامي جيدًا'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BbtChartScreen()),
                  ),
                  child: const Text('رسم BBT'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// profile provider
final profileProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseProvider);
  return db.userProfileDao.getProfile();
});