import 'package:flutter/material.dart';
import 'package:fitjourney/models/daily_nutrition.dart';

class DailyTargetsCard extends StatelessWidget {
  final DailyNutrition targets;

  const DailyTargetsCard({super.key, required this.targets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Targets', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Calories: ${targets.calories.toStringAsFixed(0)} kcal'),
            Text('Protein: ${targets.protein.toStringAsFixed(0)} g'),
            Text('Carbs: ${targets.carbs.toStringAsFixed(0)} g'),
            Text('Fat: ${targets.fat.toStringAsFixed(0)} g'),
          ],
        ),
      ),
    );
  }
}
