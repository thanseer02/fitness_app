import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_provider.dart';
import 'package:fitjourney/features/workout/view/active_workout_screen.dart';

class WorkoutTab extends ConsumerWidget {
  const WorkoutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(todaysWorkoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Workout')),
      body: workoutState.when(
        data: (workout) {
          if (workout == null) {
            return const Center(
              child: Text('Rest Day! Enjoy your recovery.', style: TextStyle(fontSize: 18)),
            );
          }

          final exercises = workout.exercises.toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  workout.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return ListTile(
                      leading: Image.asset(
                        ex.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fitness_center),
                      ),
                      title: Text(ex.name),
                      subtitle: Text('${ex.muscleGroup} • ${ex.sets} sets of ${ex.reps} reps'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActiveWorkoutScreen(workout: workout),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Start Workout'),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading workout: $e')),
      ),
    );
  }
}
