import 'dart:convert';

List<MaterialListItem> listOfRawMaterialsFromJson(String str) =>
    List<MaterialListItem>.from(
        json.decode(str).map((x) => MaterialListItem.fromJson(x)));

//String listOfRawMaterialsToJson(List<ListOfRawMaterials> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class MaterialListItem {
  MaterialListItem({
    required this.id,
    required this.name,
    this.selected = false,
    this.amount = 0,
    this.changedAmount = 300,
    this.price = 200,
    this.text =
        "Описание материала дйвкдхв додвй вкдх кдвх вкдх скхд скдх скдхксдхйс кд кх скдх скхдскхд скдх скдх скдх скх фвихдв2их",
  });

  int id;
  String name;
  bool selected;
  int amount;
  int changedAmount;
  int price;
  String text;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': amount,
    };
  }

  factory MaterialListItem.fromJson(Map<String, dynamic> json) =>
      MaterialListItem(
        id: json["id"],
        name: json["name"],
        //price: json["price"]
      );
}
