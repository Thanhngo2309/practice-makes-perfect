// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static Future<void> saveDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  static double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
