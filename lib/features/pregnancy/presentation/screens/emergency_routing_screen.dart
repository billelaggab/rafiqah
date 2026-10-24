// lib/features/pregnancy/presentation/screens/emergency_routing_screen.dart
import 'package:flutter/material.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/services/geo_routing_service.dart';

class EmergencyRoutingScreen extends StatelessWidget {
  const EmergencyRoutingScreen({super.key});

  Future<void> _openFacility(
    BuildContext context,
    FacilityType type,
  ) async {
    final opened = await GeoRoutingService.openNearby(type);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق الخرائط. جرّبي البحث يدويًا.'),
        ),
      );
    }
  }

  Future<void> _callEmergency(BuildContext context) async {
    final opened = await GeoRoutingService.openEmergencyDialer();
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق الهاتف. اتصلي برقم الطوارئ المحلي.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('توجيه الطوارئ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.error.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'في حالة طارئة',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'نزيف مهبلي غزير، انقطاع حركة الجنين، ألم شديد أو مستمر، '
                    'تسرب سائل، أو تشنجات — توجهي فورًا إلى أقرب مشفى.',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _callEmergency(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.phone),
                    label: const Text('اتصلي بالطوارئ (112)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ابحثي عن أقرب مرفق طبي:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _FacilityTile(
            icon: Icons.local_hospital,
            title: 'عيادة طبيبة نساء وتوليد',
            onTap: () => _openFacility(context, FacilityType.gynecology),
          ),
          _FacilityTile(
            icon: Icons.science,
            title: 'مختبر تحاليل طبية',
            onTap: () => _openFacility(context, FacilityType.laboratory),
          ),
          _FacilityTile(
            icon: Icons.emergency,
            title: 'مستشفى ولادة وأطفال',
            onTap: () =>
                _openFacility(context, FacilityType.maternityHospital),
          ),
          const SizedBox(height: 16),
          const Text(
            'تُفتح الخرائط عبر تطبيق الخرائط المثبت على جهازك. '
            'رقم 112 هو رقم الطوارئ الدولي في معظم الشبكات، لكنه قد يختلف '
            'حسب بلدك — تحققي من الرقم المحلي مسبقًا.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
