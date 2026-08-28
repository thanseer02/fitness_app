import 'package:isar/isar.dart';

part 'workout_session.g.dart';

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late int workoutId;

  // Storing completed sets/reps as a simple JSON string or list of strings
  // Format: "ExerciseName: 10, 10, 8"
  late List<String> completedSetsReps;

  late int durationInSeconds;
}
