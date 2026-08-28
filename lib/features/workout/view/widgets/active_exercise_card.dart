import 'package:flutter/material.dart';
import 'package:fitjourney/models/exercise.dart';

class ActiveExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int exerciseIndex;
  final List<bool> completedSets;
  final void Function(int exerciseIndex, int setIndex) onToggleSet;

  const ActiveExerciseCard({
    super.key,
    required this.exercise,
    required this.exerciseIndex,
    required this.completedSets,
    required this.onToggleSet,
  });

  @override
  Widget build(BuildContext context) {
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
                    exercise.imagePath,
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
                      Text(exercise.name, style: Theme.of(context).textTheme.titleLarge),
                      Text('${exercise.muscleGroup} • Goal: ${exercise.reps} reps'),
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
            ...List.generate(exercise.sets, (setIndex) {
              final isCompleted = completedSets[setIndex];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Set ${setIndex + 1}'),
                trailing: Checkbox(
                  value: isCompleted,
                  onChanged: (_) => onToggleSet(exerciseIndex, setIndex),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
