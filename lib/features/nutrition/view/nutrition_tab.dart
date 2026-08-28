import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'widgets/today_macros_card.dart';
import 'widgets/meal_card.dart';

class NutritionTab extends ConsumerWidget {
  const NutritionTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(nutritionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: Builder(
        builder: (context) {
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TodayMacrosCard(viewModel: viewModel),
              const SizedBox(height: 16),
              ...daily.meals.map((meal) => MealCard(meal: meal)),
            ],
          );
        },
      ),
    );
  }
}
