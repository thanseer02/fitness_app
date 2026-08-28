import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/shared/widgets/rest_timer_dialog.dart';
import 'widgets/active_exercise_card.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const ActiveWorkoutScreen({super.key, required this.workout});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final DateTime _startTime = DateTime.now();
  final Map<int, List<bool>> _completedSets = {}; // exercise index -> list of bools per set

  @override
  void initState() {
    super.initState();
    // Initialize completed sets map
    final exercises = widget.workout.exercises.toList();
    for (int i = 0; i < exercises.length; i++) {
      _completedSets[i] = List.generate(exercises[i].sets, (_) => false);
    }
  }

  void _toggleSet(int exerciseIndex, int setIndex) {
    setState(() {
      _completedSets[exerciseIndex]![setIndex] = !_completedSets[exerciseIndex]![setIndex];
    });

    if (_completedSets[exerciseIndex]![setIndex]) {
      // Show rest timer if a set was just completed
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const RestTimerDialog(initialSeconds: 60),
      );
    }
  }

  Future<void> _completeWorkout() async {
    final viewModel = context.read<WorkoutViewModel>();
    await viewModel.finishActiveWorkout(widget.workout, _startTime, _completedSets);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout Session Saved!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.workout.exercises.toList();

    return Scaffold(
      appBar: AppBar(title: Text('Active: ${widget.workout.name}')),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: exercises.length,
        itemBuilder: (context, exIndex) {
          final ex = exercises[exIndex];
          return ActiveExerciseCard(
            exercise: ex,
            exerciseIndex: exIndex,
            completedSets: _completedSets[exIndex]!,
            onToggleSet: _toggleSet,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _completeWorkout,
        icon: const Icon(Icons.check),
        label: const Text('Complete Workout'),
      ),
    );
  }
}
