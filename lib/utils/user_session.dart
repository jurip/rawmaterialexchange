import 'package:app/utils/data_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static String token = "";

  static String phone = "";

//сохранение токена при регистрации
  static Future<bool> setTokenFromSharedPref(String _token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = _token;
    return prefs.setString('token', token);
  }

  static Future<bool> setPhoneFromSharedPref(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('phone', phone);
  }
  static Future<bool> setLanguageFromSharedPref(int? lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('language', definitionLanguage(lang));
  }

//считывание токена
  static Future<String> getTokenFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    return token;
  }

  static Future<String> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone') ?? '';
    return phone;
  }
  static Future<String> getUserLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('language') ?? '';

    return phone;
  }
}
