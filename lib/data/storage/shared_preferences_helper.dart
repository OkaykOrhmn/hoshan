import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences preferences;

  static Future<void> initial() async {
    preferences = await SharedPreferences.getInstance();
  }

  static const String token = 'auth_token';
  static const String onBoard = 'borading';
}

class OnBoardingStorage {
  static bool getBoradingStatus() {
    final prefs = SharedPreferencesHelper.preferences;
    return prefs.getBool(SharedPreferencesHelper.onBoard) ?? true;
  }

  static void setBoradingStatus(bool status) {
    final prefs = SharedPreferencesHelper.preferences;
    prefs.setBool(SharedPreferencesHelper.onBoard, status);
  }

  static void clearBoradingStatus() {
    final prefs = SharedPreferencesHelper.preferences;
    prefs.remove(SharedPreferencesHelper.onBoard);
  }
}

class AuthTokenStorage {
  static String getToken() {
    final prefs = SharedPreferencesHelper.preferences;
    return prefs.getString(SharedPreferencesHelper.token) ?? "";
  }

  static void setToken(String token) {
    final prefs = SharedPreferencesHelper.preferences;
    prefs.setString(SharedPreferencesHelper.token, token);
  }

  static void clearToken() {
    final prefs = SharedPreferencesHelper.preferences;
    prefs.remove(SharedPreferencesHelper.token);
  }
}
