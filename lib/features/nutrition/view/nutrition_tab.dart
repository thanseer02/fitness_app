import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/features/nutrition/view/food_search_screen.dart';

class NutritionTab extends ConsumerWidget {
  const NutritionTab({super.key});

  Widget _buildProgressBar(String label, double current, double target, Color color) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${current.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          color: color,
          backgroundColor: color.withValues(alpha: 0.2),
          minHeight: 8,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(nutritionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, NutritionViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.error != null) {
      return Center(child: Text('Error: ${viewModel.error}'));
    }

    final daily = viewModel.dailyNutrition;
    if (daily == null) {
      return const Center(child: Text('No nutrition data found.'));
    }

    final targets = viewModel.targets;

    double totalCalories = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;
    for (final meal in daily.meals) {
      for (final entry in meal.entries) {
        totalCalories += entry.calories ?? 0;
        totalProtein += entry.protein ?? 0;
        totalCarbs += entry.carbs ?? 0;
        totalFat += entry.fat ?? 0;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Macros', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                _buildProgressBar('Calories', totalCalories, targets.calories, Colors.orange),
                _buildProgressBar('Protein (g)', totalProtein, targets.protein, Colors.red),
                _buildProgressBar('Carbs (g)', totalCarbs, targets.carbs, Colors.blue),
                _buildProgressBar('Fat (g)', totalFat, targets.fat, Colors.yellow[700]!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...daily.meals.map((meal) {
          double mealCals = 0;
          for (final e in meal.entries) { mealCals += (e.calories ?? 0); }
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(meal.type ?? 'Meal', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${mealCals.toStringAsFixed(0)} kcal'),
                ),
                const Divider(height: 1),
                ...meal.entries.map((entry) => ListTile(
                  dense: true,
                  title: Text(entry.foodName ?? 'Unknown'),
                  subtitle: Text('${entry.quantityGrams?.toStringAsFixed(0)}g'),
                  trailing: Text('${entry.calories?.toStringAsFixed(0)} kcal'),
                )),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FoodSearchScreen(mealType: meal.type ?? 'Snack'),
                    ));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('ADD FOOD'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ],
    );
  }
}
