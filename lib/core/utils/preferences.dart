import 'dart:convert';

import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static final PreferenceHelper _instance = PreferenceHelper._internal();
  static SharedPreferences? _prefs;

  PreferenceHelper._internal();

  factory PreferenceHelper() {
    return _instance;
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String autoLogin = "IsAutoLogin";
  static const String users = "users";

  SharedPreferences get _prefsInstance {
    if (_prefs == null) {
      throw Exception("PreferenceHelper not initialized. Call PreferenceHelper.init() first.");
    }
    return _prefs!;
  }

  void setAutoLogin(bool isAutoLogin) => _prefsInstance.setBool(autoLogin, isAutoLogin);
  bool getAutoLogin() => _prefsInstance.getBool(autoLogin) ?? false;

  void removeUser() => _prefsInstance.remove(users);

  Future<void> saveUser(UserModel user) async {
    String userJson = jsonEncode(user.toJson());
    await _prefsInstance.setString(users, userJson);
  }
  UserModel? getUser() {
    String? userJson = _prefsInstance.getString(users);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  void setInt(String key, int value) => _prefsInstance.setInt(key, value);
  int? getInt(String key) => _prefsInstance.getInt(key);

  void setBool(String key, bool value) => _prefsInstance.setBool(key, value);
  bool? getBool(String key) => _prefsInstance.getBool(key);

  void setString(String key, String value) => _prefsInstance.setString(key, value);
  String? getString(String key) => _prefsInstance.getString(key);
}

