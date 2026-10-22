// lib/features/onboarding/presentation/screens/disclaimer_screen.dart
import 'package:flutter/material.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DisclaimerScreen extends ConsumerWidget {
  const DisclaimerScreen({super.key, required this.onAccepted});
  final VoidCallback onAccepted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                '⚠️ تنبيه وإخلاء مسؤولية طبية قانوني',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'المحتوى، الحسابات، والأدوات المتوفرة في تطبيق رفيقة '
                'هي لأغراض تثقيفية وإرشادية وتنظيمية فقط، '
                'ولا يمكن اعتبارها بأي حال من الأحوال تشخيصًا طبيًا، '
                'أو بديلًا عن الفحص السريري واستشارة الطبيبة المختصة.\n\n'
                'في حال شعورك بأي أعراض طارئة أو غير معتادة '
                '(كنزيف مفاجئ، انقطاع حركة الجنين، آلام حادة)، '
                'يجب التوجه فورًا إلى أقرب مشفى أو الاتصال بالطوارئ.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(databaseProvider).userProfileDao.acceptDisclaimer();
                  onAccepted();
                },
                child: const Text('أوافق وأتفهم ذلك ✓'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}