// lib/features/pregnancy/presentation/screens/fetal_growth_screen.dart
import 'package:flutter/material.dart';
import '../../domain/fetal_growth.dart';

class FetalGrowthScreen extends StatelessWidget {
  const FetalGrowthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تطور الجنين')),
      body: ListView.builder(
        itemCount: fetalGrowthData.length,
        itemBuilder: (_, i) {
          final f = fetalGrowthData[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${f.week}')),
            title: Text('الأسبوع ${f.week}: حجم ${f.fruit}'),
            subtitle: Text('الطول: ${f.size} • الوزن: ${f.weight}'),
          );
        },
      ),
    );
  }
}