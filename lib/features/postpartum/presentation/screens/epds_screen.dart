// lib/features/postpartum/presentation/screens/epds_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rafiqah/app/theme/app_colors.dart';
import 'package:rafiqah/core/database/app_database.dart';
import 'package:rafiqah/core/database/database_provider.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';
import 'package:rafiqah/features/postpartum/presentation/providers/epds_provider.dart';

class _EpdsItem {
  const _EpdsItem(this.question, this.options);
  final String question;
  final List<String> options; // بالترتيب من 0 (الأفضل) إلى 3 (الأسوأ)
}

const _items = <_EpdsItem>[
  _EpdsItem(
    'تمكنت من الضحك والنظر إلى الجانب الممتع من الأمور',
    [
      'بقدر ما كنت دائمًا',
      'أقل قليلًا مما كنت',
      'أقل بكثير الآن',
      'لا أبدًا',
    ],
  ),
  _EpdsItem(
    'تطلعت إلى الأمور بسرور',
    [
      'بقدر ما كنت دائمًا',
      'أقل مما اعتدت',
      'أقل بكثير',
      'بالكاد',
    ],
  ),
  _EpdsItem(
    'لومت نفسي بلا داعٍ عندما حدث خطأ ما',
    [
      'لا أبدًا',
      'ليس غالبًا',
      'نعم، أحيانًا',
      'نعم، معظم الوقت',
    ],
  ),
  _EpdsItem(
    'شعرت بالقلق أو التوتر بدون سبب',
    [
      'لا أبدًا',
      'بالكاد',
      'نعم، أحيانًا',
      'نعم، كثيرًا',
    ],
  ),
  _EpdsItem(
    'شعرت بالخوف أو الذعر بدون سبب وجيه',
    [
      'لا أبدًا',
      'ليس كثيرًا',
      'نعم، أحيانًا',
      'نعم، كثيرًا',
    ],
  ),
  _EpdsItem(
    'شعرت بأن الأمور تغلبت عليّ',
    [
      'لا، أتعامل مع الأمور كما دائمًا',
      'لا، في الغالب أتعامل جيدًا',
      'نعم، أحيانًا لا أتعامل كما اعتدت',
      'نعم، معظم الوقت لا أستطيع',
    ],
  ),
  _EpdsItem(
    'كنت تعيسة لدرجة أنني واجهت صعوبة في النوم',
    [
      'لا أبدًا',
      'ليس غالبًا',
      'نعم، أحيانًا',
      'نعم، معظم الوقت',
    ],
  ),
  _EpdsItem(
    'شعرت بالحزن أو البؤس',
    [
      'لا أبدًا',
      'ليس غالبًا',
      'نعم، كثيرًا',
      'نعم، معظم الوقت',
    ],
  ),
  _EpdsItem(
    'كنت تعيسة لدرجة أنني بكيت',
    [
      'لا أبدًا',
      'أحيانًا فقط',
      'نعم، كثيرًا',
      'نعم، معظم الوقت',
    ],
  ),
  _EpdsItem(
    'خطرت لي أفكار إيذاء نفسي',
    [
      'لا أبدًا',
      'بالكاد',
      'أحيانًا',
      'نعم، كثيرًا',
    ],
  ),
];

class EpdsScreen extends ConsumerStatefulWidget {
  const EpdsScreen({super.key});

  @override
  ConsumerState<EpdsScreen> createState() => _EpdsScreenState();
}

class _EpdsScreenState extends ConsumerState<EpdsScreen> {
  final List<int?> _answers = List<int?>.filled(10, null);
  int? _score;
  bool _saving = false;

  bool get _selfHarmAlert => (_answers[9] ?? 0) > 0;

  Future<void> _submit() async {
    if (_answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أجيبي على جميع الأسئلة أولًا')),
      );
      return;
    }

    final answers = _answers.cast<int>();
    final score = MedicalCalculator.epdsScore(answers);
    setState(() => _saving = true);
    try {
      await ref.read(databaseProvider).postpartumDao.insertResult(
            EpdsResultsCompanion.insert(
              takenAt: DateTime.now(),
              score: score,
              answers: jsonEncode(answers),
            ),
          );
      if (!mounted) return;
      setState(() => _score = score);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر حفظ النتيجة: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _restart() {
    setState(() {
      _answers.fillRange(0, 10, null);
      _score = null;
    });
  }

  Future<void> _callEmergency() async {
    final uri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق الهاتف. اتصلي برقم الطوارئ المحلي.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(epdsHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('مقياس إيدنبرة (EPDS)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'هذا المقياس أداة فحص أولية وليس تشخيصًا طبيًا. '
                'أجيبي بناءً على شعورك خلال الأيام السبعة الماضية.',
              ),
            ),
          ),
          if (_selfHarmAlert) _CrisisCard(onCall: _callEmergency),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${item.question}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<int>(
                      groupValue: _answers[index],
                      onChanged: (value) =>
                          setState(() => _answers[index] = value),
                      child: Column(
                        children: List.generate(
                          item.options.length,
                          (score) => RadioListTile<int>(
                            value: score,
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.options[score]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('حساب النتيجة وحفظها'),
          ),
          if (_score != null) ...[
            const SizedBox(height: 16),
            _ResultCard(score: _score!),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _restart,
              child: const Text('بدء تقييم جديد'),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'النتائج السابقة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          history.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('تعذر تحميل السجل: $e'),
            data: (results) {
              if (results.isEmpty) {
                return const Text('لا توجد نتائج محفوظة بعد.');
              }
              return Column(
                children: results
                    .take(5)
                    .map(
                      (r) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: r.score >= 13
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.success.withValues(alpha: 0.15),
                          foregroundColor: Colors.black87,
                          child: Text('${r.score}'),
                        ),
                        title: Text('النتيجة: ${r.score} / 30'),
                        subtitle: Text(
                          '${DateFormat('yyyy/MM/dd').format(r.takenAt.toLocal())}'
                          ' — ${_interpretation(r.score)}',
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'في حال وجود أفكار إيذاء النفس، لا تنتظري: اطلبي المساعدة فورًا '
            'من شخص تثقين به أو من الطوارئ.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _interpretation(int score) {
    if (score >= 13) return 'يُنصح بمراجعة مختص';
    if (score >= 10) return 'متابعة ومراقبة';
    return 'ضمن المعدل المنخفض';
  }
}

class _CrisisCard extends StatelessWidget {
  const _CrisisCard({required this.onCall});
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '⚠️ سلامتك أولًا',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'أجبتِ على بند يتعلق بإيذاء النفس. هذه مشاعر ثقيلة، لكنك لستِ '
              'وحدك. تحدثي الآن مع شخص تثقين به، أو اتصلي بالطوارئ.',
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onCall,
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
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final needsSupport = MedicalCalculator.epdsNeedsSupport(score);
    return Card(
      color: needsSupport
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.success.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'النتيجة: $score / 30',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              needsSupport
                  ? 'تشير النتيجة إلى احتمال وجود أعراض اكتئاب ما بعد الولادة. '
                      'هذه ليست تشخيصًا، لكنها إشارة لطلب الدعم من مختصة.'
                  : 'النتيجة لا تشير حاليًا إلى أعراض شديدة. استمري في رعاية '
                      'نفسك، وأعيدي التقييم إذا تغير شعورك.',
            ),
            const SizedBox(height: 8),
            const Text(
              'لا تُغني هذه النتيجة عن استشارة طبية.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
