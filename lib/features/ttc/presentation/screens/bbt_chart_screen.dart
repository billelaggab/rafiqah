// lib/features/ttc/presentation/screens/bbt_chart_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BbtChartScreen extends StatelessWidget {
  const BbtChartScreen({super.key});

  // sample BBT data (°C)
  static const _data = [
    36.4, 36.5, 36.4, 36.6, 36.5, 36.7, 36.6,
    36.8, 36.9, 37.0, 36.9, 36.8, 36.7, 36.6,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رسم حرارة الجسم القاعدية (BBT)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text('${v.toInt() + 1}'),
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (int i = 0; i < _data.length; i++) FlSpot(i.toDouble(), _data[i]),
                ],
                isCurved: true,
                color: Colors.purple,
                dotData: const FlDotData(show: true),
              ),
            ],
            minY: 36.0,
            maxY: 37.5,
          ),
        ),
      ),
    );
  }
}