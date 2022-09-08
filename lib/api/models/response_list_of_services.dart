import 'dart:convert';

List<Service> listOfRawMaterialsFromJson(String str) =>
    List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

//String listOfRawMaterialsToJson(List<ListOfRawMaterials> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Service {
  Service({
    required this.id,
    required this.name,
    this.selected = false,
  });

  int id;
  String name;
  bool selected;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
      );
// Map<String, dynamic> toJson() => {
//   "id": id,
//   "name": name,
// };
}
