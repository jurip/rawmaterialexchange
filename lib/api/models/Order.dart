import 'dart:math';
import 'dart:convert';
import 'package:app/api/models/material_list_item.dart';


class Order{
  var phone;
  var address;
  var latitude;
  var longitude;
  var comment;
  var datetimePickup;
  late List<MaterialListItem> items;
  var time;
  Map<int, dynamic> getItems(){
    var result = new Map<int, dynamic>();
    items.forEach((MaterialListItem element) {
      result.putIfAbsent(element.id, () => element.toJson());
    });
    return result;
  }
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'address': address,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'comment': comment,
      'datetime_pickup': datetimePickup,
      'items': json.encode(items),
    };
  }

}