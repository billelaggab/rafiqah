// lib/features/postpartum/presentation/screens/postpartum_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/baby_tracker_screen.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/feeding_timer_screen.dart';
import 'package:rafiqah/features/baby_tracker/presentation/screens/who_growth_screen.dart';
import 'package:rafiqah/features/food_directory/presentation/screens/food_directory_screen.dart';
import 'package:rafiqah/features/postpartum/presentation/providers/epds_provider.dart';
import 'package:rafiqah/features/postpartum/presentation/screens/epds_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/emergency_routing_screen.dart';

class PostpartumDashboardScreen extends ConsumerWidget {
  const PostpartumDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(epdsHistoryProvider);
    final latest = history.valueOrNull?.isNotEmpty == true
        ? history.valueOrNull!.first
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلًا بك في مرحلة الأمومة الجديدة 💜',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'اعتنِ بنفسك كما تعتنين بطفلك. الراحة ليست رفاهية.',
                ),
                if (latest != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'آخر نتيجة EPDS: ${latest.score} / 30 — '
                    '${DateFormat('yyyy/MM/dd').format(latest.takenAt.toLocal())}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _tile(context, 'مقياس EPDS', Icons.favorite, const EpdsScreen()),
            _tile(context, 'مؤقت الرضاعة', Icons.timer, const FeedingTimerScreen()),
            _tile(context, 'تتبع الرضيع', Icons.child_care, const BabyTrackerScreen()),
            _tile(context, 'منحنيات WHO', Icons.show_chart, const WhoGrowthScreen()),
            _tile(context, 'دليل الأغذية', Icons.restaurant_menu, const FoodDirectoryScreen()),
            _tile(context, 'توجيه الطوارئ', Icons.local_hospital, const EmergencyRoutingScreen()),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          color: AppColors.warning.withValues(alpha: 0.08),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'إذا شعرتِ بأفكار إيذاء النفس أو بأنك غير قادرة على رعاية طفلك، '
              'اطلبي المساعدة فورًا من شخص تثقين به أو من الطوارئ. '
              'هذه المشاعر شائعة، وهناك دعم متاح.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'مقياس EPDS أداة فحص أولية وليس تشخيصًا. النتائج لا تُغني عن '
          'استشارة مختصة.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _tile(
    BuildContext context,
    String label,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
