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
import 'package:app/api/requests/requests_prod.dart';
import 'package:app/main.dart';
import 'package:app/screens/authorisation.dart';
import 'package:app/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/Order.dart';
import '../models/material_list_item.dart';

abstract class MyRequests {
  getLocationInfo(int id, BuildContext context);
  Future<Map<String, Object>?> getObjectsGeojson(
      List<int> array, BuildContext context);

//регистрация
  Future<ServerResponseWhenRequestingRegistration?> getRegistration(String name,
      String surname, String phone, String birthDate, String languageId);
//верификация (смс - код)
  Future<ResponseVerification?> getVerificationResponse(int code, String phone);
//авторизация
  Future<ResponseAuthorization?> getAuthorization(String phone);

//получение данных пользователя
  Future<UserData?> getUserData(BuildContext context);

//запрос на получение списка сырья
  Future<List<MaterialListItem>?> getListOfRawMaterials();
//запрос на получение списка координат всех маркеров
  Future<List<ListOfObjects>?> getListOfObjects(BuildContext context);

  Future<String?> getAddressCoordinates(
      BuildContext context, double lngMyLocation, double latMyLocation);

// Получение списка избранных
  Future<List<GetFavorites>?> getFavorites(BuildContext context);

// Добавить избранное
  Future<bool> addFavorite(BuildContext context, int itemId);

  Future<bool> addOrder(BuildContext context, Order item);

// Удалить избранное
  Future<bool> deleteFavorite(BuildContext context, int itemId);

//выход из аккаунта
  Future<Logout?> logout(BuildContext context);
}

class MyRequestsDev extends MyRequests {
  Future<LocationInfo> getLocationInfo(int id, BuildContext context) async {
    return LocationInfo(
        0,
        [],
        [],
        ListObjectData(
            address: "",
            faved: false,
            id: 0,
            latitude: 0,
            longitude: 0,
            website: "",
            pickUp: false),
        []);
  }

  @override
  Future<bool> addFavorite(BuildContext context, int itemId) async {
    return true;
  }

  @override
  Future<bool> addOrder(BuildContext context, Order item) async {
    return true;
  }

  @override
  Future<bool> deleteFavorite(BuildContext context, int itemId) async {
    return true;
  }

  @override
  Future<String?> getAddressCoordinates(
      BuildContext context, double lngMyLocation, double latMyLocation) async {
    return 'address';
  }

  @override
  Future<ResponseAuthorization?> getAuthorization(String phone) async {
    return ResponseAuthorization(smsSended: true, smsCode: 1234);
  }

  @override
  Future<List<GetFavorites>?> getFavorites(BuildContext context) async {
    return [];
  }

  @override
  Future<List<ListOfObjects>?> getListOfObjects(BuildContext context) async {
    return [];
  }

  @override
  Future<List<MaterialListItem>?> getListOfRawMaterials() async {
    return [
      MaterialListItem(
          minAmount: 10,
          name: 'sdsd',
          id: 1,
          text: 'edededwd',
          changedAmount: 0,
          price: 600,
          selected: false)
    ];
  }

  @override
  Future<ServerResponseWhenRequestingRegistration?> getRegistration(String name,
      String surname, String phone, String birthDate, String languageId) async {
    return ServerResponseWhenRequestingRegistration();
  }

  @override
  Future<ResponseVerification?> getVerificationResponse(int code, String phone) async {
    return ResponseVerification(
      accessToken: 'token',
    );
  }

  @override
  Future<UserData?> getUserData(BuildContext context) async {
    return UserData(
        id: 0,
        name: "name",
        surname: "surname",
        phone: "phone",
        languageId: 1,
        birthDate: DateTime.now());
  }

  @override
  Future<Logout?> logout(BuildContext context) async {
    return Logout();
  }

  @override
  Future<Map<String, Object>?> getObjectsGeojson(
      List<int> array, BuildContext context) async {
    return {};
  }
}

