import 'dart:convert';

import 'package:app/api/models/response_authorization.dart';
import 'package:app/api/models/response_get_favorites.dart';
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
import 'package:app/api/requests/requests.dart';
import 'package:app/main.dart';
import 'package:app/screens/authorisation.dart';
import 'package:app/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/Order.dart';
import '../models/material_list_item.dart';

class MyRequestsProd extends MyRequests {
  Future<LocationInfo> getLocationInfo(int id, BuildContext context) async {
    var materials = await _getListOfRawMaterialsOfSpecificObject(id, context);
    var workingHours = await _getListObjectWorkingHours(id);
    var dataObjects = await _getObjectData(id);
    var dataContact = await _getListOfContactPhone(id);

    return LocationInfo(
        id, materials!, workingHours!, dataObjects!, dataContact!);
  }

  final String api = 'https://recyclemap.tmweb.ru/api/v1/';

  Map<String, String> _initHeaders() {
    var headers = new Map<String, String>();
    //headers['authorization'] = 'Bearer' + ' ' + token;
    if (mainLocale != null) {
      headers['Accept-Language'] = mainLocale!.languageCode;
    } else {
      headers['Accept-Language'] = "ru";
    }
    headers['accept'] = "application/json";
    headers['authorization'] = 'Bearer' + ' ' + UserSession.token;
    return headers;
  }

  Future<Map<String, Object>?> getObjectsGeojson(
      List<int> array, BuildContext context) async {
    var fs = [];
    List<ListOfObjectsFromFilter>? list =
        await _getListOfObjectsInFilter(array, context);
    if (list == null) {
      return null;
    }
    list.forEach((element) {
      fs.add({
        "type": "Feature",
        "id": element.id,
        "properties": {
          "type": "rawmaterialpoint",
        },
        "geometry": {
          "type": "Point",
          "coordinates": [element.longitude, element.latitude]
        }
      });
    });
    Map<String, Object> _geo = {"type": "FeatureCollection", "features": fs};
    return _geo;
  }

//регистрация
  Future<ServerResponseWhenRequestingRegistration?> getRegistration(String name,
      String surname, String phone, String birthDate, String languageId) async {
    var l = {'ru': 1, 'kk': 2, 'uz': 3};
    String url = api +
        'register?name=$name&surname=$surname&phone=$phone&language_id=${l[languageId]}&birth_date=$birthDate';

    Map<String, String> headers = _initHeaders();

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
  Future<ResponseVerification?> getVerificationResponse(int code, String phone) async {
    String url = api + 'verification?sms_code=$code&phone=$phone';

    Map<String, String> headers = _initHeaders();

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

    Map<String, String> headers = _initHeaders();

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

    var headers = _initHeaders();
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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }

//запрос на получение списка сырья
  Future<List<MaterialListItem>?> getListOfRawMaterials() async {
    String url = api + 'raws?for_filter=1';

    var headers = _initHeaders();
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
      _getListOfRawMaterialsOfSpecificObject(
          int id, BuildContext context) async {
    String url = api + 'items/$id/raws';

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }

//запрос на получение списка координат всех маркеров
  Future<List<ListOfObjects>?> getListOfObjects(BuildContext context) async {
    String url = api + 'items';

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }

//запрос на получение данных обьекта
  Future<ListObjectData?> _getObjectData(int id) async {
    String url = api + 'items/$id';

    var headers = _initHeaders();
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
  Future<List<ListOfContactPhone>?> _getListOfContactPhone(int id) async {
    String url = api + 'items/$id/contacts';

    var headers = _initHeaders();

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
  Future<List<ListObjectWorkingHours>?> _getListObjectWorkingHours(
      int id) async {
    String url = api + 'items/$id/working-hours';

    var headers = _initHeaders();

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
  Future<List<ListOfObjectsFromFilter>?> _getListOfObjectsInFilter(
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

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }

  Future<String?> getAddressCoordinates(
      BuildContext context, double lngMyLocation, double latMyLocation) async {
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lngMyLocation,$latMyLocation.json?access_token=${dotenv.env["ACCESS_TOKEN"]}';
    var headers = _initHeaders();

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

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }

// Добавить избранное
  Future<bool> addFavorite(BuildContext context, int itemId) async {
    String url = api + 'useritems';

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return false;
  }

  Future<bool> _saveOrder(BuildContext context, Order item) async {
    String url = api + 'orders';

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return false;
  }

  Future<bool> addOrder(BuildContext context, Order item) async {
    String url = api + 'orders';

    var headers = _initHeaders();

    var body = new Map<String, dynamic>();
    item.datetimePickup = item.datetimePickup +
        " " +
        item.time.toString().substring(0, 2) +
        ":00:00";
    item.items = item.items.where((element) => element.amount != 0).toList();

    body = item.toJson();

    Response response;

    String r = "Телефон: " +
        item.phone.toString() +
        "%0A" +
        "Адрес: " +
        item.address.toString() +
        "%0A" +
        "Комментарий: " +
        item.comment.toString() +
        "%0A" +
        "Дата вывоза: " +
        item.datetimePickup.toString() +
        "%0A" +
        "Состав: %0A";
    int sum = 0;
    item.items.forEach((element) {
      int rowTotal = element.amount * element.price;
      sum = sum + rowTotal;
      r = r +
          "* " +
          element.name +
          " - " +
          element.amount.toString() +
          " кг - " +
          element.price.toString() +
          " руб/кг - " +
          rowTotal.toString() +
          "руб%0A";
    });

    r = r + "Всего: " + sum.toString() + " рублей%0A";

    try {
      Response tr = await http.get((Uri.parse("https://api.telegram.org/" +
          "bot5670549742:AAFYW_I0D9h4F0eCRbJ3YoDUBWu4AZG0lnI/" +
          "sendMessage?chat_id=-1001710971907&text=" +
          r)));
      print(tr);
    } on Exception {
      return false;
    } catch (e) {
      return false;
    }
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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return false;
  }

// Удалить избранное
  Future<bool> deleteFavorite(BuildContext context, int itemId) async {
    String url = api + 'useritem/$itemId';

    var headers = _initHeaders();

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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return false;
  }

//выход из аккаунта
  Future<Logout?> logout(BuildContext context) async {
    String url = api + 'logout';

    var headers = _initHeaders();
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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
      return logout;
    } else if (response.statusCode == 401) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Authorisation();
      }), (Route<dynamic> route) => false);
    }
    return null;
  }
}

class LocationInfo {
  LocationInfo(this.id, this.materials, this.workingHours, this.listObjectData,
      this.phones);
  int id;
  List<ListOfRawMaterialsOfSpecificObject> materials;
  List<ListObjectWorkingHours> workingHours;
  ListObjectData listObjectData;
  List<ListOfContactPhone> phones;
}
