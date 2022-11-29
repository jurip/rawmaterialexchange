import 'dart:convert';

List<MaterialListItem> listOfRawMaterialsFromJson(String str) =>
    List<MaterialListItem>.from(
        json.decode(str).map((x) => MaterialListItem.fromJson(x)));

class MaterialListItem {
  MaterialListItem({
    required this.id,
    required this.name,
    this.selected = false,
    this.amount = 0,
    required this.changedAmount,
    required this.price,
    required this.minAmount,
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
  int minAmount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': amount,
    'name': name,
    'price': price,
    };
  }

  factory MaterialListItem.fromJson(Map<String, dynamic> json) =>
      MaterialListItem(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        minAmount: json["weight"],
        changedAmount: json["weight"]
      );
}
