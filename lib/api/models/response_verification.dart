import 'dart:convert';

ResponseVerification responseVerificationFromJson(String str) =>
    ResponseVerification.fromJson(json.decode(str));

class ResponseVerification {
  ResponseVerification({
    this.accessToken,
    this.tokenType,
    this.errors,
    this.lang,
  });

  String? accessToken;
  String? tokenType;
  List<String>? errors;
  String? lang;

  factory ResponseVerification.fromJson(Map<String, dynamic> json) =>
      ResponseVerification(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        lang: "ru",
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );

}
