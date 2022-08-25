import 'dart:convert';

List<GetFavorites> getFavoritesFromJson(String str) => List<GetFavorites>.from(json.decode(str).map((x) => GetFavorites.fromJson(x)));

class GetFavorites {
  GetFavorites({
    required this.itemId,
    required this.item,
  });

  int itemId;
  Item item;

  factory GetFavorites.fromJson(Map<String, dynamic> json) => GetFavorites(
    itemId: json["item_id"],
    item: Item.fromJson(json["item"]),
  );
}

class Item {
  Item({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.pickUp,
    required this.faved,
    required this.contacts,
    required this.raws,
    required this.workingHours,
  });

  int id;
  String address;
  double latitude;
  double longitude;
  String website;
  bool pickUp;
  bool faved;
  List<Contact> contacts;
  List<Raw> raws;
  List<WorkingHour> workingHours;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    address: json["address"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    website: json["website"] == null ? '' : json["website"],
    pickUp: json["pick_up"],
    faved: json["faved"],
    contacts: List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
    raws: List<Raw>.from(json["raws"].map((x) => Raw.fromJson(x))),
    workingHours: List<WorkingHour>.from(json["working_hours"].map((x) => WorkingHour.fromJson(x))),
  );
}

class Contact {
  Contact({
    required this.value,
  });

  String value;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    value: json["value"],
  );
}

class Raw {
  Raw({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Raw.fromJson(Map<String, dynamic> json) => Raw(
    id: json["id"],
    name: json["name"],
  );
}

class WorkingHour {
  WorkingHour({
    required this.day,
    required this.start,
    required this.end,
  });

  int day;
  String start;
  String end;

  factory WorkingHour.fromJson(Map<String, dynamic> json) => WorkingHour(
    day: json["day"],
    start: json["start"],
    end: json["end"],
  );
}
