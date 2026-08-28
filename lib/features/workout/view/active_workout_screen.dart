import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/shared/widgets/rest_timer_dialog.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final Workout workout;

  const ActiveWorkoutScreen({super.key, required this.workout});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
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
    final exercises = widget.workout.exercises.toList();
    final List<String> sessionLogs = [];

    for (int i = 0; i < exercises.length; i++) {
      final ex = exercises[i];
      final completedCount = _completedSets[i]!.where((completed) => completed).length;
      if (completedCount > 0) {
        sessionLogs.add('${ex.name}: $completedCount / ${ex.sets} sets');
      }
    }

    final duration = DateTime.now().difference(_startTime).inSeconds;

    final session = WorkoutSession()
      ..date = DateTime.now()
      ..workoutId = widget.workout.id
      ..completedSetsReps = sessionLogs
      ..durationInSeconds = duration;

    final viewModel = ref.read(workoutViewModelProvider);
    await viewModel.completeWorkout(session);

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
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          ex.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.name, style: Theme.of(context).textTheme.titleLarge),
                            Text('${ex.muscleGroup} • Goal: ${ex.reps} reps'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Set', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  ...List.generate(ex.sets, (setIndex) {
                    final isCompleted = _completedSets[exIndex]![setIndex];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Set ${setIndex + 1}'),
                      trailing: Checkbox(
                        value: isCompleted,
                        onChanged: (_) => _toggleSet(exIndex, setIndex),
                      ),
                    );
                  }),
                ],
              ),
            ),
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
