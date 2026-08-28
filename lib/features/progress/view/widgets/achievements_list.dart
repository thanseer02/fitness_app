import 'package:flutter/material.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';

class AchievementsList extends StatelessWidget {
  final List<AchievementItem> achievements;

  const AchievementsList({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final ach = achievements[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              color: ach.isUnlocked ? Colors.amber.shade100 : Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      ach.isUnlocked ? Icons.emoji_events : Icons.lock,
                      color: ach.isUnlocked ? Colors.amber.shade800 : Colors.grey,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ach.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: ach.isUnlocked ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
