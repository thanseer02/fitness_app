import 'package:flutter/material.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';
import 'package:fitjourney/models/muscle_group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkoutPickerSheet extends StatelessWidget {
  final WorkoutViewModel viewModel;

  const WorkoutPickerSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.md),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: AppSpacing.md),
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
            SizedBox(height: AppSpacing.md),
            TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(text: 'By Day'),
                Tab(text: 'By Muscle Group'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildByDayTab(context),
                  _buildByMuscleGroupTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildByDayTab(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.lg),
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
    );
  }

  Widget _buildByMuscleGroupTab(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: MuscleGroup.values.map((group) {
              final isSelected = viewModel.selectedMuscleGroups.contains(group);
              return FilterChip(
                label: Text(group.displayName),
                selected: isSelected,
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                onSelected: (_) => viewModel.toggleMuscleGroup(group),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: viewModel.filteredExercises.isEmpty
            ? Center(
                child: Text(
                  viewModel.selectedMuscleGroups.isEmpty 
                    ? 'Select a muscle group to begin'
                    : 'No exercises found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: viewModel.filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = viewModel.filteredExercises[index];
                  final isSelected = viewModel.selectedExerciseIds.contains(exercise.id);
                  
                  return CheckboxListTile(
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.sets} sets • ${exercise.reps} reps'),
                    value: isSelected,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (_) => viewModel.toggleExercise(exercise.id),
                  );
                },
              ),
        ),
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'START WORKOUT',
              variant: (viewModel.selectedMuscleGroups.isNotEmpty && viewModel.selectedExerciseIds.isNotEmpty)
                  ? AppButtonVariant.primary
                  : AppButtonVariant.ghost,
              onPressed: (viewModel.selectedMuscleGroups.isNotEmpty && viewModel.selectedExerciseIds.isNotEmpty)
                  ? () {
                      viewModel.confirmMuscleGroupWorkout();
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ),
        ),
      ],
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
