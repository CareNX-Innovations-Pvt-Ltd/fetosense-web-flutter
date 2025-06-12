import 'dart:convert';

import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A helper class for managing user preferences and persistent storage.
///
/// The [PreferenceHelper] class provides methods to initialize, save, retrieve,
/// and remove user-related data and settings using [SharedPreferences].
class PreferenceHelper {
  /// Singleton instance of [PreferenceHelper].
  static final PreferenceHelper _instance = PreferenceHelper._internal();

  /// The [SharedPreferences] instance for persistent storage.
  static SharedPreferences? _prefs;

  /// Private constructor for singleton pattern.
  PreferenceHelper._internal();

  /// Factory constructor to return the singleton instance.
  factory PreferenceHelper() {
    return _instance;
  }

  /// Initializes the [SharedPreferences] instance.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Key for auto-login preference.
  static const String autoLogin = "IsAutoLogin";

  /// Key for storing user data.
  static const String users = "users";

  /// Returns the [SharedPreferences] instance, throws if not initialized.
  SharedPreferences get _prefsInstance {
    if (_prefs == null) {
      throw Exception(
        "PreferenceHelper not initialized. Call PreferenceHelper.init() first.",
      );
    }
    return _prefs!;
  }

  /// Sets the auto-login preference.
  void setAutoLogin(bool isAutoLogin) =>
      _prefsInstance.setBool(autoLogin, isAutoLogin);

  /// Gets the auto-login preference, returns `false` if not set.
  bool getAutoLogin() => _prefsInstance.getBool(autoLogin) ?? false;

  /// Removes the stored user data.
  void removeUser() => _prefsInstance.remove(users);

  /// Saves the [user] data as a JSON string in preferences.
  Future<void> saveUser(UserModel user) async {
    String userJson = jsonEncode(user.toJson());
    await _prefsInstance.setString(users, userJson);
  }

  /// Retrieves the user data from preferences, returns `null` if not found.
  UserModel? getUser() {
    String? userJson = _prefsInstance.getString(users);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  /// Sets an integer value for the given [key].
  void setInt(String key, int value) => _prefsInstance.setInt(key, value);

  /// Gets an integer value for the given [key], returns `null` if not found.
  int? getInt(String key) => _prefsInstance.getInt(key);

  /// Sets a boolean value for the given [key].
  void setBool(String key, bool value) => _prefsInstance.setBool(key, value);

  /// Gets a boolean value for the given [key], returns `null` if not found.
  bool? getBool(String key) => _prefsInstance.getBool(key);

  /// Sets a string value for the given [key].
  void setString(String key, String value) =>
      _prefsInstance.setString(key, value);

  /// Gets a string value for the given [key], returns `null` if not found.
  String? getString(String key) => _prefsInstance.getString(key);

  /// Gets the user role, returns [UserRoles.admin] if user not found.
  String getUserRole() {
    final user = getUser();
    if (user != null) {
      return user.role;
    }
    return UserRoles.admin;
  }
}
