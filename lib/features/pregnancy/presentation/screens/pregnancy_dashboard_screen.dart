// lib/features/pregnancy/presentation/screens/pregnancy_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/core/providers/profile_provider.dart';
import 'package:rafiqah/features/food_directory/presentation/screens/food_directory_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/contraction_timer_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/emergency_routing_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/fetal_growth_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/kick_counter_screen.dart';
import 'package:rafiqah/features/pregnancy/presentation/screens/skin_reassurance_screen.dart';

class PregnancyDashboardScreen extends ConsumerWidget {
  const PregnancyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        profileAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('تعذر تحميل بيانات الحمل: $e'),
            ),
          ),
          data: (profile) {
            final edd = profile?.eddDate;
            final lmp = profile?.lmpDate ??
                (edd == null
                    ? null
                    : DateTime(edd.year, edd.month, edd.day - 280));
            if (lmp == null) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'أضيفي تاريخ آخر دورة من الإعدادات لحساب عمر الحمل '
                    'وموعد الولادة المتوقع.',
                  ),
                ),
              );
            }
            final today = DateTime.now();
            final days = DateTime.utc(today.year, today.month, today.day)
                .difference(DateTime.utc(lmp.year, lmp.month, lmp.day))
                .inDays;
            final weeks = (days / 7).floor().clamp(0, 45);
            final daysLeft = edd == null
                ? null
                : DateTime.utc(edd.year, edd.month, edd.day)
                    .difference(DateTime.utc(today.year, today.month, today.day))
                    .inDays;
            return Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أنتِ في الأسبوع $weeks من الحمل',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (edd != null)
                      Text('موعد الولادة المتوقع: ${dateFormat.format(edd)}'),
                    if (daysLeft != null)
                      Text(
                        daysLeft >= 0
                            ? 'متبقي حوالي $daysLeft يومًا'
                            : 'تجاوزتِ موعد الولادة المتوقع — راجعي طبيبتك',
                      ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (days / 280).clamp(0.0, 1.0),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
          children: [
            _tile(
              context,
              'عدّاد الركلات',
              Icons.touch_app,
              const KickCounterScreen(),
              const [Color(0xFF6D28D9), Color(0xFF7C3AED)],
            ),
            _tile(
              context,
              'مؤقت الانقباضات',
              Icons.timer,
              const ContractionTimerScreen(),
              const [Color(0xFF9D174D), Color(0xFFBE185D)],
            ),
            _tile(
              context,
              'توجيه الطوارئ',
              Icons.local_hospital,
              const EmergencyRoutingScreen(),
              const [Color(0xFFB91C1C), Color(0xFFDC2626)],
            ),
            _tile(
              context,
              'دليل الأغذية',
              Icons.restaurant_menu,
              const FoodDirectoryScreen(),
              const [Color(0xFF065F46), Color(0xFF047857)],
            ),
            _tile(
              context,
              'تطور الجنين',
              Icons.child_care,
              const FetalGrowthScreen(),
              const [Color(0xFF92400E), Color(0xFFB45309)],
            ),
            _tile(
              context,
              'ركن التطمين',
              Icons.spa,
              const SkinReassuranceScreen(),
              const [Color(0xFF581C87), Color(0xFF6B21A8)],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'رفيقة أداة تثقيفية وتنظيمية، ولا تُغني عن متابعة الطبيبة. '
          'في الطوارئ توجهي لأقرب مشفى.',
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
    List<Color> colors,
  ) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
