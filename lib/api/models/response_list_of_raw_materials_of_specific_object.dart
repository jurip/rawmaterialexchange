import 'dart:convert';

import '../../constants/image_constants.dart';

List<ListOfRawMaterialsOfSpecificObject>
    listOfRawMaterialsOfSpecificObjectFromJson(String str) =>
        List<ListOfRawMaterialsOfSpecificObject>.from(json
            .decode(str)
            .map((x) => ListOfRawMaterialsOfSpecificObject.fromJson(x)));

//String listOfRawMaterialsOfSpecificObjectToJson(List<ListOfRawMaterialsOfSpecificObject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfRawMaterialsOfSpecificObject {
  ListOfRawMaterialsOfSpecificObject({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  int id;
  String name;
  int price;
  String image;

  factory ListOfRawMaterialsOfSpecificObject.fromJson(
          Map<String, dynamic> json) =>
      ListOfRawMaterialsOfSpecificObject(
        id: json["id"],
        name: json["name"],
        price: json["price"] ?? 0,
        image: imageName(json["id"])

      );

// Map<String, dynamic> toJson() => {
//   "name": name,
//   "price": price == null ? null : price,
// };
}
