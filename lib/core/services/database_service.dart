// import 'package:shared_preferences/shared_preferences.dart';

// class DatabaseService {
//   late SharedPreferences _preferences;

//   Future<void> _initPreferences() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   Future<bool?> getBoolValue(String key) async {
//     await _initPreferences();
//     return _preferences.getBool(key);
//   }

//   Future<String?> getStringValue(String key) async {
//     await _initPreferences();
//     return _preferences.getString(key);
//   }

//   Future<void> setBoolValue(String key, bool value) async {
//     await _initPreferences();
//     await _preferences.setBool(key, value);
//   }

//   Future<void> setStringValue(String key, String value) async {
//     await _initPreferences();
//     await _preferences.setString(key, value);
//   }
// }
