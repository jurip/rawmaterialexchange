import 'dart:convert';

ResponseAuthorization responseAuthorizationFromJson(String str) =>
    ResponseAuthorization.fromJson(json.decode(str));

//String responseAuthorizationToJson(ResponseAuthorization data) => json.encode(data.toJson());

class ResponseAuthorization {
  ResponseAuthorization({
    this.smsSended,
    this.smsCode,
    this.errors,
  });

  bool? smsSended;
  int? smsCode;
  List<String>? errors;

  factory ResponseAuthorization.fromJson(Map<String, dynamic> json) =>
      ResponseAuthorization(
        smsSended: json["sms_sended"],
        smsCode: json["sms_code"],
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );

}
