import 'package:flutter/material.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/app_button.dart';
import 'food_search_sheet.dart';

class MealSection extends StatefulWidget {
  final Meal meal;

  const MealSection({super.key, required this.meal});

  @override
  State<MealSection> createState() => _MealSectionState();
}

class _MealSectionState extends State<MealSection> {
  bool _isExpanded = false;

  void _openAddFoodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: FoodSearchSheet(mealType: widget.meal.type ?? 'Snack'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double mealCals = widget.meal.entries.fold(0.0, (sum, e) => sum + (e.calories ?? 0));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (val) => setState(() => _isExpanded = val),
            title: Text(
              widget.meal.type ?? 'Meal',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${mealCals.toStringAsFixed(0)} kcal',
                  style: theme.textTheme.labelLarge?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            children: [
              if (widget.meal.entries.isNotEmpty) ...[
                const Divider(height: 1),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.meal.entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = widget.meal.entries[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.foodName ?? 'Unknown', style: theme.textTheme.labelLarge),
                                Text(
                                  '${entry.quantityGrams?.toStringAsFixed(0)}g',
                                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${entry.calories?.toStringAsFixed(0)} kcal',
                            style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'ADD FOOD',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.add,
                    onPressed: _openAddFoodSheet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
