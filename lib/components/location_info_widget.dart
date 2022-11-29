import 'package:app/api/models/response_list_object_data.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/models/response_list_object_working_hours.dart';
import '../api/models/response_list_of_contact_phone.dart';
import '../api/requests/requests.dart';
import '../constants/color_constants.dart';
import '../constants/style_constants.dart';

class LocationInfoWidget extends StatefulWidget {
  final List<ListOfRawMaterialsOfSpecificObject>? materials;

  final int selectedIndexMarker;

  LocationInfoWidget({
    Key? key,
     this.materials,
    required this.selectedIndexMarker,
  }) : super(key: key);

  @override
  _LocationInfoWidgetState createState() => _LocationInfoWidgetState();
}

class _LocationInfoWidgetState extends State<LocationInfoWidget> {
  String address = "";
  double income = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    getListObjectWorkingHoursAddToList();
    getObjectDataAddDataToList();
    getContactPhoneAddDataToList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: new BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/location_background.jpg"),
                  //fit: BoxFit.fitHeight,
                  repeat: ImageRepeat.repeatY,
                  alignment: Alignment.topCenter),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 30, right: 15, left: 15),
                    alignment: Alignment.topCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      //Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: Image(
                                        image: AssetImage(
                                          "images/arrow_back.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (isFavorite == true) {
                                        deleteFavorite(context, objectData!.id)
                                            .then((value) {
                                          if (value)
                                            setState(() {
                                              isFavorite = false;
                                            });
                                        });
                                      } else {
                                        addFavorite(context, objectData!.id)
                                            .then((value) {
                                          if (value)
                                            setState(() {
                                              isFavorite = true;
                                            });
                                        });
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: Image(
                                        image: isFavorite
                                            ? AssetImage("images/heart.png")
                                            : AssetImage("images/heart.png"),
                                        //24
                                        color: isFavorite
                                            ? Colors.yellow
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                        ]),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      objectData == null ? "" : objectData!.address,
                      style: bigWhite,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: kColorGrey1,
                            border: Border.all(color: kColorGrey1, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PopupMenuButton(
                                child: Row(
                                  children: [
                                    Text(getCurrentDate(),
                                        style: kBottomSheetTextStyle),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 24,
                                    ),
                                  ],
                                ),
                                offset: Offset(0, 46),
                                onSelected: (value) {
                                  setState(() {});
                                },
                                enableFeedback: true,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Container(
                                      width: 124.0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listWorkingHours.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                            '${getDayString(listWorkingHours[index].day)}: ${getStartEnd(listWorkingHours[index].start, listWorkingHours[index].end)}',
                                            softWrap: false,
                                            style: kBottomSheetTextStyle,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: kColorGrey1, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              _makePhoneCall(listOfContactPhone[0].value);
                            },
                            child: Image(
                                height: 30,
                                image: AssetImage("images/phone.png")),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //border: Border.all(color: kColorGrey1, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              _openSite(objectData!.website);
                            },
                            child: Image(
                                height: 30,
                                image: AssetImage("images/globe.png")),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.materials!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: kColorGrey1,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: kColorGrey1,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Image(
                                            image: AssetImage("images/" +
                                                imageName(widget
                                                    .materials![index].id) +
                                                "2.png"),
                                            height: 60,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          widget.materials![index].price
                                                  .toString() +
                                              " " +
                                              "rub_per_100_kilo".tr(),
                                          style: kTextStyle12,
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          widget.materials![index].name,
                                          style: kTextStyle12,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () => {_openMap("phoneNumber")},
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: kColorGreen1,
                                ),
                                child: Text(
                                  "route".tr(),
                                  textAlign: TextAlign.center,
                                  style: kTextStyle3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ]),
                  ),
                ]),
          ),

          //)
        ));
  }

  List<int> selectedMaterials = [];

  //удаление фильтра
  void removeFilter(int id) {
    selectedMaterials.remove(id);
  }

  String getCurrentDate() {
    if (listWorkingHours.length == 0) return "";
    int weekDay = DateTime.now().weekday - 1;
    int index =
        listWorkingHours.indexWhere((element) => element.day == weekDay);
    if (index == -1) {
      return getDayString(listWorkingHours[0].day) +
          ': ' +
          getStartEnd(listWorkingHours[0].start, listWorkingHours[0].end);
    }
    return getDayString(listWorkingHours[index].day) +
        ': ' +
        getStartEnd(listWorkingHours[index].start, listWorkingHours[index].end);
  }

  String selectedDayOfTheWeek = '';

  String getDayString(int dayNumber) {
    if (dayNumber == 0) {
      selectedDayOfTheWeek = 'pn'.tr();
    } else if (dayNumber == 1) {
      selectedDayOfTheWeek = 'vt'.tr();
    } else if (dayNumber == 2) {
      selectedDayOfTheWeek = 'sr'.tr();
    } else if (dayNumber == 3) {
      selectedDayOfTheWeek = 'cht'.tr();
    } else if (dayNumber == 4) {
      selectedDayOfTheWeek = 'pt'.tr();
    } else if (dayNumber == 5) {
      selectedDayOfTheWeek = 'sb'.tr();
    } else if (dayNumber == 6) {
      selectedDayOfTheWeek = 'vs'.tr();
    }
    return selectedDayOfTheWeek;
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

  //лист для времени работы конкретного обьекта
  List<ListObjectWorkingHours> listWorkingHours = [];

  //записывает в лист время работы конкретного обьекта
  Future<void> getListObjectWorkingHoursAddToList() async {
    var dataTime = await getListObjectWorkingHours(widget.selectedIndexMarker);
    if (dataTime != null) {
      setState(() {
        listWorkingHours = dataTime.cast<ListObjectWorkingHours>();
        getCurrentDate();
      });
    }
  }

//переменная для данных конкретного обьекта (адресс, вебсайт)
  ListObjectData? objectData;

  Future<void> getObjectDataAddDataToList() async {
    var dataObjects = await getObjectData(widget.selectedIndexMarker);
    if (dataObjects != null) {
      setState(() {
        objectData = dataObjects;
        isFavorite =  dataObjects.faved ;
      });
    }
  }

  //лист для контактов конкретного обьекта
  List<ListOfContactPhone> listOfContactPhone = [];

  //записыввает в лист контакты конкретного обьекта
  Future<void> getContactPhoneAddDataToList() async {
    var dataContact = await getListOfContactPhone(widget.selectedIndexMarker);
    if (dataContact != null) {
      setState(() {
        listOfContactPhone = dataContact;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _openSite(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _openMap(String phoneNumber) async {
    MapsLauncher.launchCoordinates(objectData!.latitude, objectData!.longitude);
  }
}
