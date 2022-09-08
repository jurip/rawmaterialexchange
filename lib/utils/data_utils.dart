String definitionLanguage(int? id) {
  String language = 'ru';
  if (id == 2) {
    language = 'uz';
  } else if (id == 3) {
    language = 'tj';
  } else if (id == 4) {
    language = 'kg';
  }
  return language;
}
