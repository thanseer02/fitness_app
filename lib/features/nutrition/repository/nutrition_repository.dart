import 'package:isar/isar.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/models/daily_nutrition.dart';

class NutritionRepository {
  final Isar _isar;
  NutritionRepository(this._isar);

  Future<void> seedFoods() async {
    final count = await _isar.foods.count();
    if (count > 0) return;

    final foods = [
      Food()..name = 'Egg'..calories = 143..protein = 12.6..carbs = 0.7..fat = 9.5..isHostelFriendly = true,
      Food()..name = 'Banana'..calories = 89..protein = 1.1..carbs = 22.8..fat = 0.3..isHostelFriendly = true,
      Food()..name = 'Oats'..calories = 389..protein = 16.9..carbs = 66.3..fat = 6.9..isHostelFriendly = true,
      Food()..name = 'White Rice (Cooked)'..calories = 130..protein = 2.7..carbs = 28.2..fat = 0.3..isHostelFriendly = false,
      Food()..name = 'Chicken Breast'..calories = 165..protein = 31..carbs = 0..fat = 3.6..isHostelFriendly = false,
      Food()..name = 'Peanuts'..calories = 567..protein = 25.8..carbs = 16.1..fat = 49.2..isHostelFriendly = true,
      Food()..name = 'Milk (Whole)'..calories = 61..protein = 3.2..carbs = 4.8..fat = 3.3..isHostelFriendly = true,
      Food()..name = 'Chickpeas (Boiled)'..calories = 164..protein = 8.9..carbs = 27.4..fat = 2.6..isHostelFriendly = true,
      Food()..name = 'Tuna (Canned)'..calories = 116..protein = 25.5..carbs = 0..fat = 0.8..isHostelFriendly = true,
      Food()..name = 'Mixed Vegetables'..calories = 65..protein = 2.9..carbs = 13.9..fat = 0.2..isHostelFriendly = false,
    ];

    await _isar.writeTxn(() async {
      await _isar.foods.putAll(foods);
    });
  }

  Future<List<Food>> getAllFoods() async {
    return _isar.foods.where().findAll();
  }

  Future<DailyNutrition?> getDailyNutrition(DateTime date) async {
    return _isar.dailyNutritions.filter().dateEqualTo(date).findFirst();
  }

  Future<void> saveDailyNutrition(DailyNutrition daily) async {
    await _isar.writeTxn(() async {
      await _isar.dailyNutritions.put(daily);
    });
  }
}
