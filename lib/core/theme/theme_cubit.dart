import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_read(_prefs));

  static const _key = 'theme_mode';

  final SharedPreferences _prefs;

  static ThemeMode _read(SharedPreferences prefs) =>
      switch (prefs.getString(_key)) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await _prefs.setString(_key, mode.name);
  }

  /// Switches between light and dark, resolving "system" first.
  Future<void> toggle(Brightness current) =>
      setMode(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
}
