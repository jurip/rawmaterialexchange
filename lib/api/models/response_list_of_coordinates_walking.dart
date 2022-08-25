import 'dart:convert';

RouteWalking routeWalkingFromJson(String str) => RouteWalking.fromJson(json.decode(str));

//String routeWalkingToJson(RouteWalking data) => json.encode(data.toJson());

class RouteWalking {
  RouteWalking({
    required this.routes,
    // required this.waypoints,
    // required this.code,
    // required this.uuid,
  });

  List<Route> routes;
  // List<Waypoint> waypoints;
  // String code;
  // String uuid;

  factory RouteWalking.fromJson(Map<String, dynamic> json) => RouteWalking(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    // waypoints: List<Waypoint>.from(json["waypoints"].map((x) => Waypoint.fromJson(x))),
    // code: json["code"],
    // uuid: json["uuid"],
  );

  // Map<String, dynamic> toJson() => {
  //   "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
  //   "waypoints": List<dynamic>.from(waypoints.map((x) => x.toJson())),
  //   "code": code,
  //   "uuid": uuid,
  // };
}

class Route {
  Route({
    // required this.weightName,
    // required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    //required this.geometry,
  });

  // String weightName;
  // double weight;
  double duration;
  double distance;
  List<Leg> legs;
  //String geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    //weightName: json["weight_name"],
    //weight: json["weight"].toDouble(),
    duration: json["duration"].toDouble(),
    distance: json["distance"].toDouble(),
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
    //geometry: json["geometry"],
  );

  // Map<String, dynamic> toJson() => {
  //   "weight_name": weightName,
  //   "weight": weight,
  //   "duration": duration,
  //   "distance": distance,
  //   "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
  //   "geometry": geometry,
  // };
}

class Leg {
  Leg({
    //required this.viaWaypoints,
    //required this.admins,
    //required this.weight,
    //required this.duration,
    required this.steps,
    //required this.distance,
    //required this.summary,
  });

  //List<dynamic> viaWaypoints;
  //List<Admin> admins;
  //double weight;
  //double duration;
  List<Step> steps;
  //double distance;
  //String summary;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    //viaWaypoints: List<dynamic>.from(json["via_waypoints"].map((x) => x)),
    //admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
    //weight: json["weight"].toDouble(),
    //duration: json["duration"].toDouble(),
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
    //distance: json["distance"].toDouble(),
    //summary: json["summary"],
  );

  // Map<String, dynamic> toJson() => {
  //   "via_waypoints": List<dynamic>.from(viaWaypoints.map((x) => x)),
  //   "admins": List<dynamic>.from(admins.map((x) => x.toJson())),
  //   "weight": weight,
  //   "duration": duration,
  //   "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
  //   "distance": distance,
  //   "summary": summary,
  // };
}

class Admin {
  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  String iso31661Alpha3;
  String iso31661;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    iso31661Alpha3: json["iso_3166_1_alpha3"],
    iso31661: json["iso_3166_1"],
  );

  // Map<String, dynamic> toJson() => {
  //   "iso_3166_1_alpha3": iso31661Alpha3,
  //   "iso_3166_1": iso31661,
  // };
}

class Step {
  Step({
    required this.intersections,
    // required this.maneuver,
    // required this.name,
    // required this.duration,
    // required this.distance,
    // required this.drivingSide,
    // required this.weight,
    // required this.mode,
    // required this.geometry,
  });

  List<Intersection> intersections;
  // Maneuver maneuver;
  // String name;
  // double duration;
  // double distance;
  // String drivingSide;
  // double weight;
  // String mode;
  // String geometry;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    intersections: List<Intersection>.from(json["intersections"].map((x) => Intersection.fromJson(x))),
    // maneuver: Maneuver.fromJson(json["maneuver"]),
    // name: json["name"],
    // duration: json["duration"].toDouble(),
    // distance: json["distance"].toDouble(),
    // drivingSide: json["driving_side"],
    // weight: json["weight"].toDouble(),
    // mode: json["mode"],
    // geometry: json["geometry"],
  );

  // Map<String, dynamic> toJson() => {
  //   "intersections": List<dynamic>.from(intersections.map((x) => x.toJson())),
  //   "maneuver": maneuver.toJson(),
  //   "name": name,
  //   "duration": duration,
  //   "distance": distance,
  //   "driving_side": drivingSide,
  //   "weight": weight,
  //   "mode": mode,
  //   "geometry": geometry,
  // };
}

