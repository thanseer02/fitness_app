import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_history_viewmodel.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/workout_session_detail_sheet.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkoutHistoryViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: WorkoutHistoryFilter.values.map((filter) {
                  final isSelected = viewModel.filter == filter;
                  return Padding(
                    padding: EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text(_getFilterName(filter)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) viewModel.setFilter(filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.error != null
                    ? Center(child: Text('Error: ${viewModel.error}'))
                    : viewModel.filteredSessions.isEmpty
                        ? Center(
                            child: Text(
                              'No workouts found.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            itemCount: viewModel.filteredSessions.length,
                            itemBuilder: (context, index) {
                              final item = viewModel.filteredSessions[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppSpacing.md),
                                child: AppCard(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => FractionallySizedBox(
                                        heightFactor: 0.85,
                                        child: WorkoutSessionDetailSheet(historyItem: item),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(AppSpacing.sm),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primaryContainer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: theme.colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.workoutName,
                                              style: theme.textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              '${DateFormat('MMM d, yyyy').format(item.session.date)} • ${(item.session.durationInSeconds / 60).round()} min',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  String _getFilterName(WorkoutHistoryFilter filter) {
    switch (filter) {
      case WorkoutHistoryFilter.all:
        return 'All Time';
      case WorkoutHistoryFilter.thisWeek:
        return 'Past 7 Days';
      case WorkoutHistoryFilter.thisMonth:
        return 'Past 30 Days';
    }
  }
}
