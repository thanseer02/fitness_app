import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/models/app_settings.dart';
import 'package:fitjourney/models/notification_settings.dart';
import 'package:fitjourney/features/profile/repository/profile_repository.dart';
import 'package:fitjourney/core/services/notification_service.dart';

final profileViewModelProvider = ChangeNotifierProvider<ProfileViewModel>((ref) {
  return ProfileViewModel(ref);
});

class ProfileViewModel extends ChangeNotifier {
  final Ref _ref;

  ProfileViewModel(this._ref) {
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
      final repository = await _ref.read(profileRepositoryProvider.future);
      _userProfile = await repository.getUserProfile();

      var settings = await repository.getAppSettings(1);
      if (settings == null) {
        settings = AppSettings(isDarkMode: false);
        await repository.saveAppSettings(settings);
      }
      _themeMode = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;

      var notifSettings = await repository.getNotificationSettings(1);
      if (notifSettings == null) {
        notifSettings = NotificationSettings();
        await repository.saveNotificationSettings(notifSettings);
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
      final repository = await _ref.read(profileRepositoryProvider.future);
      await repository.saveUserProfile(profile);
      _userProfile = profile;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      final repository = await _ref.read(profileRepositoryProvider.future);
      var settings = await repository.getAppSettings(1) ?? AppSettings();
      settings.isDarkMode = isDark;
      await repository.saveAppSettings(settings);
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNotificationSettings(NotificationSettings newSettings) async {
    try {
      final repository = await _ref.read(profileRepositoryProvider.future);
      newSettings.id = 1;
      await repository.saveNotificationSettings(newSettings);
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
