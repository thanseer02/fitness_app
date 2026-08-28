import 'package:isar/isar.dart';
import 'exercise.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;

  late String day; // Mon, Tue, Wed, etc.
  late String name;

  final exercises = IsarLinks<Exercise>();
}
