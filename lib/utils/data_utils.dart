import 'package:easy_localization/easy_localization.dart';

import '../api/models/response_get_favorites.dart';

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
String getWorkingHours(List<WorkingHour> hours) {
  String workingHours = '';
  if (hours.isNotEmpty) {
    for (var item in hours) {
      if (item.day != hours.last.day) {
        workingHours +=
            getDayString(item.day) + getStartEnd(item.start, item.end) + '\n';
      } else {
        workingHours +=
            getDayString(item.day) + getStartEnd(item.start, item.end);
      }
    }
  }
  return workingHours;
}

String getStartEnd(String start, String end) {
  String startFormatted = formatHours(start);
  String endFormatted = formatHours(end);
  return startFormatted + '-' + endFormatted;
}

String formatHours(String date) {
  DateTime parseDate = DateFormat('HH:mm:ss').parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('HH:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
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
