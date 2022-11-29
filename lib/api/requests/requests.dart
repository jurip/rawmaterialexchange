import 'dart:convert' ;

import 'package:app/api/models/response_authorization.dart';
import 'package:app/api/models/response_get_favorites.dart';
import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/models/response_list_object_data.dart';
import 'package:app/api/models/response_list_object_working_hours.dart';
import 'package:app/api/models/response_list_of_contact_phone.dart';
import 'package:app/api/models/response_list_of_object.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/api/models/response_logout.dart';
import 'package:app/api/models/response_objects_from_filter.dart';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/models/response_verification.dart';
import 'package:app/api/models/server_response_when_requesting_registration.dart';
import 'package:app/main.dart';
import 'package:app/screens/authorisation.dart';
import 'package:app/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/Order.dart';
import '../models/material_list_item.dart';

final String api = 'https://recyclemap.tmweb.ru/api/v1/';
final String mapboxToken =
    'pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA';
//запрос на получение списка языков
Future<List<ListLanguages>?> getLanguages() async {
  String url = api + 'languages';

  Map<String, String> headers = initHeaders();

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

Map<String, String> initHeaders() {
  var headers = new Map<String, String>();
  //headers['authorization'] = 'Bearer' + ' ' + Settings.token;
  if (mainLocale != null) {
    headers['Accept-Language'] = mainLocale!.languageCode;
  } else {
    headers['Accept-Language'] = "ru";
  }
  headers['accept'] = "application/json";
  headers['authorization'] = 'Bearer' + ' ' + UserSession.token;
  return headers;
}

//регистрация
Future<ServerResponseWhenRequestingRegistration?> getRegistration(String name,
    String surname, String phone, String birthDate, int languageId) async {
  String url = api +
      'register?name=$name&surname=$surname&phone=$phone&language_id=$languageId&birth_date=$birthDate';

  Map<String, String> headers = initHeaders();

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  // if (200 <= response.statusCode && response.statusCode < 300) {
  ServerResponseWhenRequestingRegistration
      serverResponseWhenRequestingRegistration =
      ServerResponseWhenRequestingRegistration.fromJson(
          jsonDecode(response.body));
  return serverResponseWhenRequestingRegistration;
}

//верификация (смс - код)
Future<ResponseVerification?> getSMSCode(int code) async {
  String url = api + 'verification?sms_code=$code';

  Map<String, String> headers = initHeaders();

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  ResponseVerification responseVerification =
      ResponseVerification.fromJson(jsonDecode(response.body));
  return responseVerification;
}

//авторизация
Future<ResponseAuthorization?> getAuthorization(String phone) async {
  String url = api + 'login?phone=$phone';

  Map<String, String> headers = initHeaders();

  Response response;
  try {
    response = await http.post(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  // if (200 <= response.statusCode && response.statusCode < 300) {
  ResponseAuthorization responseAuthorization =
      ResponseAuthorization.fromJson(jsonDecode(response.body));
  return responseAuthorization;
}

//получение данных пользователя
Future<UserData?> getUserData(BuildContext context) async {
  String url = api + 'user';

  var headers = initHeaders();
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}

//запрос на получение списка сырья
Future<List<MaterialListItem>?> getListOfRawMaterials() async {
  String url = api + 'raws';

  var headers = initHeaders();
  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<MaterialListItem> listOfRawMaterials =
        listOfRawMaterialsFromJson(response.body);
    return listOfRawMaterials;
  }
  return null;
}

//запрос на получение списка сырья конкретного магазина
Future<List<ListOfRawMaterialsOfSpecificObject>?>
    getListOfRawMaterialsOfSpecificObject(int id, BuildContext context) async {
  String url = api + 'items/$id/raws';

  var headers = initHeaders();

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfRawMaterialsOfSpecificObject>
        listOfRawMaterialsOfSpecificObject =
        listOfRawMaterialsOfSpecificObjectFromJson(response.body);
    return listOfRawMaterialsOfSpecificObject;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}

//запрос на получение списка координат всех маркеров
Future<List<ListOfObjects>?> getListOfObjects(BuildContext context) async {
  String url = api + 'items';

  var headers = initHeaders();

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}

//запрос на получение данных обьекта
Future<ListObjectData?> getObjectData(int id) async {
  String url = api + 'items/$id';

  var headers = initHeaders();
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
  String url = api + 'items/$id/contacts';

  var headers = initHeaders();

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfContactPhone> listOfContactPhone =
        listOfContactPhoneFromJson(response.body);
    return listOfContactPhone;
  }
  return null;
}

//запрос на получение списка времени работы конкретного обьекта
Future<List<ListObjectWorkingHours>?> getListObjectWorkingHours(int id) async {
  String url = api + 'items/$id/working-hours';

  var headers = initHeaders();

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListObjectWorkingHours> listObjectWorkingHours =
        listObjectWorkingHoursFromJson(response.body);
    return listObjectWorkingHours;
  }
  return null;
}

