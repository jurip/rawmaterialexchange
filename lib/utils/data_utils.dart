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
String getDayString(int dayNumber) {
  String selectedDayOfTheWeek = "";
  if (dayNumber == 0) {
    selectedDayOfTheWeek = 'pn';
  } else if (dayNumber == 1) {
    selectedDayOfTheWeek = 'vt';
  } else if (dayNumber == 2) {
    selectedDayOfTheWeek = 'sr';
  } else if (dayNumber == 3) {
    selectedDayOfTheWeek = 'cht';
  } else if (dayNumber == 4) {
    selectedDayOfTheWeek = 'pt';
  } else if (dayNumber == 5) {
    selectedDayOfTheWeek = 'sb';
  } else if (dayNumber == 6) {
    selectedDayOfTheWeek = 'vs';
  }
  return selectedDayOfTheWeek;
}
