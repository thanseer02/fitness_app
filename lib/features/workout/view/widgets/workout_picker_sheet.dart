import 'package:flutter/material.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutPickerSheet extends StatelessWidget {
  final WorkoutViewModel viewModel;

  const WorkoutPickerSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.roundRadius,
              ),
            ),
          ),
          Text(
            'Change Today\'s Workout',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              children: [
                _buildWorkoutOption(
                  context,
                  title: 'Rest Day',
                  subtitle: 'Take a break',
                  isSelected: viewModel.isCustomWorkout && viewModel.todaysWorkout == null,
                  onTap: () {
                    viewModel.selectWorkout(null);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: AppSpacing.sm),
                ...viewModel.availableWorkouts.map((workout) {
                  final isSelected = viewModel.todaysWorkout?.id == workout.id;
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildWorkoutOption(
                      context,
                      title: workout.name,
                      subtitle: '${workout.day} • ${workout.exercises.length} exercises',
                      isSelected: isSelected,
                      onTap: () {
                        viewModel.selectWorkout(workout.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return AppCard(
      onTap: onTap,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : null,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected 
                      ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                      : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
