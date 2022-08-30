import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:app/api/models/response_authorization.dart';
import 'package:app/api/models/response_get_favorites.dart';
import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/models/response_list_of_coordinates_driving.dart' as Driving;
import 'package:app/api/models/response_list_of_coordinates_walking.dart' as Walking;
import 'package:app/api/models/response_list_object_working_hours.dart';
import 'package:app/api/models/response_list_object_data.dart';
import 'package:app/api/models/response_list_of_contact_phone.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/api/models/response_list_of_object.dart';
import 'package:app/api/models/response_list_of_row_materials.dart';
import 'package:app/api/models/response_logout.dart';
import 'package:app/api/models/response_objects_from_filter.dart';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/models/response_verification.dart';
import 'package:app/api/models/server_response_when_requesting_registration.dart';
import 'package:app/main.dart';
import 'package:app/screens/authorisation.dart';
import 'package:app/utils/shared_preferences.dart';
final String mapbox_token = 'pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA';
//запрос на получение списка языков
Future<List<ListLanguages>?> getLanguages() async {

  String url = 'https://recyclemap.tmweb.ru/api/v1/languages';

  var headers = new Map<String, String>();
  //headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;
  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListLanguages> listLanguages = listLanguagesFromJson(response.body);
    return listLanguages;
  }
  return null;
}

//регистрация
Future<ServerResponseWhenRequestingRegistration?> getRegistration(String name, String surname, String phone, String birthDate, int languageId) async {

  String url = 'https://recyclemap.tmweb.ru/api/v1/register?name=$name&surname=$surname&phone=$phone&language_id=$languageId&birth_date=$birthDate';

  var headers = new Map<String, String>();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  // if (200 <= response.statusCode && response.statusCode < 300) {
  ServerResponseWhenRequestingRegistration serverResponseWhenRequestingRegistration = ServerResponseWhenRequestingRegistration.fromJson(jsonDecode(response.body));
  return serverResponseWhenRequestingRegistration;
  return null;
}

//верификация (смс - код)
Future<ResponseVerification?> getSMSCode(int code) async {

  String url = 'https://recyclemap.tmweb.ru/api/v1/verification?sms_code=$code';

  var headers = new Map<String, String>();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  ResponseVerification responseVerification = ResponseVerification.fromJson(jsonDecode(response.body));
  return responseVerification;
  return null;
}

//авторизация
Future<ResponseAuthorization?> getAuthorization(String phone) async {

  String url = 'https://recyclemap.tmweb.ru/api/v1/login?phone=$phone';

  var headers = new Map<String, String>();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  // if (200 <= response.statusCode && response.statusCode < 300) {
  ResponseAuthorization responseAuthorization = ResponseAuthorization.fromJson(jsonDecode(response.body));
  return responseAuthorization;
  return null;
}

//получение данных пользователя
Future<UserData?> getUserData(BuildContext context) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/user';

  var headers = new Map<String, String>();
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }
  //headers['X-CSRF-TOKEN'] = '';
  //headers['Authorization'] = "Bearer " + Settings.token.toString();

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    UserData userData = userDataFromJson(response.body);
    return userData;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}


//запрос на получение списка сырья
Future<List<ListOfRawMaterials>?> getListOfRawMaterials() async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/raws';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  // if (Settings.token != null)
  headers['accept'] = "application/json";
    //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfRawMaterials> listOfRawMaterials = listOfRawMaterialsFromJson(response.body);
    return listOfRawMaterials;
  }
  return null;
}


//запрос на получение списка сырья конкретного магазина
Future<List<ListOfRawMaterialsOfSpecificObject>?> getListOfRawMaterialsOfSpecificObject(int id, BuildContext context) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/items/$id/raws';

  var headers = new Map<String, String>();
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfRawMaterialsOfSpecificObject> listOfRawMaterialsOfSpecificObject = listOfRawMaterialsOfSpecificObjectFromJson(response.body);
    return listOfRawMaterialsOfSpecificObject;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}


//запрос на получение списка координат всех маркеров
Future<List<ListOfObjects>?> getListOfObjects(BuildContext context) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/items';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfObjects> listOfObjects = listOfObjectsFromJson(response.body);
    return listOfObjects;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}

//запрос на получение данных обьекта
Future<ListObjectData?> getObjectData(int id) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/items/$id';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);

    if (200 <= response.statusCode && response.statusCode < 300) {
      //var responseJson = json.decode(response.body);
      ListObjectData listObjectData = listObjectDataFromJson(response.body);
      return listObjectData;
    }

  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
   return null;
}


//запрос на получение списка контактов
Future<List<ListOfContactPhone>?> getListOfContactPhone(int id) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/items/$id/contacts';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfContactPhone> listOfContactPhone = listOfContactPhoneFromJson(response.body);
    return listOfContactPhone;
  }
  return null;
}

