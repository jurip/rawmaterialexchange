import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

//String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.languageId,
    required this.birthDate,
  });

  int id;
  String name;
  String surname;
  String phone;
  int languageId;
  DateTime birthDate;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        phone: json["phone"],
        languageId: json["language_id"],
        birthDate: DateTime.parse(json["birth_date"]),
      );

// Map<String, dynamic> toJson() => {
//   "id": id,
//   "name": name,
//   "surname": surname,
//   "phone": phone,
//   "language_id": languageId,
//   "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
// };
}
