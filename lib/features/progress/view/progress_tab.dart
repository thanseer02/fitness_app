import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_provider.dart';
import 'package:fitjourney/features/progress/viewmodel/gamification_provider.dart';
import 'package:fitjourney/features/progress/view/weekly_check_in_screen.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(weightHistoryProvider);
    final statsState = ref.watch(progressStatsProvider);
    final monthlyState = ref.watch(monthlySummaryProvider);
    final streakState = ref.watch(streakProvider);
    final achievementsState = ref.watch(achievementProvider);

    // Automatically evaluate achievements when tab is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(achievementProvider.notifier).evaluateAchievements();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Streak
            streakState.when(
              data: (streak) {
                return Card(
                  color: Colors.orange.shade50,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          '${streak.currentStreak} Day Streak!',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Monthly Summary
            Text('This Month', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            monthlyState.when(
              data: (monthly) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Workouts:'),
                            Text('${monthly.workoutsCompleted}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Calories:'),
                            Text('${monthly.totalCalories.toStringAsFixed(0)} kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Protein:'),
                            Text('${monthly.totalProtein.toStringAsFixed(0)} g', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Weight Change:'),
                            Text('${monthly.weightChange > 0 ? '+' : ''}${monthly.weightChange.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 24),

            // Weight Tracker
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

            // Achievements
            Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            achievementsState.when(
              data: (achievements) {
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final ach = achievements[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          color: ach.isUnlocked ? Colors.amber.shade100 : Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  ach.isUnlocked ? Icons.emoji_events : Icons.lock,
                                  color: ach.isUnlocked ? Colors.amber.shade800 : Colors.grey,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ach.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: ach.isUnlocked ? Colors.black87 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 32),

            // All-Time Stats
            Text('All-Time Stats', style: Theme.of(context).textTheme.titleLarge),
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
                    _StatCard(title: 'Avg Daily\nCalories', value: stats.avgDailyCalories.toStringAsFixed(0), color: Colors.orange),
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

