import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/section_header.dart';

import 'widgets/current_streak_card.dart';
import 'widgets/weight_tracker_chart.dart';
import 'widgets/achievements_list.dart';
import 'widgets/log_weight_sheet.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  void _openLogWeightSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LogWeightSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProgressViewModel>();
    final theme = Theme.of(context);

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
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.streakData != null)
                  CurrentStreakCard(streakData: viewModel.streakData!),
                const SizedBox(height: AppSpacing.lg),

                // Weight Tracker Chart
                SectionHeader(
                  title: 'Weight History',
                  actionLabel: 'Log',
                  onActionPressed: () => _openLogWeightSheet(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    height: 250,
                    child: WeightTrackerChart(entries: viewModel.weightHistory),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Stat Grid
                const SectionHeader(title: 'All-Time Stats'),
                const SizedBox(height: AppSpacing.sm),
                if (viewModel.stats != null)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                    children: [
                      _buildStatGridCard(
                        context,
                        'Workouts',
                        '${viewModel.stats!.totalWorkouts}',
                        Icons.fitness_center,
                        AppColors.primary,
                      ),
                      _buildStatGridCard(
                        context,
                        'Consistency',
                        '${viewModel.stats!.workoutConsistencyPercentage.toStringAsFixed(1)}%',
                        Icons.insights,
                        AppColors.secondary,
                      ),
                      _buildStatGridCard(
                        context,
                        'Avg Calories',
                        viewModel.stats!.avgDailyCalories.toStringAsFixed(0),
                        Icons.local_fire_department,
                        Colors.orange,
                      ),
                      _buildStatGridCard(
                        context,
                        'Avg Protein',
                        '${viewModel.stats!.avgDailyProtein.toStringAsFixed(0)}g',
                        Icons.restaurant_menu,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.xl),

                // Achievements
                const SectionHeader(title: 'Achievements'),
                const SizedBox(height: AppSpacing.sm),
                AchievementsList(achievements: viewModel.achievements),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLogWeightSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.monitor_weight),
      ),
    );
  }

  Widget _buildStatGridCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: AppRadius.smRadius,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5), size: 16),
            ],
          ),
          const Spacer(),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
