import 'package:flutter/material.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/features/workout/view/active_workout_screen.dart';

class WorkoutOverviewView extends StatelessWidget {
  final Workout workout;

  const WorkoutOverviewView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
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
  }
}
