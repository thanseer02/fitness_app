import 'package:isar/isar.dart';

part 'food.g.dart';

@collection
class Food {
  Id id = Isar.autoIncrement;

  late String name;
  late double calories; // per 100g
  late double protein;  // per 100g
  late double carbs;    // per 100g
  late double fat;      // per 100g
  late bool isHostelFriendly;
}
