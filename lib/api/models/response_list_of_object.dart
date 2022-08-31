import 'dart:convert';

List<ListOfObjects> listOfObjectsFromJson(String str) =>
    List<ListOfObjects>.from(
        json.decode(str).map((x) => ListOfObjects.fromJson(x)));

//String listOfObjectsToJson(List<ListOfObjects> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfObjects {
  ListOfObjects({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.pickUp,
  });

  int id;
  String address;
  double latitude;
  double longitude;
  String website;
  bool pickUp;

  factory ListOfObjects.fromJson(Map<String, dynamic> json) => ListOfObjects(
        id: json["id"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        website: json["website"] == null ? "" : json["website"],
        pickUp: json["pick_up"],
      );

// Map<String, dynamic> toJson() => {
//   "id": id,
//   "address": address,
//   "latitude": latitude,
//   "longitude": longitude,
//   "website": website == null ? null : website,
//   "pick_up": pickUp,
// };
}
