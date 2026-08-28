import 'package:flutter/material.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';

class TodayMacrosCard extends StatelessWidget {
  final NutritionViewModel viewModel;

  const TodayMacrosCard({super.key, required this.viewModel});

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
  Widget build(BuildContext context) {
    final targets = viewModel.targets;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Macros', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildProgressBar('Calories', viewModel.totalCalories, targets.calories, Colors.orange),
            _buildProgressBar('Protein (g)', viewModel.totalProtein, targets.protein, Colors.red),
            _buildProgressBar('Carbs (g)', viewModel.totalCarbs, targets.carbs, Colors.blue),
            _buildProgressBar('Fat (g)', viewModel.totalFat, targets.fat, Colors.yellow[700]!),
          ],
        ),
      ),
    );
  }
}
