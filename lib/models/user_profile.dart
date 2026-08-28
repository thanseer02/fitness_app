import 'package:isar/isar.dart';

part 'user_profile.g.dart';

enum Goal {
  fatLoss,
  muscleBuilding,
  maintenance,
}

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
}

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  late String name;
  late int age;
  late double height; // in cm
  late double currentWeight; // in kg
  late double targetWeight; // in kg

  @enumerated
  late Goal goal;

  @enumerated
  late ActivityLevel activityLevel;
}
