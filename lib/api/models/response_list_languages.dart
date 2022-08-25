import 'dart:convert';

List<ListLanguages> listLanguagesFromJson(String str) => List<ListLanguages>.from(json.decode(str).map((x) => ListLanguages.fromJson(x)));

class ListLanguages {
  ListLanguages({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory ListLanguages.fromJson(Map<String, dynamic> json) => ListLanguages(
    id: json["id"],
    name: json["name"],
  );
}