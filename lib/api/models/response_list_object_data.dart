import 'dart:convert';

ListObjectData listObjectDataFromJson(String str) =>
    ListObjectData.fromJson(json.decode(str));

//String listObjectDataToJson(ListObjectData data) => json.encode(data.toJson());

class ListObjectData {
  ListObjectData({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.pickUp,
    required this.faved,
  });

  int id;
  String address;
  double latitude;
  double longitude;
  String website;
  bool pickUp;
  bool faved;

  factory ListObjectData.fromJson(Map<String, dynamic> json) => ListObjectData(
        id: json["id"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        website: json["website"] ?? '',
        pickUp: json["pick_up"],
        faved: json["faved"],
      );

// Map<String, dynamic> toJson() => {
//   "id": id,
//   "address": address,
//   "latitude": latitude,
//   "longitude": longitude,
//   "website": website,
//   "pick_up": pickUp,
// };
}
