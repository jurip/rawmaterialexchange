import 'package:app/api/models/response_list_object_data.dart';
import 'package:app/constants/image_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/requests/requests.dart';
import '../constants/color_constants.dart';
import '../constants/style_constants.dart';
import '../main.dart';
import '../utils/data_utils.dart';

class LocationInfoWidget extends StatefulWidget {
  final int id;

  LocationInfoWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _LocationInfoWidgetState createState() => _LocationInfoWidgetState();
}

class _LocationInfoWidgetState extends State<LocationInfoWidget> {
  LocationInfo locationInfo = LocationInfo(
      0,
      [],
      [],
      ListObjectData(
          address: "",
          faved: false,
          id: 0,
          latitude: 0,
          longitude: 0,
          website: "",
          pickUp: false),
      []);

  @override
  void initState() {
    getIt<MyRequests>()
        .getLocationInfo(widget.id, context)
        .then((value) => setState(
              () => locationInfo = value,
            ));

    super.initState();
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
                                      if (locationInfo.listObjectData.faved ==
                                          true) {
                                        getIt<MyRequests>()
                                            .deleteFavorite(context,
                                                locationInfo.listObjectData.id)
                                            .then((value) {
                                          if (value)
                                            setState(() {
                                              locationInfo
                                                  .listObjectData.faved = false;
                                            });
                                        });
                                      } else {
                                        getIt<MyRequests>()
                                            .addFavorite(context,
                                                locationInfo.listObjectData.id)
                                            .then((value) {
                                          if (value)
                                            setState(() {
                                              locationInfo
                                                  .listObjectData.faved = true;
                                            });
                                        });
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: Image(
                                        image: AssetImage("images/heart.png"),
                                        //24
                                        color: locationInfo.listObjectData.faved
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
                      locationInfo.listObjectData.address,
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
                                        itemCount:
                                            locationInfo.workingHours.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                            '${getDayString(locationInfo.workingHours[index].day)}: ${getStartEnd(locationInfo.workingHours[index].start, locationInfo.workingHours[index].end)}',
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
                              _makePhoneCall(locationInfo.phones[0].value);
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
                              _openSite(locationInfo.listObjectData.website);
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
                              itemCount: locationInfo.materials.length,
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
                                                imageName(locationInfo
                                                    .materials[index].id) +
                                                "2.png"),
                                            height: 60,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          locationInfo.materials[index].price
                                                  .toString() +
                                              " " +
                                              "rub_per_100_kilo".tr(),
                                          style: kTextStyle12,
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          locationInfo.materials[index].name,
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

  String getCurrentDate() {
    if (locationInfo.workingHours.length == 0) return "";
    int weekDay = DateTime.now().weekday - 1;
    int index = locationInfo.workingHours
        .indexWhere((element) => element.day == weekDay);
    if (index == -1) {
      return getDayString(locationInfo.workingHours[0].day) +
          ': ' +
          getStartEnd(locationInfo.workingHours[0].start,
              locationInfo.workingHours[0].end);
    }
    return getDayString(locationInfo.workingHours[index].day) +
        ': ' +
        getStartEnd(locationInfo.workingHours[index].start,
            locationInfo.workingHours[index].end);
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
    MapsLauncher.launchCoordinates(locationInfo.listObjectData.latitude,
        locationInfo.listObjectData.longitude);
  }
}
