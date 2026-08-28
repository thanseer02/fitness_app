import 'package:isar/isar.dart';

part 'daily_nutrition.g.dart';

@embedded
class FoodEntry {
  int? foodId;
  String? foodName;
  double? quantityGrams;
  
  // Stored recalculated macros for this specific entry
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
}

@embedded
class Meal {
  String? type; // Breakfast, Lunch, Dinner, Snack
  List<FoodEntry> entries = [];
}

@collection
class DailyNutrition {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date; // Normalized to midnight

  List<Meal> meals = [];
}
