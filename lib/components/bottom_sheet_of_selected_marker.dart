import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:app/api/models/response_list_object_working_hours.dart';
import 'package:app/api/models/response_list_of_contact_phone.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/confirmation_button.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/list_favourites_object.global.dart';
import 'package:app/utils/progress_bar.dart';
import 'block_with_material.dart';
import 'package:app/api/models/response_list_of_coordinates_driving.dart' as Driving;
import 'package:app/api/models/response_list_of_coordinates_walking.dart' as Walking;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetOfSelectedMarker extends StatefulWidget {
  BottomSheetOfSelectedMarker({
    required this.listOfRawMaterialsOfSpecificObject,
    required this.selectedIndexMarker,
    required this.position,
    required this.onRouteDrivingChange,
    required this.onDistanceDrivingChange,
    required this.onDurationDrivingChange,
    required this.onRouteWalkingChange,
    required this.onDistanceWalkingChange,
    required this.onDurationWalkingChange,
    required this.onAddressChange,
    required this.removeMarkers,
    required this.latLngSelectedObject,
  });

  final List<ListOfRawMaterialsOfSpecificObject>
      listOfRawMaterialsOfSpecificObject;
  final int selectedIndexMarker;

  final LatLng? position;

  final Function(List<LatLng> list) onRouteDrivingChange;
  final Function(double) onDurationDrivingChange;
  final Function(double) onDistanceDrivingChange;

  final Function(List<LatLng> list) onRouteWalkingChange;
  final Function(double) onDurationWalkingChange;
  final Function(double) onDistanceWalkingChange;

  final Function(String) onAddressChange;

  final Function() removeMarkers;

  final Function(double, double) latLngSelectedObject;

  @override
  _BottomSheetOfSelectedMarkerState createState() => _BottomSheetOfSelectedMarkerState();
}

class _BottomSheetOfSelectedMarkerState extends State<BottomSheetOfSelectedMarker> {

  bool isFavorite = false;

