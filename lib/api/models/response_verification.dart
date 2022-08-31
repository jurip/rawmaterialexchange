import 'dart:convert';

ResponseVerification responseVerificationFromJson(String str) =>
    ResponseVerification.fromJson(json.decode(str));

//String responseVerificationToJson(ResponseVerification data) => json.encode(data.toJson());

class ResponseVerification {
  ResponseVerification({
    this.accessToken,
    this.tokenType,
    this.errors,
  });

  String? accessToken;
  String? tokenType;
  List<String>? errors;

  factory ResponseVerification.fromJson(Map<String, dynamic> json) =>
      ResponseVerification(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );

// Map<String, dynamic> toJson() => {
//   "access_token": accessToken,
//   "token_type": tokenType,
//   "errors": List<dynamic>.from(errors.map((x) => x)),
// };
}