//запрос на получение обьектов с фильтра
Future<List<ListOfObjectsFromFilter>?> getListOfObjectsInFilter(
    List<int> array, BuildContext context) async {
  String s = "";
  for (int index = 0; index < array.length; index++) {
    if (index == array.length - 1) {
      s += "raw_id[]=${array[index]}";
    } else {
      s += "raw_id[]=${array[index]}&";
    }
  }

  String url = api + 'items?$s';

  var headers = initHeaders();

  Response response;

  try {
    response = await http.get(Uri.parse(url), headers: headers);
  } on Exception {
    return null;
  } catch (e) {
    return null;
  }
  if (200 <= response.statusCode && response.statusCode < 300) {
    List<ListOfObjectsFromFilter> listOfObjectsFromFilter =
        listOfObjectsFromFilterFromJson(response.body);
    return listOfObjectsFromFilter;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}


//запрос для маршрута driving
Future<String?> getAddressCoordinates(
    BuildContext context, double lngMyLocation, double latMyLocation) async {
  //String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/30.090796,59.789816;30.134563,59.769149?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA&steps=true&language=ru';

  String url =
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$lngMyLocation,$latMyLocation.json?access_token=$mapboxToken';
  var headers = initHeaders();

  try {
    Response response = await http.get(Uri.parse(url), headers: headers);
    if (200 <= response.statusCode && response.statusCode < 300) {
      var responseJson = json.decode(response.body);
      String address = responseJson["features"][0]["text"].toString() +
          " " +
          responseJson["features"][0]["address"];

      return address;
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
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
  String url = api + 'useritems';

  var headers = initHeaders();

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}

// Добавить избранное
Future<bool> addFavorite(BuildContext context, int itemId) async {
  String url = api + 'useritems';

  var headers = initHeaders();

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return false;
}

Future<bool> addOrderToDB(BuildContext context, Order item) async {
  String url = api + 'orders';

  var headers = initHeaders();

  var body = new Map<String, String>();
  body['phone'] = item.phone;
  body['address'] = item.address;
  body['latitude'] = item.latitude.toString();
  body['longitude'] = item.longitude.toString();
  body['comment'] = item.comment;
  body['datetime_pickup'] = item.datetimePickup.toString();
  body['items'] = jsonEncode(item.items);

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return false;
}

Future<bool> addOrder(BuildContext context, Order item) async {
  String url = api + 'orders';

  var headers = initHeaders();

  var body = new Map<String, dynamic>();
  item.datetimePickup = item.datetimePickup +
      " " +
      item.time.toString().substring(0, 2) +
      ":00:00";
  item.items = item.items.where((element) => element.amount != 0).toList();

  body = item.toJson();

  Response response;

  http.get((Uri.parse("https://api.telegram.org/" +
      "bot5670549742:AAFYW_I0D9h4F0eCRbJ3YoDUBWu4AZG0lnI/" +
      "sendMessage?chat_id=@rawmaterialstest&text=" +
      item.toJson().toString())));
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return false;
}

// Удалить избранное
Future<bool> deleteFavorite(BuildContext context, int itemId) async {
  String url = api + 'useritem/$itemId';

  var headers = initHeaders();

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return false;
}

//выход из аккаунта
Future<Logout?> logout(BuildContext context) async {
  String url = api + 'logout';

  var headers = initHeaders();
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
    return logout;
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Authorisation();
    }), (Route<dynamic> route) => false);
  }
  return null;
}
