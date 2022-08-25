import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static String token = "";

//сохранение токена при регистрации
  static Future<bool> setTokenFromSharedPref(String _token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = _token;
    return prefs.setString('token', token);
  }

//считывание токена
  static Future<String> getTokenFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    return token;
  }
}