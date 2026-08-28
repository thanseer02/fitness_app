import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/food.dart';
import '../models/daily_nutrition.dart';
import '../models/user_profile.dart';
import 'isar_provider.dart';
import 'user_profile_provider.dart';
import '../services/calorie_service.dart';

class NutritionSeedService {
  static Future<void> seedFoods(Isar isar) async {
    final count = await isar.foods.count();
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

    await isar.writeTxn(() async {
      await isar.foods.putAll(foods);
    });
  }
}



final macroTargetsProvider = Provider<MacroTargets>((ref) {
  final profileState = ref.watch(userProfileNotifierProvider);
  final profile = profileState.value;

  if (profile == null) return MacroTargets(2000, 150, 200, 60); // Fallback

  return CalorieService.calculateTargets(profile);
});

class DailyNutritionNotifier extends AsyncNotifier<DailyNutrition> {
  @override
  Future<DailyNutrition> build() async {
    final isar = await ref.watch(isarProvider.future);
    await NutritionSeedService.seedFoods(isar);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var daily = await isar.dailyNutritions.filter().dateEqualTo(today).findFirst();
    if (daily == null) {
      daily = DailyNutrition()
        ..date = today
        ..meals = [
          Meal()..type = 'Breakfast',
          Meal()..type = 'Lunch',
          Meal()..type = 'Dinner',
          Meal()..type = 'Snack',
        ];
      await isar.writeTxn(() async {
        await isar.dailyNutritions.put(daily!);
      });
    }
    return daily;
  }

  Future<void> addFood(String mealType, Food food, double quantityGrams) async {
    final daily = state.value;
    if (daily == null) return;

    final multiplier = quantityGrams / 100.0;
    
    final entry = FoodEntry()
      ..foodId = food.id
      ..foodName = food.name
      ..quantityGrams = quantityGrams
      ..calories = food.calories * multiplier
      ..protein = food.protein * multiplier
      ..carbs = food.carbs * multiplier
      ..fat = food.fat * multiplier;

    final updatedDaily = DailyNutrition()
      ..id = daily.id
      ..date = daily.date
      ..meals = daily.meals.map((m) {
        if (m.type == mealType) {
          final updatedMeal = Meal()
            ..type = m.type
            ..entries = [...m.entries, entry];
          return updatedMeal;
        }
        return m;
      }).toList();

    state = const AsyncValue.loading();
    try {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await isar.dailyNutritions.put(updatedDaily);
      });
      state = AsyncValue.data(updatedDaily);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dailyNutritionProvider = AsyncNotifierProvider<DailyNutritionNotifier, DailyNutrition>(() {
  return DailyNutritionNotifier();
});

final foodsProvider = FutureProvider<List<Food>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  await NutritionSeedService.seedFoods(isar);
  return isar.foods.where().findAll();
});