class Intersection {
  Intersection({
    // required this.bearings,
    // required this.entry,
    // required this.mapboxStreetsV8,
    // required this.isUrban,
    // required this.adminIndex,
    // required this.out,
    // required this.geometryIndex,
    required this.location,
    // required this.intersectionIn,
    // required this.turnWeight,
    // required this.duration,
    // required this.weight,
  });

  // List<int> bearings;
  // List<bool> entry;
  // MapboxStreetsV8 mapboxStreetsV8;
  // bool isUrban;
  // int adminIndex;
  // int out;
  // int geometryIndex;
  List<double> location;
  // int intersectionIn;
  // int turnWeight;
  // double duration;
  // double weight;

  factory Intersection.fromJson(Map<String, dynamic> json) => Intersection(
    // bearings: List<int>.from(json["bearings"].map((x) => x)),
    // entry: List<bool>.from(json["entry"].map((x) => x)),
    // mapboxStreetsV8: json["mapbox_streets_v8"] == null ? null : MapboxStreetsV8.fromJson(json["mapbox_streets_v8"]),
    // isUrban: json["is_urban"] == null ? null : json["is_urban"],
    // adminIndex: json["admin_index"],
    // out: json["out"] == null ? null : json["out"],
    // geometryIndex: json["geometry_index"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
    // intersectionIn: json["in"] == null ? null : json["in"],
    // turnWeight: json["turn_weight"] == null ? null : json["turn_weight"],
    // duration: json["duration"] == null ? null : json["duration"].toDouble(),
    // weight: json["weight"] == null ? null : json["weight"].toDouble(),
  );

  // Map<String, dynamic> toJson() => {
  //   "bearings": List<dynamic>.from(bearings.map((x) => x)),
  //   "entry": List<dynamic>.from(entry.map((x) => x)),
  //   "mapbox_streets_v8": mapboxStreetsV8 == null ? null : mapboxStreetsV8.toJson(),
  //   "is_urban": isUrban == null ? null : isUrban,
  //   "admin_index": adminIndex,
  //   "out": out == null ? null : out,
  //   "geometry_index": geometryIndex,
  //   "location": List<dynamic>.from(location.map((x) => x)),
  //   "in": intersectionIn == null ? null : intersectionIn,
  //   "turn_weight": turnWeight == null ? null : turnWeight,
  //   "duration": duration == null ? null : duration,
  //   "weight": weight == null ? null : weight,
  // };
}

class MapboxStreetsV8 {
  MapboxStreetsV8({
    required this.mapboxStreetsV8Class,
  });

  String mapboxStreetsV8Class;

  factory MapboxStreetsV8.fromJson(Map<String, dynamic> json) => MapboxStreetsV8(
    mapboxStreetsV8Class: json["class"],
  );

  // Map<String, dynamic> toJson() => {
  //   "class": mapboxStreetsV8Class,
  // };
}

class Maneuver {
  Maneuver({
    required this.type,
    required this.instruction,
    required this.bearingAfter,
    required this.bearingBefore,
    required this.location,
    required this.modifier,
  });

  String type;
  String instruction;
  int bearingAfter;
  int bearingBefore;
  List<double> location;
  String modifier;

  factory Maneuver.fromJson(Map<String, dynamic> json) => Maneuver(
    type: json["type"],
    instruction: json["instruction"],
    bearingAfter: json["bearing_after"],
    bearingBefore: json["bearing_before"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
    modifier: json["modifier"] == null ? null : json["modifier"],
  );

  // Map<String, dynamic> toJson() => {
  //   "type": type,
  //   "instruction": instruction,
  //   "bearing_after": bearingAfter,
  //   "bearing_before": bearingBefore,
  //   "location": List<dynamic>.from(location.map((x) => x)),
  //   "modifier": modifier == null ? null : modifier,
  // };
}

class Waypoint {
  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  double distance;
  String name;
  List<double> location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    distance: json["distance"].toDouble(),
    name: json["name"],
    location: List<double>.from(json["location"].map((x) => x.toDouble())),
  );

  // Map<String, dynamic> toJson() => {
  //   "distance": distance,
  //   "name": name,
  //   "location": List<dynamic>.from(location.map((x) => x)),
  // };
}
