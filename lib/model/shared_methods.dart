import 'package:shared_preferences/shared_preferences.dart';

class SharedMethods {
  static String loggedInKey = "LOGGEDINKEY";
  static String nameKey = "NAMEKEY";
  static String emailKey = "EMAILKEY";

  static Future<bool> saveLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loggedInKey, isLoggedIn);
  }

  static Future<bool> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(nameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(emailKey, userEmail);
  }

  static Future<bool?> bringLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loggedInKey);
  }

  static Future<String?> bringUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  static Future<String?> bringUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }
}
