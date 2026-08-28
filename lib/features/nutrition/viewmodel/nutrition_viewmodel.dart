import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/features/profile/viewmodel/user_profile_provider.dart';
import 'package:fitjourney/core/services/calorie_service.dart';
import 'package:fitjourney/core/services/notification_service.dart';
import 'package:fitjourney/features/nutrition/repository/nutrition_repository.dart';

final nutritionViewModelProvider = ChangeNotifierProvider<NutritionViewModel>((ref) {
  return NutritionViewModel(ref);
});

class NutritionViewModel extends ChangeNotifier {
  final Ref _ref;
  
  NutritionViewModel(this._ref) {
    _init();
    
    _ref.listen(userProfileNotifierProvider, (previous, next) {
      final profile = next.value;
      if (profile != null) {
        _targets = CalorieService.calculateTargets(profile);
        notifyListeners();
      }
    });
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DailyNutrition? _dailyNutrition;
  DailyNutrition? get dailyNutrition => _dailyNutrition;

  List<Food> _availableFoods = [];
  List<Food> get availableFoods => _availableFoods;

  MacroTargets _targets = MacroTargets(2000, 150, 200, 60);
  MacroTargets get targets => _targets;

  String? _error;
  String? get error => _error;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      final profile = await _ref.read(userProfileNotifierProvider.future);
      if (profile != null) {
        _targets = CalorieService.calculateTargets(profile);
      }

      final repository = await _ref.read(nutritionRepositoryProvider.future);
      await repository.seedFoods();
      _availableFoods = await repository.getAllFoods();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      var daily = await repository.getDailyNutrition(today);
      if (daily == null) {
        daily = DailyNutrition()
          ..date = today
          ..meals = [
            Meal()..type = 'Breakfast',
            Meal()..type = 'Lunch',
            Meal()..type = 'Dinner',
            Meal()..type = 'Snack',
          ];
        await repository.saveDailyNutrition(daily);
      }
      _dailyNutrition = daily;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFood(String mealType, Food food, double quantityGrams) async {
    final daily = _dailyNutrition;
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

    _isLoading = true;
    notifyListeners();
    
    try {
      final repository = await _ref.read(nutritionRepositoryProvider.future);
      await repository.saveDailyNutrition(updatedDaily);
      _dailyNutrition = updatedDaily;
      
      // Cancel protein reminder if target met
      double currentProtein = 0;
      for (final m in updatedDaily.meals) {
        for (final e in m.entries) {
          currentProtein += e.protein ?? 0;
        }
      }
      
      if (currentProtein >= _targets.protein) {
        NotificationService().cancelProteinReminder();
      }
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
