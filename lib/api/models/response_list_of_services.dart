import 'dart:convert';

List<ListOfRawMaterials> listOfRawMaterialsFromJson(String str) => List<ListOfRawMaterials>.from(json.decode(str).map((x) => ListOfRawMaterials.fromJson(x)));

//String listOfRawMaterialsToJson(List<ListOfRawMaterials> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class ListOfRawMaterials {
  ListOfRawMaterials({
    required this.id,
    required this.name,
    this.selectedRawMaterials  = false,
  });

  int id;
  String name;
  bool selectedRawMaterials;

  factory ListOfRawMaterials.fromJson(Map<String, dynamic> json) => ListOfRawMaterials(
    id: json["id"],
    name: json["name"],
  );
  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "name": name,
  // };
}
