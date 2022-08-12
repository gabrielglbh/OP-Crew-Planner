import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';

import 'theme.dart';

class ThemeManager {
  ThemeNotifier? _notifier;

  ThemeManager._() {
    _notifier = ThemeNotifier();
  }

  static final ThemeManager _instance = ThemeManager._();

  /// Singleton instance of [ThemeManager]
  static ThemeManager get instance => _instance;

  ThemeMode? get themeMode => _notifier?.activeMode;
  ThemeData? get currentLightThemeData => light;
  ThemeData? get currentDarkThemeData => dark;

  /// Switch the theme mode on the device
  switchMode(ThemeMode? mode) => _notifier?.setMode(mode);

  /// Adds a custom listener to the [_notifier]
  addListenerTo(Function() listener) => _notifier?.addListener(listener);
}

class ThemeNotifier with ChangeNotifier {
  late ThemeMode activeMode;

  ThemeNotifier([ThemeMode mode = ThemeMode.system]) {
    activeMode = mode;
    _getCurrentTheme();
  }

  _getCurrentTheme() async {
    String? mode = await StorageUtils.readData(
        StorageUtils.themeMode, ThemeMode.light.name);
    if (mode != null) {
      activeMode = ThemeMode.values.asNameMap()[mode] ?? ThemeMode.system;
    }
    notifyListeners();
  }

  /// Sets the actual theme mode in the Shared Preferences and notifies the listeners
  /// that the value has changed to apply it to the UI
  setMode(ThemeMode? mode) {
    if (mode != null) {
      activeMode = mode;
      StorageUtils.saveData(StorageUtils.themeMode, activeMode.name);
      notifyListeners();
    }
  }
}
