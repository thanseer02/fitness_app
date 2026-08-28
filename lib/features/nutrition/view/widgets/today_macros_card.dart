import 'package:flutter/material.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/progress_ring.dart';

class TodayMacrosCard extends StatelessWidget {
  final NutritionViewModel viewModel;

  const TodayMacrosCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final targets = viewModel.targets;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Macros',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroRing(
                context,
                'Cals',
                viewModel.totalCalories,
                targets.calories,
                AppColors.primary,
              ),
              _buildMacroRing(
                context,
                'Protein',
                viewModel.totalProtein,
                targets.protein,
                AppColors.secondary,
              ),
              _buildMacroRing(
                context,
                'Carbs',
                viewModel.totalCarbs,
                targets.carbs,
                Colors.blue,
              ),
              _buildMacroRing(
                context,
                'Fat',
                viewModel.totalFat,
                targets.fat,
                Colors.yellow[700]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRing(BuildContext context, String label, double current, double target, Color color) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      children: [
        ProgressRing(
          progress: progress,
          size: 60,
          strokeWidth: 6,
          color: color,
          centerWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                current.toStringAsFixed(0),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          '${target.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
