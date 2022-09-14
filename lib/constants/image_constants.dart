String imageName(int id) {
  return list[id];
}

var list = <String>[
  "",
  "paperboard",
  "tape",
  "plastic",
  "glass",
  "metal",
  "alyuminiy",
  "lead",
  "copper",
  "garbage"
];

String imageDefinitionInFilter(int id) {
  return 'images/' + list[id] + '.png';
}
