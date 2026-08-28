import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/models/exercise.dart';
import 'package:fitjourney/models/workout.dart';
import 'package:fitjourney/models/workout_session.dart';
import 'package:fitjourney/models/food.dart';
import 'package:fitjourney/models/daily_nutrition.dart';
import 'package:fitjourney/models/weight_entry.dart';
import 'package:fitjourney/models/notification_settings.dart';
import 'package:fitjourney/models/app_settings.dart';
import 'package:fitjourney/models/achievement.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      UserProfileSchema,
      ExerciseSchema,
      WorkoutSchema,
      WorkoutSessionSchema,
      FoodSchema,
      DailyNutritionSchema,
      WeightEntrySchema,
      NotificationSettingsSchema,
      AppSettingsSchema,
      AchievementSchema,
    ],
    directory: dir.path,
  );
});
