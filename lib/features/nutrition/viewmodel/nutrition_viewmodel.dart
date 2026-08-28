import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/profile/repository/profile_repository.dart';
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
    
    _ref.listen(profileViewModelProvider, (previous, next) {
      final profile = next.userProfile;
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

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _hostelFriendlyOnly = false;
  bool get hostelFriendlyOnly => _hostelFriendlyOnly;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleHostelFriendly(bool value) {
    _hostelFriendlyOnly = value;
    notifyListeners();
  }

  List<Food> get filteredFoods {
    var filtered = _availableFoods.where((f) => f.name.toLowerCase().contains(_searchQuery)).toList();
    if (_hostelFriendlyOnly) {
      filtered = filtered.where((f) => f.isHostelFriendly).toList();
    }
    return filtered;
  }

  double get totalCalories {
    if (_dailyNutrition == null) return 0;
    return _dailyNutrition!.meals.expand((m) => m.entries).fold(0.0, (sum, e) => sum + (e.calories ?? 0));
  }

  double get totalProtein {
    if (_dailyNutrition == null) return 0;
    return _dailyNutrition!.meals.expand((m) => m.entries).fold(0.0, (sum, e) => sum + (e.protein ?? 0));
  }

  double get totalCarbs {
    if (_dailyNutrition == null) return 0;
    return _dailyNutrition!.meals.expand((m) => m.entries).fold(0.0, (sum, e) => sum + (e.carbs ?? 0));
  }

  double get totalFat {
    if (_dailyNutrition == null) return 0;
    return _dailyNutrition!.meals.expand((m) => m.entries).fold(0.0, (sum, e) => sum + (e.fat ?? 0));
  }

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
      final profileViewModel = _ref.read(profileViewModelProvider);
      var profile = profileViewModel.userProfile;
      if (profile == null) {
        final profileRepo = await _ref.read(profileRepositoryProvider.future);
        profile = await profileRepo.getUserProfile();
      }
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