//запрос на получение списка времени работы конкретного обьекта
Future<List<ListObjectWorkingHours>?> getListObjectWorkingHours(int id) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/items/$id/working-hours';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListObjectWorkingHours> listObjectWorkingHours = listObjectWorkingHoursFromJson(response.body);
    return listObjectWorkingHours;
  }
  return null;
}

//запрос на получение обьектов с фильтра
Future<List<ListOfObjectsFromFilter>?> getListOfObjectsInFilter(List<int> array, BuildContext context) async {

  String s = "";
  for(int index = 0; index < array.length; index++) {

    if(index == array.length-1) {
      s += "raw_id[]=${array[index]}";
    } else {
      s += "raw_id[]=${array[index]}&";
    }
  }

  String url = 'https://recyclemap.tmweb.ru/api/v1/items?$s';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfObjectsFromFilter> listOfObjectsFromFilter = listOfObjectsFromFilterFromJson(response.body);
    return listOfObjectsFromFilter;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}

//запрос для маршрута driving
Future<Driving.Route?> getCoordinatesDriving(BuildContext context, double lngMyLocation, double latMyLocation, double objectLng, double objectLat) async {

  //String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/30.090796,59.789816;30.134563,59.769149?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA&steps=true&language=ru';
  String token = 'pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA';
  String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/$lngMyLocation,$latMyLocation;$objectLng,$objectLat?access_token=$token&steps=true&language=ru';

  String geocodingUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$lngMyLocation,$latMyLocation.json?access_token=$token';
  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  try {
    Response response = await http.get(Uri.parse(url), headers: headers);
    if (200 <= response.statusCode && response.statusCode < 300) {
      var responseJson = json.decode(response.body);
      Driving.Route route = Driving.Route.fromJson(responseJson);
      return route;
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
    }
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  return null;
}

//запрос для маршрута driving
Future<String?> getAddressCoordinates(BuildContext context, double lngMyLocation, double latMyLocation) async {

  //String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/30.090796,59.789816;30.134563,59.769149?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA&steps=true&language=ru';

  String url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$lngMyLocation,$latMyLocation.json?access_token=$mapbox_token';
  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  //headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  try {
    Response response = await http.get(Uri.parse(url), headers: headers);
    if (200 <= response.statusCode && response.statusCode < 300) {
      var responseJson = json.decode(response.body);
      String address = responseJson["features"][0]["place_name"].toString();

      return address;
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
    }
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  return null;
}

//запрос для маршрута walking
Future<Walking.RouteWalking?> getCoordinatesWalking(BuildContext context, double lngMyLocation, double latMyLocation, double objectLng, double objectLat) async {

  //String url = 'https://api.mapbox.com/directions/v5/mapbox/walking/30.090796,59.789816;30.134563,59.769149?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA&steps=true&language=ru';

  String url = 'https://api.mapbox.com/directions/v5/mapbox/walking/$lngMyLocation,$latMyLocation;$objectLng,$objectLat?access_token=$mapbox_token&steps=true&language=ru';

  var headers = new Map<String, String>();
  // if (Settings.token != null)
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  // headers['Authorization'] = "Bearer " + Settings.token.toString();
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  try {
    Response response = await http.get(Uri.parse(url), headers: headers);
    if (200 <= response.statusCode && response.statusCode < 300) {
      var responseJson = json.decode(response.body);
      Walking.RouteWalking routeWalking = Walking.RouteWalking.fromJson(responseJson);
      return routeWalking;
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
    }
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  return null;
}

// Получение списка избранных
Future<List<GetFavorites>?> getFavorites(BuildContext context) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/useritems';

  var headers = new Map<String, String>();
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<GetFavorites> favorites = getFavoritesFromJson(response.body);
    return favorites;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}

// Добавить избранное
Future<bool> addFavorite(BuildContext context, int itemId) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/useritems';

  var headers = new Map<String, String>();
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  var body = new Map<String, String>();
  body['item_id'] = itemId.toString();

  Response response;

  try {
    response = await http.post(Uri.parse(url), headers: headers, body: body);
  } on Exception {
    return false;
  } catch (e) {
    return false;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    return true;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return false;
}

// Удалить избранное
Future<bool> deleteFavorite(BuildContext context, int itemId) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/useritem/$itemId';

  var headers = new Map<String, String>();
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  var body = new Map<String, dynamic>();
  body['item_id'] = itemId;

  Response response;

  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return false;
  } catch (e) {
    return false;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    return true;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return false;
}

//выход из аккаунта
Future<Logout?> logout(BuildContext context) async {
  String url = 'https://recyclemap.tmweb.ru/api/v1/logout';

  var headers = new Map<String, String>();
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }

  Response response;

  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    Logout logout = logoutFromJson(response.body);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
    return logout;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return Authorisation();}), (Route<dynamic> route) => false);
  }
  return null;
}