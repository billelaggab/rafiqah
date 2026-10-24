// lib/features/onboarding/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:rafiqah/core/database/database_provider.dart';
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
  String? _error;

  Future<void> _pickLmp() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lmp ?? now.subtract(const Duration(days: 30)),
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _lmp = picked);
    }
  }

  Future<void> _save({bool skip = false}) async {
    if (!skip && _lmp == null) {
      setState(() => _error = 'اختاري تاريخ آخر دورة أو اضغطي "تخطي الآن"');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final lmp = skip ? null : _lmp;
      final edd = lmp == null
          ? null
          : MedicalCalculator.calculateEDD(
              lmp: lmp,
              cycleLength: _cycleLength,
            );
      await db.userProfileDao.completeOnboarding(
        lmpDate: lmp,
        eddDate: edd,
        cycleLength: _cycleLength,
      );
      if (mounted) widget.onDone();
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'تعذر حفظ البيانات: $e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');
    final edd = _lmp == null
        ? null
        : MedicalCalculator.calculateEDD(
            lmp: _lmp!,
            cycleLength: _cycleLength,
          );

    return Scaffold(
      appBar: AppBar(title: const Text('البداية')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'أدخلي بياناتك الأولية',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'هذه البيانات تُستخدم لحساب موعد الولادة ومراحل الدورة. '
                      'يمكنك تخطيها الآن وإضافتها لاحقًا من الإعدادات.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('تاريخ آخر دورة شهرية (LMP)'),
                        subtitle: Text(
                          _lmp == null
                              ? 'لم يتم الاختيار'
                              : dateFormat.format(_lmp!),
                        ),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: _saving ? null : _pickLmp,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('متوسط طول الدورة (أيام)'),
                            ),
                            DropdownButton<int>(
                              value: _cycleLength,
                              onChanged: _saving
                                  ? null
                                  : (v) => setState(
                                        () => _cycleLength = v ?? 28,
                                      ),
                              items: List.generate(20, (i) => i + 21)
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text('$v'),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (edd != null) ...[
                      const SizedBox(height: 8),
                      Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: ListTile(
                          leading: const Icon(Icons.event_available),
                          title: const Text('موعد الولادة المتوقع'),
                          subtitle: Text(dateFormat.format(edd)),
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _saving ? null : () => _save(),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('حفظ ومتابعة'),
                  ),
                  TextButton(
                    onPressed: _saving ? null : () => _save(skip: true),
                    child: const Text('تخطي الآن'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
