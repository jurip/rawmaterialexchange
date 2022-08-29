import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/api/models/response_get_favorites.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class FavouritesBottomSheet extends StatefulWidget {
  const FavouritesBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _FavouritesBottomSheetState createState() => _FavouritesBottomSheetState();
}

class _FavouritesBottomSheetState extends State<FavouritesBottomSheet> {

  List<GetFavorites> favorites = [];

  @override
  void initState() {
    super.initState();
    getFavorites(context).then((value) {
      setState(() {
        favorites = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return favorites == null ? Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.transparent, color: Colors.green,),
      ),
    ) : Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: kColorGrey1,
                ),
                height: 4.0,
                width: 42.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 23.0, left: 16.0, right: 16.0),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.keyboard_arrow_left, size: 30.0,),
                ),
                Center(child: Text('favourites'.tr(), style: kAlertTextStyle)),
              ],
            ),
          ),
          Expanded(
            child: favorites.isEmpty ? Center(
              child: Text('you_dont_have_favorites'.tr(), style: TextStyle(color: Colors.grey, fontSize: 20.0, fontFamily: 'GothamProNarrow-Medium'),),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                    favorites[index].item.address,
                                    style: kTextStyle2,
                                    softWrap: true,
                                  ),
                              ),
                              InkWell(
                                onTap: () {
                                  deleteFavorite(context, favorites[index].itemId).then((value) {
                                    if (value) setState(() {
                                      favorites.removeAt(index);
                                    });
                                  });
                                },
                                  child: Icon(Icons.star, color: Colors.yellow),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Text(getWorkingHours(favorites[index].item.workingHours)),
                          SizedBox(height: 5.0),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'types_of_raw_materials'.tr(), style: kBottomSheetTextStyle2),
                                TextSpan(text: getMaterials(favorites[index].item.raws), style: kBottomSheetTextStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String selectedDayOfTheWeek = '';

  String getDayString(int dayNumber) {
    if (dayNumber == 0) {
      selectedDayOfTheWeek = 'pn'.tr() + ': ';
    } else if (dayNumber == 1) {
      selectedDayOfTheWeek = 'vt'.tr() + ': ';
    } else if (dayNumber == 2) {
      selectedDayOfTheWeek = 'sr'.tr() + ': ';
    } else if (dayNumber == 3) {
      selectedDayOfTheWeek = 'cht'.tr() + ': ';
    } else if (dayNumber == 4) {
      selectedDayOfTheWeek = 'pt'.tr() + ': ';
    } else if (dayNumber == 5) {
      selectedDayOfTheWeek = 'sb'.tr() + ': ';
    } else if (dayNumber == 6) {
      selectedDayOfTheWeek = 'vs'.tr() + ': ';
    }
    return selectedDayOfTheWeek;
  }

  String getWorkingHours(List<WorkingHour> hours) {
    String workingHours = '';
    if (hours.isNotEmpty) {
      for (var item in hours) {
        if (item.day != hours.last.day) {
          workingHours += getDayString(item.day) + getStartEnd(item.start, item.end) + '\n';
        } else {
          workingHours += getDayString(item.day) + getStartEnd(item.start, item.end);
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

  String getMaterials(List<Raw> raws) {
    String result = "";
    if (raws.isNotEmpty) {
      for (var item in raws) {
        if (item.id != raws.last.id) {
          result += item.name + ", ";
        } else {
          result += item.name;
        }
      }
    }
    return result;
  }
}
