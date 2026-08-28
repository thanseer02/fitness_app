import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_profile.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_session.dart';
import '../models/food.dart';
import '../models/daily_nutrition.dart';
import '../models/weight_entry.dart';
import '../models/notification_settings.dart';
import '../models/app_settings.dart';
import '../models/achievement.dart';

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
