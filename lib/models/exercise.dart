import 'package:isar/isar.dart';
import 'package:fitjourney/models/muscle_group.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  late String name;
  @enumerated
  late MuscleGroup muscleGroup;
  late String imagePath;
  late int sets;
  late String reps; // e.g. "8-12"
}