  ProgressBar? _sendingMsgProgressBar;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    getObjectDataAddDataToList();
    getContactPhoneAddDataToList();
    getListObjectWorkingHoursAddToList();
  }

  String error = '';

  final double textHeight6 = 18.0;
  final double textHeight5 = 14.0;
  final double textHeight4 = 14.0;
  final double textHeight3 = 20.0;
  final double topPadding1 = 12.0;
  final double sizedBox1 = 14.0;
  final double containerHeight1 = 4.0;
  final double sizedBox2 = 14.0;
  final double sizedBox3 = 24.0;
  final double iconSize1 = 24.0;
  final double sizedBox4 = 10.0;
  final double iconSize2 = 28.0;
  final double sizedBox5 = 10.0;
  final double textHeight1 = 16.0;
  final double sizedBox6 = 10.0;
  final double bottomPadding1 = 10.0;
  final double textHeight2 = 16.0;
  final double blockWithMaterialHeight = 74.0;
  final double bottomPadding2 = 16.0;
  final double confirmationButtonHeight = 42.0;

  double bottomSheetHeight = 0;

  double maxHeight = 0;

  double determinationMaxHeight () {
    return maxHeight = MediaQuery.of(context).size.height -
        textHeight6 -
        textHeight5 -
        textHeight4 -
        textHeight3 -
        topPadding1 -
        sizedBox1 -
        containerHeight1 -
        sizedBox2 -
        sizedBox3 -
        iconSize1 -
        sizedBox4 -
        iconSize2 -
        sizedBox5 -
        textHeight1 -
        sizedBox6 -
        bottomPadding1 -
        textHeight2 -
        bottomPadding2 -
        confirmationButtonHeight;
  }

  @override
  Widget build(BuildContext context) {
    return objectData == null &&
            listOfContactPhone.isEmpty &&
            listWorkingHours.isEmpty &&
            maxHeight == 0
        ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                    color: Colors.transparent,
                  ),
                ),
        )
        :
            SafeArea(
              child: Container(
                    width:  double.infinity,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 2),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: topPadding1),
                      child: Column(
                        children: [
                          SizedBox(height: sizedBox1),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: kColorGrey1,
                            ),
                            height: containerHeight1,
                            width: 42.0,
                          ),
                          SizedBox(height: sizedBox2),
                          Stack(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: sizedBox3),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 16.0),
                                                  child: Text(objectData == null ? "" : objectData.address ?? "",
                                                    style: kAlertTextStyle,
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (isFavorite == true) {
                                                    deleteFavorite(context, objectData.id).then((value) {
                                                      if (value) setState(() {
                                                        isFavorite = false;
                                                      });
                                                    });
                                                  } else {
                                                    addFavorite(context, objectData.id).then((value) {
                                                      if (value) setState(() {
                                                        isFavorite = true;
                                                      });
                                                    });
                                                  }
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  isFavorite ? Icons.star : Icons.star_border, //24
                                                  color: Colors.yellow,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: sizedBox4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            PopupMenuButton(
                                              child: Row(
                                                children: [
                                                  Text(getCurrentDate(),
                                                      style: kBottomSheetTextStyle),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: iconSize2,
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
                                                        return Text('${getDayString(listWorkingHours[index].day)}: ${getStartEnd(listWorkingHours[index].start, listWorkingHours[index].end)}',
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
                                        SizedBox(height: sizedBox5),
                                        Container(
                                          child: objectData == null || objectData.website == '' ? null
                                              : Text(
                                            objectData.website,
                                            style: kTextStyle6,//16
                                          ),
                                        ),
                                        SizedBox(height: sizedBox6),
                                        listOfContactPhone.length != 0
                                            ? ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: listOfContactPhone.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom: bottomPadding1),
                                              child: InkWell(
                                                onTap: () {
                                                  _makePhoneCall(listOfContactPhone[index].value);
                                                },
                                                child: Text(
                                                  listOfContactPhone[index].value,
                                                  style: kTextStyle7,//16
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                            : SizedBox(),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                                      color: Colors.white,
                                      constraints: BoxConstraints(
                                        minHeight: blockWithMaterialHeight,
                                        maxWidth: double.infinity,
                                        maxHeight: determinationMaxHeight(),
                                      ),
                                      child: StaggeredGridView.countBuilder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(top: 0),
                                        crossAxisCount: 4,
                                        itemCount: widget.listOfRawMaterialsOfSpecificObject.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return BlockWithMaterial(
                                            assetImage: imageDefinitionInFilter(widget.listOfRawMaterialsOfSpecificObject[index].id),
                                            text: widget.listOfRawMaterialsOfSpecificObject[index].name,
                                            price: widget.listOfRawMaterialsOfSpecificObject[index].price.toString(),
                                          );
                                        },
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, 1),
                                        //listOfRawMaterialsOfSpecificObject.length % 2 == 0 || index == listOfRawMaterialsOfSpecificObject.length ? StaggeredTile.count(4, 1) : StaggeredTile.count(2, 1),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0, right: 16.0, bottom: bottomPadding2),
                                      child: ConfirmationButton(
                                        text: 'route'.tr(),
                                        onTap: () {
                                          widget.removeMarkers();
                                          widget.latLngSelectedObject(
                                              objectData.latitude,
                                              objectData.longitude);
                                          _sendingMsgProgressBar?.show(context);
                                          getCoordinatesDrivingAddToVar();
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 26.0, left: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    //Navigator.pop(context);
                                  },
                                  child:
                                  Icon(Icons.arrow_back_ios_outlined, size: 24.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            );
  }

  //переменная для данных конкретного обьекта (адресс, вебсайт)
  var objectData;
  //записывает в лист данные конкретного обьекта (адресс, вебсайт)
  Future<void> getObjectDataAddDataToList() async {
    var dataObjects = await getObjectData(widget.selectedIndexMarker);
    if (dataObjects != null) {
      setState(() {
        objectData = dataObjects;
        isFavorite = dataObjects.faved != null ? dataObjects.faved : false;
      });
    } else {
      setState(() {
        error = 'Error';
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
    } else {
      setState(() {
        error = 'Error';
      });
    }
  }

  //лист для времени работы конкретного обьекта
  List<ListObjectWorkingHours> listWorkingHours = [];
  //записывает в лист время работы конкретного обьекта
  Future<void> getListObjectWorkingHoursAddToList() async {
    var dataTime = await getListObjectWorkingHours(widget.selectedIndexMarker);
    if (dataTime != null) {
      setState(() {
        listWorkingHours = dataTime;
        getCurrentDate();
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
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

  String formatHours(String date) {
    DateTime parseDate = DateFormat('HH:mm:ss').parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  String getStartEnd(String start, String end) {
    String startFormatted = formatHours(start);
    String endFormatted = formatHours(end);
    return startFormatted + '-' + endFormatted;
  }

  String getCurrentDate() {
    if (listWorkingHours.length == 0) return "";
    int weekDay = DateTime.now().weekday - 1;
    int index = listWorkingHours.indexWhere((element) => element.day == weekDay);
    if (index == -1) {
      return getDayString(listWorkingHours[0].day) +
          ': ' +
          getStartEnd(listWorkingHours[0].start, listWorkingHours[0].end);
    }
    return getDayString(listWorkingHours[index].day) +
        ': ' +
        getStartEnd(listWorkingHours[index].start, listWorkingHours[index].end);
  }

  void favouritesAddToList(bool favourites, int id) {
    if (favourites == true) {
      favouritesObject.add(id);
    }
  }

//для выстраивания маршрута на машине
  Driving.Route? route;
  Future<void> getCoordinatesDrivingAddToVar() async {
    getCoordinatesDriving(context, widget.position!.longitude, widget.position!.latitude,
            objectData.longitude, objectData.latitude)
        .then((value) {
      if (value != null) {
        route = value;
        coordinatesDriverAddToList(route);
      }
    }).catchError((err) {
      print(err);
    });
  }

  List<LatLng> latLngDriving = [];
  void coordinatesDriverAddToList(Driving.Route? route) {
    if (route != null) {
      for (var route in route.routes) {
        for (var leg in route.legs) {
          for (var step in leg.steps) {
            for (var intersection in step.intersections) {
              latLngDriving.add(
                  LatLng(intersection.location[1], intersection.location[0]));
            }
          }
        }
      }
    }
    getCoordinatesWalkingAddToVar();
  }

//для выстраивания маршрута пешком
  Walking.RouteWalking? routeWalking;
  Future<void> getCoordinatesWalkingAddToVar() async {
    getCoordinatesWalking(context, widget.position!.longitude, widget.position!.latitude,
            objectData.longitude, objectData.latitude)
        .then((value) {
      if (value != null) routeWalking = value;
      coordinatesWalkingAddToList();
    });
  }

  List<LatLng> latLngWalking = [];
  void coordinatesWalkingAddToList() {
    if (routeWalking == null) {
      latLngWalking = [];

      widget.onDurationDrivingChange(route!.routes[0].duration);
      widget.onDistanceDrivingChange(route!.routes[0].distance);
      widget.onRouteDrivingChange(latLngDriving);

      widget.onDurationWalkingChange(0);
      widget.onDistanceWalkingChange(0);
      widget.onRouteWalkingChange(latLngWalking);

      widget.onAddressChange(objectData.address);
      _sendingMsgProgressBar?.hide();
    } else {
      for (var routeWalking in routeWalking!.routes) {
        for (var leg in routeWalking.legs) {
          for (var step in leg.steps) {
            for (var intersection in step.intersections) {
              latLngWalking.add(
                  LatLng(intersection.location[1], intersection.location[0]));
            }
          }
        }
      }
      widget.onDurationDrivingChange(route!.routes[0].duration);
      widget.onDistanceDrivingChange(route!.routes[0].distance);
      widget.onRouteDrivingChange(latLngDriving);

      widget.onDurationWalkingChange(routeWalking!.routes[0].duration);
      widget.onDistanceWalkingChange(routeWalking!.routes[0].distance);
      widget.onRouteWalkingChange(latLngWalking);

      widget.onAddressChange(objectData.address);
      _sendingMsgProgressBar?.hide();
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  String assetImage = '';
  String imageDefinitionInFilter(int id) {
    switch (id) {
      case 1:
        assetImage = 'images/paperboard1.png';
        break;
      case 2:
        assetImage = 'images/tape1.png';
        break;
      case 3:
        assetImage = 'images/plastic1.png';
        break;
      case 4:
        assetImage = 'images/glass1.png';
        break;
      case 5:
        assetImage = 'images/metall1.png';
        break;
      case 6:
        assetImage = 'images/alyuminiy.png';
        break;
      case 7:
        assetImage = 'images/lead.png';
        break;
      case 8:
        assetImage = 'images/copper.png';
        break;
      default:
        assetImage = 'images/Frame 54.png';
    }
    return assetImage;
  }
}
