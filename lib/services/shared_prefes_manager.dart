import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static late SharedPreferences prefs;

  static Future<void> initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String getCurrentLanguage() {
    return prefs.getString("language") ?? "en";
  }

  static void setCurrentLanguage(String language) {
    prefs.setString("language", language);
  }

  static void setUserToken(String token) {
    prefs.setString("token", token);
  }

  static String getUserToken() {
    return prefs.getString("token") ?? "none";
  }

  static bool isDarkMode() {
    return prefs.getBool("darkMode") ?? false;
  }

  static void setDarkMode(bool newState) {
    prefs.setBool("darkMode", newState);
  }

  static bool didSeeStartScreen() {
    return prefs.getBool("startScreen") ?? false;
  }

  static void setStartScreen() {
    prefs.setBool("startScreen", true);
  }
}
