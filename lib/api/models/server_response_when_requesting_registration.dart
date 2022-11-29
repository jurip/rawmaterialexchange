import 'dart:convert';

ServerResponseWhenRequestingRegistration
    serverResponseWhenRequestingRegistrationFromJson(String str) =>
        ServerResponseWhenRequestingRegistration.fromJson(json.decode(str));

//String serverResponseWhenRequestingRegistrationToJson(ServerResponseWhenRequestingRegistration data) => json.encode(data.toJson());

class ServerResponseWhenRequestingRegistration {
  ServerResponseWhenRequestingRegistration({
    this.smsSended,
    this.smsCode,
    this.errors,
  });

  bool? smsSended;
  int? smsCode;
  List<String>? errors;

  factory ServerResponseWhenRequestingRegistration.fromJson(
          Map<String, dynamic> json) =>
      ServerResponseWhenRequestingRegistration(
        smsSended: json["sms_sended"],
        smsCode: json["sms_code"],
        errors: json["errors"] != null
            ? List<String>.from(json["errors"].map((x) => x))
            : null,
      );

// Map<String, dynamic> toJson() => {
//   "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
// };
}

class Datum {
  Datum({
    required this.smsCode,
  });

  int smsCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        smsCode: json["sms_code"],
      );

// Map<String, dynamic> toJson() => {
//   "sms_code": smsCode,
// };
}

class Error {
  Error({
    required this.nameInvalid,
    required this.surnameInvalid,
    required this.phoneInvalid,
    required this.languageIdInvalid,
    required this.birthDateInvalid,
  });

  String nameInvalid;
  String surnameInvalid;
  String phoneInvalid;
  String languageIdInvalid;
  String birthDateInvalid;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        nameInvalid: json["name_invalid"],
        surnameInvalid: json["surname_invalid"],
        phoneInvalid: json["phone_invalid"],
        languageIdInvalid: json["language_id_invalid"],
        birthDateInvalid: json["birth_date_invalid"],
      );

// Map<String, dynamic> toJson() => {
//   "name_invalid": nameInvalid,
//   "surname_invalid": surnameInvalid,
//   "phone_invalid": phoneInvalid,
//   "language_id_invalid": languageIdInvalid,
//   "birth_date_invalid": birthDateInvalid,
// };
}
