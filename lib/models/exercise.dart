import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  late String name;
  late String muscleGroup;
  late String imagePath;
  late int sets;
  late String reps; // e.g. "8-12"
}
