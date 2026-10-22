// lib/features/onboarding/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';


class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  DateTime? _lmp;
  int _cycleLength = 28;
  bool _saving = false;

  Future<void> _pickLmp() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 30)),
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
      locale: const Locale('ar'),
    );
    if (picked != null) setState(() => _lmp = picked);
  }

  Future<void> _save() async {
    if (_lmp == null) return;
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final edd = MedicalCalculator.calculateEDD(lmp: _lmp!, cycleLength: _cycleLength);
    final p = await db.userProfileDao.getProfile();
    if (p == null) {
      await db.userProfileDao.insertProfile(UserProfilesCompanion.insert(
        currentMode: 'pregnancy',
        lmpDate: Value(_lmp),
        eddDate: Value(edd),
      ));
    } else {
      await (db.update(db.userProfiles)..where((t) => t.id.equals(p.id))).write(
        UserProfilesCompanion(
          lmpDate: Value(_lmp),
          eddDate: Value(edd),
          currentMode: const Value('pregnancy'),
        ),
      );
    }
    setState(() => _saving = false);
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البداية')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('أدخلي بياناتك الأولية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('تاريخ آخر دورة شهرية (LMP)'),
              subtitle: Text(_lmp == null ? 'لم يتم الاختيار' : _lmp!.toLocal().toString().split(' ').first),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickLmp,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('متوسط طول الدورة (أيام): '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _cycleLength,
                  items: List.generate(20, (i) => i + 21)
                      .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                      .toList(),
                  onChanged: (v) => setState(() => _cycleLength = v ?? 28),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (_lmp == null || _saving) ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator()
                  : const Text('حفظ ومتابعة'),
            ),
          ],
        ),
      ),
    );
  }
}
