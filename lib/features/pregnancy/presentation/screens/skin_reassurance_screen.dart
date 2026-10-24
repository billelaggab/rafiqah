// lib/features/pregnancy/presentation/screens/skin_reassurance_screen.dart
import 'package:flutter/material.dart';

import 'package:rafiqah/app/theme/app_colors.dart';

class SkinReassuranceScreen extends StatelessWidget {
  const SkinReassuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ركن التطمين الجلدي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'تغيّرات الجلد أثناء الحمل شائعة وطبيعية في الغالب، وتنتج عن '
                'تغيرات هرمونية وزيادة تدفق الدم. معظمها يتحسن بعد الولادة.',
              ),
            ),
          ),
          SizedBox(height: 8),
          _Section(
            title: 'الكلف (Melasma)',
            body: 'بقع بنية على الوجه، خصوصًا الخدين والجبهة. يزداد مع الشمس. '
                'استخدمي واقي شمس واسع الطيف SPF 30+ يوميًا، وقبعة. '
                'تجنبي كريمات التفتيح القوية أثناء الحمل.',
          ),
          _Section(
            title: 'الخط الأسود (Linea Nigra)',
            body: 'خط داكن على منتصف البطن. طبيعي تمامًا، ويخف تدريجيًا بعد '
                'الولادة. لا يحتاج علاجًا.',
          ),
          _Section(
            title: 'تصبغات الإبط والرقبة',
            body: 'تصبغات داكنة بسبب الهرمونات. تجنبي الفرك القاسي، '
                'واستخدمي مرطبًا لطيفًا. راجعي الطبيبة إذا كانت مصحوبة '
                'بسواد شديد أو علامات مقاومة أنسولين.',
          ),
          _Section(
            title: 'حبوب الحمل',
            body: 'قد تتحسن أو تسوء. اغسلي وجهك بلطف مرتين يوميًا بغسول '
                'لطيف، وتجنبي المنتجات القاسية. بعض العلاجات الموضعية '
                'تحتاج موافقة الطبيبة أثناء الحمل.',
          ),
          _Section(
            title: 'تساقط الشعر',
            body: 'يزداد كثافة الشعر أثناء الحمل ثم يتساقط بعد الولادة '
                'بشكل مؤقت. هذا طبيعي ويعود تدريجيًا. لا تحتاجين علاجًا '
                'عادة، إلا إذا استمر التساقط الشديد.',
          ),
          Card(
            color: Color(0xFFFFF3E0),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متى تراجعين الطبيبة؟',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'إذا ظهر طفح جلدي مؤلم أو منتشر، تقرحات، تورم مفاجئ، '
                    'أو تغير في لون الجلد مع ألم — راجعي فورًا. '
                    'هذه المعلومات تثقيفية ولا تُغني عن التشخيص الطبي.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(body),
          ],
        ),
      ),
    );
  }
}
