import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/features/workout/view/active_workout_screen.dart';
import 'widgets/workout_overview_view.dart';

class WorkoutTab extends ConsumerWidget {
  const WorkoutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(workoutViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Workout')),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, WorkoutViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(child: Text('Error loading workout: ${viewModel.error}'));
    }

    final workout = viewModel.todaysWorkout;
    if (workout == null) {
      return const Center(
        child: Text('Rest Day! Enjoy your recovery.', style: TextStyle(fontSize: 18)),
      );
    }

    return WorkoutOverviewView(workout: workout);
  }
}
