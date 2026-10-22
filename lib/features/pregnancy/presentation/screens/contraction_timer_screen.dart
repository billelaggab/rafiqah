// lib/features/pregnancy/presentation/screens/contraction_timer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/features/pregnancy/presentation/providers/contraction_notifier.dart';
import 'package:rafiqah/core/services/geo_routing_service.dart';

class ContractionTimerScreen extends ConsumerWidget {
  const ContractionTimerScreen({super.key});

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contractionProvider);
    final notifier = ref.read(contractionProvider.notifier);

    final bg = state.alert ? Colors.red.shade100 : null;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(title: const Text('مؤقت الانقباضات')),
      body: Column(
        children: [
          if (state.alert)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red,
              child: const Text(
                '🔴 توجهي للمستشفى فورًا! (قاعدة 5-1-1)',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  state.isContracting ? 'انقباضة جارية...' : 'جاهز',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 12),
                Text(_fmt(state.currentDuration), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.isContracting ? notifier.endContraction : notifier.startContraction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isContracting ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: Text(state.isContracting ? 'إنهاء الانقباضة' : 'بدء انقباضة',
                      style: const TextStyle(color: Colors.white, fontSize: 18)),
                ),
                if (state.alert) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => GeoRoutingService.openNearby(FacilityType.maternityHospital),
                    icon: const Icon(Icons.local_hospital),
                    label: const Text('أقرب مستشفى ولادة'),
                  ),
                ],
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: state.contractions.length,
              itemBuilder: (_, i) {
                final c = state.contractions[i];
                return ListTile(
                  title: Text('انقباضة ${i + 1}'),
                  subtitle: Text(
                    'المدة: ${c.durationSeconds}s — الفاصل: ${c.intervalSeconds}s',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(onPressed: notifier.reset, child: const Text('إعادة تعيين')),
          ),
        ],
      ),
    );
  }
}