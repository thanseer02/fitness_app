import 'package:isar/isar.dart';
import 'package:fitjourney/models/user_profile.dart';
import 'package:fitjourney/models/app_settings.dart';
import 'package:fitjourney/models/notification_settings.dart';

class ProfileRepository {
  final Isar _isar;
  ProfileRepository(this._isar);

  Future<UserProfile?> getUserProfile() async {
    return _isar.userProfiles.where().findFirst();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _isar.writeTxn(() async {
      await _isar.userProfiles.put(profile);
    });
  }

  Future<AppSettings?> getAppSettings(int id) async {
    return _isar.appSettings.get(id);
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
  }

  Future<NotificationSettings?> getNotificationSettings(int id) async {
    return _isar.notificationSettings.get(id);
  }

  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.notificationSettings.put(settings);
    });
  }
}
