import 'package:isar/isar.dart';

part 'workout_override.g.dart';

@collection
class WorkoutOverride {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late DateTime date; // Store at midnight for uniqueness
  
  int? workoutId; // null means an explicit override to Rest Day
}
