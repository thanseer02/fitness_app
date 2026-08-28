import 'package:flutter/material.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/features/nutrition/view/food_search_screen.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    double mealCals = meal.entries.fold(0.0, (sum, e) => sum + (e.calories ?? 0));

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
  }
}
