import 'package:flutter/material.dart';
import 'package:fitjourney/models/exercise.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';
import 'package:fitjourney/shared/widgets/stat_chip.dart';
import 'dart:io';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isCompleted;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.sm),
        color: isCompleted ? AppColors.secondary.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: AppRadius.smRadius,
              child: Image.file(
                File(exercise.imagePath),
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 70,
                  height: 70,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.fitness_center),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  StatChip(
                    label: '${exercise.sets} sets × ${exercise.reps} reps',
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            
            // Status Icon
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.chevron_right,
                color: isCompleted ? AppColors.secondary : theme.colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
