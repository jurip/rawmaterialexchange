import 'dart:convert';

List<ListOfObjectsFromFilter> listOfObjectsFromFilterFromJson(String str) =>
    List<ListOfObjectsFromFilter>.from(
        json.decode(str).map((x) => ListOfObjectsFromFilter.fromJson(x)));

//String listOfObjectsFromFilterToJson(List<ListOfObjectsFromFilter> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfObjectsFromFilter {
  ListOfObjectsFromFilter({
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

  factory ListOfObjectsFromFilter.fromJson(Map<String, dynamic> json) =>
      ListOfObjectsFromFilter(
        id: json["id"],
        address: json["address"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        website: json["website"] ?? '',
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
