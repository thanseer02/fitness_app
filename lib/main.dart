import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fitjourney/features/profile/view/onboarding_screen.dart';
import 'package:fitjourney/features/home/view/home_screen.dart';
import 'package:fitjourney/core/services/notification_service.dart';

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

import 'package:fitjourney/features/profile/repository/profile_repository.dart';
import 'package:fitjourney/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:fitjourney/features/workout/repository/workout_repository.dart';
import 'package:fitjourney/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:fitjourney/features/nutrition/repository/nutrition_repository.dart';
import 'package:fitjourney/features/nutrition/viewmodel/nutrition_viewmodel.dart';
import 'package:fitjourney/features/progress/repository/progress_repository.dart';
import 'package:fitjourney/features/progress/viewmodel/progress_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestPermissions();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
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

  runApp(
    MultiProvider(
      providers: [
        // Repositories
        Provider<Isar>.value(value: isar),
        Provider<ProfileRepository>(create: (_) => ProfileRepository(isar)),
        Provider<WorkoutRepository>(create: (_) => WorkoutRepository(isar)),
        Provider<NutritionRepository>(create: (_) => NutritionRepository(isar)),
        Provider<ProgressRepository>(create: (_) => ProgressRepository(isar)),

        // ViewModels
        ChangeNotifierProvider<ProfileViewModel>(
          create: (ctx) => ProfileViewModel(ctx.read<ProfileRepository>()),
        ),
        ChangeNotifierProvider<WorkoutViewModel>(
          create: (ctx) => WorkoutViewModel(ctx.read<WorkoutRepository>()),
        ),
        ChangeNotifierProvider<NutritionViewModel>(
          create: (ctx) => NutritionViewModel(
            ctx.read<NutritionRepository>(),
            ctx.read<ProfileViewModel>(),
          ),
        ),
        ChangeNotifierProvider<ProgressViewModel>(
          create: (ctx) => ProgressViewModel(ctx.read<ProgressRepository>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return MaterialApp(
      title: 'FitJourney',
      themeMode: viewModel.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (viewModel.error != null) {
            return Scaffold(
              body: Center(
                child: Text('Error initializing app: ${viewModel.error}'),
              ),
            );
          }
          final profile = viewModel.userProfile;
          if (profile == null) {
            return const OnboardingScreen();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
