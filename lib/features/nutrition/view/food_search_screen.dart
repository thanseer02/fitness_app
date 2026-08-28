import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String mealType;

  const FoodSearchScreen({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  String _searchQuery = '';
  bool _hostelFriendlyOnly = false;

  void _showAddDialog(Food food) {
    showDialog(
      context: context,
      builder: (context) => _AddFoodDialog(mealType: widget.mealType, food: food),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(nutritionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add to ${widget.mealType}')),
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
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          SwitchListTile(
            title: const Text('Hostel Friendly Only'),
            value: _hostelFriendlyOnly,
            onChanged: (val) => setState(() => _hostelFriendlyOnly = val),
          ),
          const Divider(),
          Expanded(
            child: _buildFoodList(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(NutritionViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (viewModel.error != null) {
      return Center(child: Text('Error loading foods: ${viewModel.error}'));
    }

    var filtered = viewModel.availableFoods.where((f) => f.name.toLowerCase().contains(_searchQuery)).toList();
    if (_hostelFriendlyOnly) {
      filtered = filtered.where((f) => f.isHostelFriendly).toList();
    }

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
          onTap: () => _showAddDialog(food),
        );
      },
    );
  }
}

class _AddFoodDialog extends ConsumerStatefulWidget {
  final String mealType;
  final Food food;

  const _AddFoodDialog({required this.mealType, required this.food});

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
              await ref.read(nutritionViewModelProvider).addFood(widget.mealType, widget.food, _quantity);
              if (!context.mounted) return;
              Navigator.of(context).pop(); // pop dialog
              Navigator.of(context).pop(); // pop search screen
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
