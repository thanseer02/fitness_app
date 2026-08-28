import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitjourney/models/weight_entry.dart';

class WeightTrackerChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const WeightTrackerChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('No weight history. Check in to start tracking!'));
    }
    
    final spots = entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();

    double minW = entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 5;
    double maxW = entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 5;

    return LineChart(
      LineChartData(
        minY: minW > 0 ? minW : 0,
        maxY: maxW,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < entries.length) {
                  final date = entries[value.toInt()].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('${date.day}/${date.month}', style: const TextStyle(fontSize: 10)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
