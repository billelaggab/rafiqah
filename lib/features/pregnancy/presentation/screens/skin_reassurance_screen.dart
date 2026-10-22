// lib/features/pregnancy/presentation/screens/skin_reassurance_screen.dart
import 'package:flutter/material.dart';

class SkinReassuranceScreen extends StatelessWidget {
  const SkinReassuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ركن التطمين الجلدي')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'تصبغات الحمل (الكلف، الخط الأسود Linea Nigra، تصبغات الإبط/الرقبة) '
          'هي طبيعية ومؤقتة بسبب هرمون MSH، وستزول بعد الولادة.\n\n'
          '⚠️ تجنبي كريمات التفتيح (الهيدروكينون) أثناء الحمل.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}