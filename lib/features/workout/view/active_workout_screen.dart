import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';

import 'widgets/exercise_card.dart';
import 'widgets/exercise_detail_sheet.dart';

class SetData {
  int reps;
  double weight;
  bool isCompleted;
  SetData({required this.reps, required this.weight, this.isCompleted = false});
}

class ActiveWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const ActiveWorkoutScreen({super.key, required this.workout});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final DateTime _startTime = DateTime.now();
  final Map<int, List<SetData>> _exerciseSets = {};

  @override
  void initState() {
    super.initState();
    final exercises = widget.workout.exercises.toList();
    for (int i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      // Try to parse the first number from reps (e.g. "8-12" -> 8)
      final repsInt = int.tryParse(ex.reps.split(RegExp(r'[^0-9]')).firstWhere((e) => e.isNotEmpty, orElse: () => '10')) ?? 10;
      // Defaulting to 0 weight, but users can edit.
      _exerciseSets[i] = List.generate(ex.sets, (_) => SetData(reps: repsInt, weight: 0.0));
    }
  }

  bool _isAllCompleted() {
    for (final sets in _exerciseSets.values) {
      if (sets.any((s) => !s.isCompleted)) return false;
    }
    return true;
  }

  Future<void> _completeWorkout() async {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.primary, size: 64),
            const SizedBox(height: AppSpacing.md),
            Text('Workout Complete!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            const Text('Great job crushing your goals today.'),
          ],
        ),
      ),
    );

    // Wait briefly for animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop(); // pop dialog

    // Serialize
    final List<String> sessionLogs = [];
    final exercises = widget.workout.exercises.toList();
    for (int i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      final sets = _exerciseSets[i]!;
      final completedSets = sets.where((s) => s.isCompleted).toList();
      
      if (completedSets.isNotEmpty) {
        final details = completedSets.map((s) => '${s.reps}x${s.weight}kg').join(', ');
        sessionLogs.add('${ex.name}: $details');
      }
    }

    final viewModel = context.read<WorkoutViewModel>();
    await viewModel.finishActiveWorkout(widget.workout, _startTime, sessionLogs);

    if (mounted) {
      Navigator.of(context).pop(); // pop active workout screen
    }
  }

  void _openExerciseSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ExerciseDetailSheet(
          exercise: widget.workout.exercises.toList()[index],
          sets: _exerciseSets[index]!,
          onStateChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.workout.exercises.toList();
    final allDone = _isAllCompleted();

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Session')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Header Card
                  AppCard(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.workout.day.toUpperCase(), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, letterSpacing: 1.2)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(widget.workout.name, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(Icons.fitness_center, size: 16),
                            const SizedBox(width: AppSpacing.xs),
                            Text('${exercises.length} Exercises'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Exercises List
                  ...List.generate(exercises.length, (index) {
                    final isCompleted = _exerciseSets[index]!.every((s) => s.isCompleted);
                    return ExerciseCard(
                      exercise: exercises[index],
                      isCompleted: isCompleted,
                      onTap: () => _openExerciseSheet(index),
                    );
                  }),
                ],
              ),
            ),
            
            // Sticky Bottom Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'COMPLETE WORKOUT',
                  variant: allDone ? AppButtonVariant.primary : AppButtonVariant.ghost,
                  onPressed: allDone ? _completeWorkout : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
