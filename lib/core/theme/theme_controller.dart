import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() => ThemeModeNotifier());

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    state = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  void toggle() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.system);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}