// lib/features/onboarding/presentation/screens/disclaimer_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/utils/constants.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key, required this.onAccepted});
  final Future<void> Function() onAccepted;

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool _saving = false;

  Future<void> _accept() async {
    setState(() => _saving = true);
    try {
      await widget.onAccepted();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر حفظ الموافقة: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openPrivacy() async {
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    if (!await canLaunchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح سياسة الخصوصية')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: AppColors.warning,
                    ),
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
                      'يجب التوجه فورًا إلى أقرب مشفى أو الاتصال بالطوارئ.\n\n'
                      'بالمتابعة فإنك توافقين على سياسة الخصوصية، وتقرّين '
                      'بأن التطبيق لا يقدّم تشخيصًا طبيًا ولا يغني عن الرعاية المهنية.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _openPrivacy,
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: const Text('سياسة الخصوصية'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _accept,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('أوافق وأتفهم ذلك ✓'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
