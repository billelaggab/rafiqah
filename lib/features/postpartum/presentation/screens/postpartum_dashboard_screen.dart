// lib/features/postpartum/presentation/screens/postpartum_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'epds_screen.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/feeding_timer_screen.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/baby_tracker_screen.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/who_growth_screen.dart';

class PostpartumDashboardScreen extends StatelessWidget {
  const PostpartumDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('مقياس EPDS', Icons.favorite, const EpdsScreen()),
      ('مؤقت الرضاعة', Icons.timer, const FeedingTimerScreen()),
      ('تتبع الرضيع', Icons.child_care, const BabyTrackerScreen()),
      ('منحنيات WHO', Icons.show_chart, const WhoGrowthScreen()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('أم جديدة')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: items.map((it) {
          return Card(
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => it.$3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(it.$2, size: 48, color: Colors.deepPurple),
                  const SizedBox(height: 8),
                  Text(it.$1, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}