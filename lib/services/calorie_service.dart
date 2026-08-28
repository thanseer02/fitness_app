import '../models/user_profile.dart';

class MacroTargets {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MacroTargets(this.calories, this.protein, this.carbs, this.fat);
}

class CalorieService {
  static MacroTargets calculateTargets(UserProfile profile) {
    // Mifflin-St Jeor Equation for BMR (average/male assumption)
    double bmr = 10 * profile.currentWeight + 6.25 * profile.height - 5 * profile.age + 5;

    double activityMultiplier = 1.2;
    switch (profile.activityLevel) {
      case ActivityLevel.sedentary: activityMultiplier = 1.2; break;
      case ActivityLevel.light: activityMultiplier = 1.375; break;
      case ActivityLevel.moderate: activityMultiplier = 1.55; break;
      case ActivityLevel.active: activityMultiplier = 1.725; break;
    }

    double tdee = bmr * activityMultiplier;
    double targetCalories = tdee;

    if (profile.goal == Goal.fatLoss) targetCalories -= 500;
    if (profile.goal == Goal.muscleBuilding) targetCalories += 300;

    double protein = profile.targetWeight * 2.2; // roughly 2.2g per kg of target weight
    double fat = profile.targetWeight * 1.0;     // roughly 1g per kg of target weight
    
    double proteinCals = protein * 4;
    double fatCals = fat * 9;
    double remainingCals = targetCalories - (proteinCals + fatCals);
    double carbs = (remainingCals > 0) ? (remainingCals / 4) : 0;

    return MacroTargets(targetCalories, protein, carbs, fat);
  }
}
