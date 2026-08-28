import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/features/home/viewmodel/home_viewmodel.dart';
import 'package:fitjourney/features/workout/view/active_workout_screen.dart';
import 'package:fitjourney/features/workout/view/workout_tab.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';
import 'package:fitjourney/shared/widgets/progress_ring.dart';
import 'package:fitjourney/shared/widgets/section_header.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final progressVM = context.watch<ProgressViewModel>();
    final nutritionVM = context.watch<NutritionViewModel>();
    final workoutVM = context.watch<WorkoutViewModel>();
    final homeVM = context.watch<HomeViewModel>();

    final user = profileVM.userProfile;
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user.name, user.goal.toString().split('.').last),
              if (!homeVM.isMissedWorkoutsDismissed && homeVM.missedWorkouts.isNotEmpty)
                _buildMissedWorkoutBanner(context, homeVM),
              SizedBox(height: AppSpacing.lg),
              _buildHeroCard(context, progressVM),
              SizedBox(height: AppSpacing.lg),
              _buildWeeklyStrip(context, progressVM),
              SizedBox(height: AppSpacing.lg),
              const SectionHeader(title: 'Today'),
              SizedBox(height: AppSpacing.md),
              _buildTodayStatsRow(context, nutritionVM, workoutVM),
              SizedBox(height: AppSpacing.xl),
              _buildStartWorkoutButton(context, workoutVM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String goal) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good Morning 👋', style: theme.textTheme.headlineMedium),
        Text(
          'Goal: ${goal.toUpperCase()}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMissedWorkoutBanner(BuildContext context, HomeViewModel homeVM) {
    final theme = Theme.of(context);
    final missed = homeVM.missedWorkouts;
    
    String message;
    if (missed.length == 1) {
      final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = days[missed.first.date.weekday - 1];
      message = 'You missed ${missed.first.workoutName} on $dayName';
    } else {
      message = '${missed.length} missed workouts';
    }

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.md),
      child: AppCard(
        color: theme.colorScheme.errorContainer,
        onTap: () {
          // The prompt says "navigating to that workout so the user can log it retroactively or start it now."
          // But our flow now redirects them to the WorkoutTab to use the Smart Picker.
          Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutTab()));
        },
        child: Row(
          children: [
            Icon(Icons.warning_rounded, color: theme.colorScheme.onErrorContainer),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.colorScheme.onErrorContainer),
              onPressed: () => homeVM.dismissMissedWorkouts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, ProgressViewModel progressVM) {
    final theme = Theme.of(context);
    final history = progressVM.weightHistory;
    double currentWeight = 0;
    double diff = 0;
    
    if (history.isNotEmpty) {
      currentWeight = history.last.weight;
      if (history.length >= 2) {
        diff = history.last.weight - history[history.length - 2].weight;
      }
    }

    final isDown = diff < 0;

    return AppCard(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Weight', style: theme.textTheme.labelLarge),
              SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currentWeight.toStringAsFixed(1),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text('kg', style: theme.textTheme.titleMedium),
                ],
              ),
            ],
          ),
          if (diff != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDown ? AppColors.secondary.withValues(alpha: 0.2) : AppColors.error.withValues(alpha: 0.2),
                borderRadius: AppRadius.roundRadius,
              ),
              child: Row(
                children: [
                  Icon(
                    isDown ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isDown ? AppColors.secondary : AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${diff.abs().toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: isDown ? AppColors.secondary : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStrip(BuildContext context, ProgressViewModel progressVM) {
    final theme = Theme.of(context);
    
    final now = DateTime.now();
    // Monday = 1, Sunday = 7
    final currentDayOfWeek = now.weekday;
    final startOfWeek = now.subtract(Duration(days: currentDayOfWeek - 1));

    return AppCard(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final dayDate = startOfWeek.add(Duration(days: index));
          final isToday = dayDate.day == now.day && dayDate.month == now.month;
          
          // Check status
          bool hasWorkout = progressVM.recentSessions.any((s) => s.date.day == dayDate.day && s.date.month == dayDate.month);
          bool hasWeight = progressVM.weightHistory.any((w) => w.date.day == dayDate.day && w.date.month == dayDate.month);
          
          IconData iconData = Icons.circle_outlined;
          Color iconColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);

          if (hasWorkout) {
            iconData = Icons.check_circle;
            iconColor = AppColors.secondary;
          } else if (hasWeight) {
            iconData = Icons.scale;
            iconColor = theme.colorScheme.primary;
          }

          final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

          return Column(
            children: [
              Text(
                dayNames[index],
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Icon(iconData, color: iconColor, size: 24),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTodayStatsRow(BuildContext context, NutritionViewModel nutritionVM, WorkoutViewModel workoutVM) {
    final calsTarget = nutritionVM.targets.calories;
    final calsEaten = nutritionVM.totalCalories;
    final calsProgress = calsTarget > 0 ? (calsEaten / calsTarget) : 0.0;

    final proteinTarget = nutritionVM.targets.protein;
    final proteinEaten = nutritionVM.totalProtein;
    final proteinProgress = proteinTarget > 0 ? (proteinEaten / proteinTarget) : 0.0;

    final workout = workoutVM.todaysWorkout;

    return Row(
      children: [
        Expanded(
          child: _buildStatRingCard(
            context,
            'Calories',
            calsProgress,
            AppColors.primary,
            Icons.local_fire_department,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildStatRingCard(
            context,
            'Protein',
            proteinProgress,
            AppColors.secondary,
            Icons.fitness_center,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppCard(
            padding: EdgeInsets.all(AppSpacing.sm),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutTab()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_gymnastics, color: Theme.of(context).colorScheme.primary, size: 32),
                SizedBox(height: AppSpacing.sm),
                Text(
                  workout?.name ?? 'Rest Day',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRingCard(BuildContext context, String label, double progress, Color color, IconData icon) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          ProgressRing(
            progress: progress,
            size: 60,
            strokeWidth: 6,
            color: color,
            centerWidget: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  Widget _buildStartWorkoutButton(BuildContext context, WorkoutViewModel workoutVM) {
    final workout = workoutVM.todaysWorkout;
    if (workout == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: AppButton(
        label: 'START WORKOUT',
        icon: Icons.play_arrow_rounded,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActiveWorkoutScreen(workout: workout),
            ),
          );
        },
      ),
    );
  }
}
