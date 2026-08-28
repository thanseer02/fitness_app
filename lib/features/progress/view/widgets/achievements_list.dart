import 'package:flutter/material.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';
import 'package:fitjourney/core/theme/app_colors.dart';
import 'package:fitjourney/core/theme/app_constants.dart';
import 'package:fitjourney/shared/widgets/app_card.dart';

class AchievementsList extends StatelessWidget {
  final List<AchievementItem> achievements;

  const AchievementsList({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final ach = achievements[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              color: ach.isUnlocked ? AppColors.secondary.withValues(alpha: 0.15) : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ach.isUnlocked ? Icons.emoji_events : Icons.lock,
                    color: ach.isUnlocked ? AppColors.secondary : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 36,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    ach.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ach.isUnlocked ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
