import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static const String darkMode = "THEME";
  static const String maxFilter = "MAXED";
  static const String rumbleMode = "RUMBLEMODE";
  static const String availableFilter = "AVAILABLE";
  static const String unitListFilter = "CURRENTFILTER";
  static const String connectionStatus = "CONNECTIONSTATUS";
  static const String downloadedLegends = "LEGENDSDOWNLOADED";
  static const String language = "LANGUAGE";
  static const String lastAddedUnitsLength = "ADDEDUNITSLENGTH";

  static StorageUtils? _storageUtils;
  static SharedPreferences? _preferences;

  static Future<StorageUtils?> getInstance() async {
    if (_storageUtils == null) {
      var sec = StorageUtils._();
      await sec._init();
      _storageUtils = sec;
    }
    return _storageUtils;
  }

  StorageUtils._();

  Future _init() async => _preferences = await SharedPreferences.getInstance();

  static List<String>? getKeysForUnits() {
    if (_preferences != null) {
      // Remove the unnecessary keys that were removed in previous updates
      // if they are installed
      try {
        StorageUtils.removeKeyForUnit("ADDEDUNITS");
        StorageUtils.removeKeyForUnit("LASTSEENURLONNAKAMANETWORK");
        StorageUtils.removeKeyForUnit("VERSIONNOTES");
      } catch (err) {}
      return _preferences?.getKeys().where((key) =>
        key != darkMode && key != maxFilter && key != rumbleMode &&
        key != availableFilter && key != unitListFilter &&
        key != connectionStatus && key != downloadedLegends &&
        key != language && key != lastAddedUnitsLength &&
        // Key from the easy_localization package
        key != "locale"
      ).toList(growable: false);
    } else {
      return [];
    }
  }

  static removeKeyForUnit(String key) {
    if (_preferences != null) _preferences?.remove(key);
  }

  static saveData(String key, dynamic value) {
    if (value is int) {
      _preferences?.setInt(key, value);
    } else if (value is String) {
      _preferences?.setString(key, value);
    } else if (value is bool) {
      _preferences?.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static dynamic readData(String key, dynamic defaultValue) {
    if (_preferences?.containsKey(key) == true) return _preferences?.get(key);
    else return defaultValue;
  }
}