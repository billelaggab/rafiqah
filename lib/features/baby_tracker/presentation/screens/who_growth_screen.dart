// lib/features/baby_tracker/presentation/screens/who_growth_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/who_growth.dart';

class WhoGrowthScreen extends StatelessWidget {
  const WhoGrowthScreen({super.key});

  List<FlSpot> _spots(List<WhoGrowth> data, double Function(WhoGrowth) sel) =>
      [for (final d in data) FlSpot(d.month.toDouble(), sel(d))];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منحنيات نمو الرضيع (WHO)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text('${v.toInt()}'),
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _spots(whoBoysWeight, (d) => d.p3),
                color: Colors.blue.shade200,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: _spots(whoBoysWeight, (d) => d.p50),
                color: Colors.blue,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: _spots(whoBoysWeight, (d) => d.p97),
                color: Colors.blue.shade200,
                dotData: const FlDotData(show: false),
              ),
            ],
            minY: 2,
            maxY: 13,
          ),
        ),
      ),
    );
  }
}