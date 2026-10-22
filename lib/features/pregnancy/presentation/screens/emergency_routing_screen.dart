// lib/features/pregnancy/presentation/screens/emergency_routing_screen.dart
import 'package:flutter/material.dart';
import 'package:rafiqah/core/services/geo_routing_service.dart';

class EmergencyRoutingScreen extends StatelessWidget {
  const EmergencyRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('توجيه الطوارئ')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('ابحث عن أقرب مرفق طبي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => GeoRoutingService.openNearby(FacilityType.gynecology),
              icon: const Icon(Icons.local_hospital),
              label: const Text('عيادة طبيبة نساء وتوليد'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => GeoRoutingService.openNearby(FacilityType.laboratory),
              icon: const Icon(Icons.science),
              label: const Text('مختبر تحاليل طبية'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => GeoRoutingService.openNearby(FacilityType.maternityHospital),
              icon: const Icon(Icons.emergency),
              label: const Text('مستشفى ولادة وأطفال'),
            ),
          ],
        ),
      ),
    );
  }
}