// lib/features/postpartum/presentation/screens/epds_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiqah/core/utils/medical_calculator.dart';

const _questions = [
  'تمكنت من الضحك والنظر إلى الجانب الممتع من الأمور',
  'تطلعت إلى الأمور بسرور',
  'لومت نفسي بلا داعٍ عندما حدث خطأ ما',
  'شعرت بالقلق أو القلق بدون سبب',
  'شعرت بالخوف أو الذعر بدون سبب وجيه',
  'شعرت بأن الأمور تغلبت علي',
  'كنت تعيسة لدرجة أنني واجهت صعوبة في النوم',
  'شعرت بالحزن أو البؤس',
  'كنت تعيسة لدرجة أنني بكيت',
  'خطر خطر إلحاق الأذى بنفسي',
];

class EpdsScreen extends ConsumerStatefulWidget {
  const EpdsScreen({super.key});
  @override
  ConsumerState<EpdsScreen> createState() => _EpdsScreenState();
}

class _EpdsScreenState extends ConsumerState<EpdsScreen> {
  final List<int?> _answers = List.filled(10, null);
  int? _score;

  void _submit() {
    if (_answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أجيبي على جميع الأسئلة')));
      return;
    }
    final s = MedicalCalculator.epdsScore(_answers.cast<int>());
    setState(() => _score = s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مقياس إيدنبرة (EPDS)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...List.generate(10, (i) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${i + 1}. ${_questions[i]}'),
                      RadioGroup<int>(
                        groupValue: _answers[i],
                        onChanged: (val) => setState(() => _answers[i] = val),
                        child: Column(
                          children: List.generate(4, (v) => RadioListTile<int>(
                                title: Text(_optionLabel(v)),
                                value: v,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          ElevatedButton(onPressed: _submit, child: const Text('حساب النتيجة')),
          if (_score != null) ...[
            const SizedBox(height: 16),
            Text('النتيجة: $_score / 30', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_score! >= 13
                ? 'نوصي بطلب المساعدة من مختص. أنتِ لستِ وحدك 💜'
                : 'نتيجتك ضمن المعدل. استمري في رعاية نفسك 💜'),
          ],
        ],
      ),
    );
  }

  String _optionLabel(int v) {
    const labels = ['0 — نادرًا/أبدًا', '1 — أحيانًا', '2 — في الغالب', '3 — دائمًا'];
    return labels[v];
  }
}