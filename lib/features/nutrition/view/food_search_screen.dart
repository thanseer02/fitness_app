import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';

class FoodSearchScreen extends ConsumerWidget {
  final String mealType;

  const FoodSearchScreen({super.key, required this.mealType});

  void _showAddDialog(BuildContext context, WidgetRef ref, Food food) {
    showDialog(
      context: context,
      builder: (context) => _AddFoodDialog(mealType: mealType, food: food, parentContext: context),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(nutritionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add to $mealType')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Food',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                ref.read(nutritionViewModelProvider).setSearchQuery(val.toLowerCase());
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Hostel Friendly Only'),
            value: viewModel.hostelFriendlyOnly,
            onChanged: (val) {
              ref.read(nutritionViewModelProvider).toggleHostelFriendly(val);
            },
          ),
          const Divider(),
          Expanded(
            child: _buildFoodList(context, ref, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(BuildContext context, WidgetRef ref, NutritionViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.error != null) {
      return Center(child: Text('Error loading foods: ${viewModel.error}'));
    }

    final filtered = viewModel.filteredFoods;

    if (filtered.isEmpty) {
      return const Center(child: Text('No foods found.'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final food = filtered[index];
        return ListTile(
          title: Text(food.name),
          subtitle: Text('${food.calories} kcal | ${food.protein}g P | ${food.carbs}g C | ${food.fat}g F (per 100g)'),
          trailing: food.isHostelFriendly 
              ? const Icon(Icons.check_circle, color: Colors.green, size: 16) 
              : null,
          onTap: () => _showAddDialog(context, ref, food),
        );
      },
    );
  }
}

class _AddFoodDialog extends ConsumerStatefulWidget {
  final String mealType;
  final Food food;
  final BuildContext parentContext;

  const _AddFoodDialog({required this.mealType, required this.food, required this.parentContext});

  @override
  ConsumerState<_AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends ConsumerState<_AddFoodDialog> {
  double _quantity = 100;

  @override
  Widget build(BuildContext context) {
    final mult = _quantity / 100.0;
    final cals = (widget.food.calories * mult).toStringAsFixed(0);
    final pro = (widget.food.protein * mult).toStringAsFixed(1);
    final car = (widget.food.carbs * mult).toStringAsFixed(1);
    final fat = (widget.food.fat * mult).toStringAsFixed(1);

    return AlertDialog(
      title: Text(widget.food.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Quantity (grams)', suffixText: 'g'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() {
                _quantity = double.tryParse(val) ?? 0;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Calories: $cals kcal'),
          Text('Macros: ${pro}g P | ${car}g C | ${fat}g F'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_quantity > 0) {
              final viewModel = ref.read(nutritionViewModelProvider); // not using .notifier because it's a provider of a ChangeNotifier, so .notifier doesn't exist
              await viewModel.addFood(widget.mealType, widget.food, _quantity);
              if (!context.mounted) return;
              Navigator.of(context).pop(); // pop dialog
              Navigator.of(widget.parentContext).pop(); // pop search screen
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
