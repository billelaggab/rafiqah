// lib/features/pregnancy/presentation/screens/pregnancy_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kick_counter_screen.dart';
import 'contraction_timer_screen.dart';
import 'emergency_routing_screen.dart';
import 'fetal_growth_screen.dart';
import 'skin_reassurance_screen.dart';
import 'package:rafiqah/features/food_directory/presentation/screens/food_directory_screen.dart';
import 'package:rafiqah/core/database/database_provider.dart';

class PregnancyDashboardScreen extends ConsumerWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(databaseProvider).userProfileDao.watchProfile();
    return Scaffold(
      appBar: AppBar(title: const Text('أنا حامل')),
      body: Column(
        children: [
          StreamBuilder(
            stream: profile,
            builder: (_, snap) {
              final p = snap.data;
              if (p?.eddDate == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Text('موعد الولادة المتوقع: ${p!.eddDate!.toLocal().toString().split(' ').first}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              );
            },
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              children: [
                _tile(context, 'عدّاد الركلات', Icons.touch_app, const KickCounterScreen()),
                _tile(context, 'مؤقت الانقباضات', Icons.timer, const ContractionTimerScreen()),
                _tile(context, 'توجيه الطوارئ', Icons.local_hospital, const EmergencyRoutingScreen()),
                _tile(context, 'دليل الأغذية', Icons.restaurant_menu, const FoodDirectoryScreen()),
                _tile(context, 'تطور الجنين', Icons.child_care, const FetalGrowthScreen()),
                _tile(context, 'ركن التطمين', Icons.spa, const SkinReassuranceScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String label, IconData icon, Widget screen) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}