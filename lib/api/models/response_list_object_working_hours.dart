import 'dart:convert';

List<ListObjectWorkingHours> listObjectWorkingHoursFromJson(String str) =>
    List<ListObjectWorkingHours>.from(
        json.decode(str).map((x) => ListObjectWorkingHours.fromJson(x)));

//String listObjectWorkingHoursToJson(List<ListObjectWorkingHours> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListObjectWorkingHours {
  ListObjectWorkingHours({
    required this.day,
    required this.start,
    required this.end,
  });

  int day;
  String start;
  String end;

  factory ListObjectWorkingHours.fromJson(Map<String, dynamic> json) =>
      ListObjectWorkingHours(
        day: json["day"],
        start: json["start"],
        end: json["end"],
      );

// Map<String, dynamic> toJson() => {
//   "day": day,
//   "start": start,
//   "end": end,
// };
}
