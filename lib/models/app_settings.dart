import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 1;

  bool isDarkMode;

  AppSettings({this.isDarkMode = false});
}
