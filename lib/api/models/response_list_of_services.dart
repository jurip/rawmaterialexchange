
class Service {
  Service({
    required this.id,
    required this.name,
    this.selected = false,
    required this.image,
  });

  int id;
  String name;
  bool selected;
  String image;


// Map<String, dynamic> toJson() => {
//   "id": id,
//   "name": name,
// };
}
