import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';

class FoodQuantitySheet extends StatefulWidget {
  final String mealType;
  final Food food;

  const FoodQuantitySheet({super.key, required this.mealType, required this.food});

  @override
  State<FoodQuantitySheet> createState() => _FoodQuantitySheetState();
}

class _FoodQuantitySheetState extends State<FoodQuantitySheet> {
  double _quantity = 100.0;
  final double _step = 10.0;

  void _adjustQuantity(double delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(10.0, 1000.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final mult = _quantity / 100.0;
    final cals = (widget.food.calories * mult).toStringAsFixed(0);
    final pro = (widget.food.protein * mult).toStringAsFixed(1);
    final car = (widget.food.carbs * mult).toStringAsFixed(1);
    final fat = (widget.food.fat * mult).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: AppRadius.roundRadius,
            ),
          ),
          Text(widget.food.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xl),
          
          // Stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _adjustQuantity(-_step),
                icon: const Icon(Icons.remove_circle_outline, size: 36),
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                children: [
                  Text(
                    '${_quantity.toStringAsFixed(0)}',
                    style: theme.textTheme.displaySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  Text('grams', style: theme.textTheme.labelMedium),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              IconButton(
                onPressed: () => _adjustQuantity(_step),
                icon: const Icon(Icons.add_circle_outline, size: 36),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Live Macros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroStat(theme, 'Cals', cals, AppColors.primary),
              _buildMacroStat(theme, 'Pro', '${pro}g', AppColors.secondary),
              _buildMacroStat(theme, 'Carbs', '${car}g', Colors.blue),
              _buildMacroStat(theme, 'Fat', '${fat}g', Colors.yellow[700]!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'ADD TO ${widget.mealType.toUpperCase()}',
              icon: Icons.add,
              onPressed: () async {
                final viewModel = context.read<NutritionViewModel>();
                await viewModel.addFood(widget.mealType, widget.food, _quantity);
                if (!context.mounted) return;
                Navigator.of(context).pop(); // pop quantity sheet
                Navigator.of(context).pop(); // pop search sheet
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(ThemeData theme, String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
