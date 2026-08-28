import 'package:isar/isar.dart';
import 'package:fitjourney/models/exercise.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;

  late String day; // Mon, Tue, Wed, etc.
  late String name;

  final exercises = IsarLinks<Exercise>();
}
