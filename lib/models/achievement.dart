import 'package:isar/isar.dart';

part 'achievement.g.dart';

@collection
class Achievement {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late DateTime unlockedAt;
}
