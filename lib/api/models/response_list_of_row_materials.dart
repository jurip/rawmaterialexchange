import 'dart:convert';

List<ListOfRawMaterials> listOfRawMaterialsFromJson(String str) =>
    List<ListOfRawMaterials>.from(
        json.decode(str).map((x) => ListOfRawMaterials.fromJson(x)));

//String listOfRawMaterialsToJson(List<ListOfRawMaterials> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class ListOfRawMaterials {
  ListOfRawMaterials({
    required this.id,
    required this.name,
    this.selectedRawMaterials = false,
    this.amount = 0,
    this.changedAmount = 300,
    this.price = 2,
    this.text =
        "Описание материала дйвкдхв додвй вкдх кдвх вкдх скхд скдх скдхксдхйс кд кх скдх скхдскхд скдх скдх скдх скх фвихдв2их",
  });

  int id;
  String name;
  bool selectedRawMaterials;
  int amount;
  int changedAmount;
  int price;
  String text;

  factory ListOfRawMaterials.fromJson(Map<String, dynamic> json) =>
      ListOfRawMaterials(
        id: json["id"],
        name: json["name"],
      );
// Map<String, dynamic> toJson() => {
//   "id": id,
//   "name": name,
// };
}
