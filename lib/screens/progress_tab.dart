import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/progress_provider.dart';
import 'weekly_check_in_screen.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(weightHistoryProvider);
    final statsState = ref.watch(progressStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weight Tracker', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WeeklyCheckInScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Check-in'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: historyState.when(
                    data: (entries) {
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
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Aggregate Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            statsState.when(
              data: (stats) {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _StatCard(title: 'Workouts\nCompleted', value: '${stats.totalWorkouts}', color: Colors.purple),
                    _StatCard(title: '30-Day\nConsistency', value: '${stats.workoutConsistencyPercentage.toStringAsFixed(1)}%', color: Colors.green),
                    _StatCard(title: 'Avg Daily\nCalories', value: '${stats.avgDailyCalories.toStringAsFixed(0)}', color: Colors.orange),
                    _StatCard(title: 'Avg Daily\nProtein', value: '${stats.avgDailyProtein.toStringAsFixed(0)}g', color: Colors.red),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(bottom: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
