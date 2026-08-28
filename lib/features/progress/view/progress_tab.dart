import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/features/progress/view/weekly_check_in_screen.dart';

import 'widgets/current_streak_card.dart';
import 'widgets/monthly_summary_card.dart';
import 'widgets/weight_tracker_chart.dart';
import 'widgets/achievements_list.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(progressViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress Dashboard')),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.streakData != null)
                  CurrentStreakCard(streakData: viewModel.streakData!),
                const SizedBox(height: 16),

                Text('This Month', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (viewModel.monthlySummary != null)
                  MonthlySummaryCard(summary: viewModel.monthlySummary!),
                const SizedBox(height: 24),

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
                      child: WeightTrackerChart(entries: viewModel.weightHistory),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                AchievementsList(achievements: viewModel.achievements),
                const SizedBox(height: 32),

                Text('All-Time Stats', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                if (viewModel.stats != null)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _StatCard(title: 'Workouts\nCompleted', value: '${viewModel.stats!.totalWorkouts}', color: Colors.purple),
                      _StatCard(title: '30-Day\nConsistency', value: '${viewModel.stats!.workoutConsistencyPercentage.toStringAsFixed(1)}%', color: Colors.green),
                      _StatCard(title: 'Avg Daily\nCalories', value: viewModel.stats!.avgDailyCalories.toStringAsFixed(0), color: Colors.orange),
                      _StatCard(title: 'Avg Daily\nProtein', value: '${viewModel.stats!.avgDailyProtein.toStringAsFixed(0)}g', color: Colors.red),
                    ],
                  ),
              ],
            ),
          );
        }
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

