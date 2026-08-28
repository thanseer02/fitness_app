import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/app_settings.dart';
import 'isar_provider.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final isar = await ref.watch(isarProvider.future);
    
    var settings = await isar.appSettings.get(1);
    if (settings == null) {
      settings = AppSettings(isDarkMode: false);
      await isar.writeTxn(() async {
        await isar.appSettings.put(settings!);
      });
    }

    return settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme(bool isDark) async {
    final isar = await ref.read(isarProvider.future);
    
    var settings = await isar.appSettings.get(1) ?? AppSettings();
    settings.isDarkMode = isDark;
    
    await isar.writeTxn(() async {
      await isar.appSettings.put(settings);
    });

    state = AsyncValue.data(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
