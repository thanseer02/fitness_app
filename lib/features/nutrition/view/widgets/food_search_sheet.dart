import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'food_quantity_sheet.dart';

class FoodSearchSheet extends StatelessWidget {
  final String mealType;

  const FoodSearchSheet({super.key, required this.mealType});

  void _openQuantitySheet(BuildContext context, Food food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FoodQuantitySheet(mealType: mealType, food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NutritionViewModel>();
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.roundRadius,
              ),
            ),
          ),
          Text('Add to $mealType', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: AppRadius.mdRadius,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Food',
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
              ),
              onChanged: (val) => context.read<NutritionViewModel>().setSearchQuery(val.toLowerCase()),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Filter Chip
          FilterChip(
            label: const Text('Hostel Friendly'),
            selected: viewModel.hostelFriendlyOnly,
            selectedColor: AppColors.secondary.withValues(alpha: 0.2),
            checkmarkColor: AppColors.secondary,
            onSelected: (val) => context.read<NutritionViewModel>().toggleHostelFriendly(val),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Results
          Expanded(child: _buildFoodList(context, viewModel)),
        ],
      ),
    );
  }

  Widget _buildFoodList(BuildContext context, NutritionViewModel viewModel) {
    if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());
    if (viewModel.error != null) return Center(child: Text('Error: ${viewModel.error}'));

    final filtered = viewModel.filteredFoods;
    if (filtered.isEmpty) return const Center(child: Text('No foods found.'));

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final food = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AppCard(
            onTap: () => _openQuantitySheet(context, food),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(food.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          if (food.isHostelFriendly) ...[
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(Icons.check_circle, color: AppColors.secondary, size: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${food.calories} kcal | ${food.protein}g P | ${food.carbs}g C | ${food.fat}g F (per 100g)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
