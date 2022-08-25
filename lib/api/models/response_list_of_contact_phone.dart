import 'dart:convert';

List<ListOfContactPhone> listOfContactPhoneFromJson(String str) => List<ListOfContactPhone>.from(json.decode(str).map((x) => ListOfContactPhone.fromJson(x)));

//String listOfContactPhoneToJson(List<ListOfContactPhone> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfContactPhone {
  ListOfContactPhone({
    required this.value,
  });

  String value;

  factory ListOfContactPhone.fromJson(Map<String, dynamic> json) => ListOfContactPhone(
    value: json["value"],
  );

  // Map<String, dynamic> toJson() => {
  //   "value": value,
  // };
}
