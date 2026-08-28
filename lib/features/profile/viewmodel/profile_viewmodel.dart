import 'package:flutter/material.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/models/app_settings.dart';
import 'package:fitjourney/models/notification_settings.dart';
import 'package:fitjourney/features/profile/repository/profile_repository.dart';
import 'package:fitjourney/core/services/notification_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileViewModel(this._repository) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  NotificationSettings? _notificationSettings;
  NotificationSettings? get notificationSettings => _notificationSettings;

  Future<void> _init() async {
    await loadProfileData();
  }

  Future<void> loadProfileData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userProfile = await _repository.getUserProfile();

      var settings = await _repository.getAppSettings(1);
      if (settings == null) {
        settings = AppSettings(isDarkMode: false);
        await _repository.saveAppSettings(settings);
      }
      _themeMode = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;

      var notifSettings = await _repository.getNotificationSettings(1);
      if (notifSettings == null) {
        notifSettings = NotificationSettings();
        await _repository.saveNotificationSettings(notifSettings);
      }
      _notificationSettings = notifSettings;
      _applySettings(notifSettings);

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveUserProfile(profile);
      _userProfile = profile;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile({
    required String name,
    required int age,
    required double height,
    required double currentWeight,
    required double targetWeight,
    required Goal goal,
    required ActivityLevel activityLevel,
  }) async {
    final profile = UserProfile()
      ..name = name
      ..age = age
      ..height = height
      ..currentWeight = currentWeight
      ..targetWeight = targetWeight
      ..goal = goal
      ..activityLevel = activityLevel;
    
    await saveProfile(profile);
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      var settings = await _repository.getAppSettings(1) ?? AppSettings();
      settings.isDarkMode = isDark;
      await _repository.saveAppSettings(settings);
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNotificationSettings(NotificationSettings newSettings) async {
    try {
      newSettings.id = 1;
      await _repository.saveNotificationSettings(newSettings);
      _notificationSettings = newSettings;
      _applySettings(newSettings);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _applySettings(NotificationSettings settings) {
    final service = NotificationService();
    
    if (settings.workoutReminderEnabled) {
      final parts = settings.workoutReminderTime.split(':');
      service.scheduleDailyWorkoutReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelWorkoutReminder();
    }

    if (settings.weighInReminderEnabled) {
      final parts = settings.weighInReminderTime.split(':');
      service.scheduleSundayWeighInReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelWeighInReminder();
    }

    if (settings.proteinReminderEnabled) {
      final parts = settings.proteinReminderTime.split(':');
      service.scheduleDailyProteinReminder(int.parse(parts[0]), int.parse(parts[1]));
    } else {
      service.cancelProteinReminder();
    }
  }
}
