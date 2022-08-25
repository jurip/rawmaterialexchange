import 'dart:convert';

Logout logoutFromJson(String str) => Logout.fromJson(json.decode(str));

class Logout {
  Logout({
    this.message,
  });

  String? message;

  factory Logout.fromJson(Map<String, dynamic> json) => Logout(
    message: json["message"],
  );
}
