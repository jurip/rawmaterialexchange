import 'dart:async';

import 'package:app/api/models/response_list_of_object.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/api/models/response_list_of_services.dart';
import 'package:app/api/models/response_objects_from_filter.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/bottom_sheet_setting_components/settings_widget.dart';
import 'package:app/components/custom_app_bar.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/favourites_bottom_sheet.dart';
import 'package:app/components/location_info_widget.dart';
import 'package:app/components/material_card_widget.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../api/models/material_list_item.dart';
import '../api/models/response_list_object_working_hours.dart';
import '../components/garbage_widget.dart';
import '../components/other_material_card_widget.dart';
import '../constants/image_constants.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  MapController _mapController = MapController();
  late AnimationController animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
  late Animation rotationAnimation =
      Tween(begin: 4.0, end: 7).animate(animationController);
  ProgressBar _sendingMsgProgressBar = ProgressBar();
  int selectedIndexMarker = -1;
  LatLng _position = LatLng(55.76350864466721, 37.61888069876945);
  String error = '';
  bool load = false;
  int selectedMaterials = -1;
  bool userInfoClicked = false;
  bool firstTime = true;
  bool locationOpened = false;
  double animatedWidth = 4;
  PanelController _pc = new PanelController();

  LatLng latLngfromPosition(currentLocation) {
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  Future<bool> getPermission() async {
    var enabled = await Geolocator.checkPermission();
    if (enabled == LocationPermission.denied) {
      enabled = await Geolocator.requestPermission();
    }
    return enabled != LocationPermission.denied &&
        enabled != LocationPermission.deniedForever;
  }

  getLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 25));

      setState(() {
        _position = latLngfromPosition(newPosition);
        _mapController.move(_position, 15);
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void initPositioning() async {
    var p = await SharedPreferences.getInstance();
    _position = await getPositionFromStored();
    if (await getPermission()) {
      Geolocator.getServiceStatusStream().listen((event) {
        print("set in service status: " + event.toString());
        getLocation();
      });
      getLocation();
      Geolocator.getPositionStream().listen((event) {
        if (firstTime) {
          setState(() => {
                print("${event.latitude} ${event.longitude}"),
                _position = latLngfromPosition(event),
                _mapController.move(_position, 15)
              });
          firstTime = false;
          p.setDouble("lat", _position.latitude);
          p.setDouble("lng", _position.longitude);
        } else {
          setState(() => {
                _position = latLngfromPosition(event),
              });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPositioning();
    getListOfObjectAddDataToList();
    WidgetsBinding.instance.addObserver(this);
    initAnimation();
  }

  Future<LatLng> getPositionFromStored() async {
    LatLng position;
    var prefs = await SharedPreferences.getInstance();
    var lat = prefs.getDouble("lat");
    var lng = prefs.getDouble("lng");
    if (lat != null && lng != null) {
      position = LatLng(lat, lng);
    } else {
      position = LatLng(55.76350864466721, 37.61888069876945);
    }
    return position;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController.dispose();
    super.dispose();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("AppLifecycleState: " + state.name.toString());
    }
  }

  Widget header(text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Align(
          child: Text(
            text,
            style: kAlertTextStyle,
          ),
          alignment: Alignment.topLeft),
    );
  }

  Widget horizontalScrollList(BuildContext context, list, onTap) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12),
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: 140,
      ),
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 5,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return MaterialCardWidget(
            colorShadow: list[index].selected == true
                ? Color(0xFF009900)
                : Colors.transparent,
            assetImage: imageDefinitionInFilter(list[index].id),
            color: colorDefinitionInFilter(list[index].id),
            onTap: () {
              onTap(index);
            },
            text: list[index].name,
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.count(4, 3),
      ),
    );
  }

  Widget otherHorizontalScrollList(BuildContext context, list, onTap) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 12),
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: 140,
      ),
      child: StaggeredGridView.countBuilder(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 5,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return OtherMaterialCardWidget(
            colorShadow: list[index].selected == true
                ? Color(0xFF009900)
                : Colors.transparent,
            assetImage: imageDefinitionInFilter(list[index].id),
            color: colorDefinitionInFilter(list[index].id),
            onTap: () {
              onTap(index);
            },
            text: list[index].name,
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.count(4, 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return listOfRawMaterials.isEmpty || listOfObject.isEmpty
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                color: Colors.white,
              ),
            ),
          )
        : WillPopScope(
            onWillPop: MyWillPop(context: context).onWillPop,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(
                showUserSettingsInfo: () async {
                  cbs
                      .showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    barrierColor: Colors.white.withOpacity(0),
                    context: context,
                    builder: (BuildContext context) {
                      return SettingsWidget();
                    },
                  )
                      .whenComplete(() {
                    getListOfRawMaterialsAddDataToList();
                    if (userInfoClicked)
                      getListOfRawMaterialsOfSpecificObjectAddDataToList(
                          selectedIndexMarker, false);
                  });
                },
                returnListOfSelectedMarkerBottomSheet: () {},
                removeRoute: () {
                  latLngDriving.clear();
                  latLngWalking.clear();
                  _pc.close();
                  setState(() {});
                },
                returnMarkers: () {
                  setState(() {
                    getListOfObjectAddDataToList();
                  });
                },
                updatingLanguageInTheFilter: () {},
              ),
              key: scaffoldKey,
              body: SlidingUpPanel(
                minHeight: 140,
                maxHeight: 590,
                controller: _pc,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
                panel: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kColorGrey1,
                        ),
                        height: 4.0,
                        width: 42.0,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 20.0),
                          header("services".tr()),
                          SizedBox(height: 10.0),
                          horizontalScrollList(
                              context, listOfServices, onServiceTap),
                          header("filters".tr()),
                          SizedBox(height: 10.0),
                          horizontalScrollList(
                              context, listOfFilters, onFilterTap),
                          header("other".tr()),
                          SizedBox(height: 10.0),
                          otherHorizontalScrollList(
                              context, listOfOthers, onFavouritesTap),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _position,
                        minZoom: 3.0,
                        maxZoom: 18.4,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/logiman/ckweydbul0r7015mv54fy9u17/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA',
                            additionalOptions: {
                              'accessToken':
                                  'pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA',
                              'id': 'mapbox.mapbox-streets-v8'
                            }),
                        PolylineLayerOptions(
                          polylines: [
                            Polyline(
                              points: getSelectedToggleSwitch(),
                              strokeWidth: 4.0,
                              color: Colors.green,
                              isDotted: true,
                            ),
                          ],
                        ),
                        MarkerLayerOptions(
                          rotate: true,
                          markers: getMarkersAndUserLocation(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.8,
                        left: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: Container(
                        height: 48.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            _mapController.move(_position, 15);
                          },
                          icon: Icon(
                            Icons.location_on,
                            color: kColorGrey2,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  //запись в лист всех маркеров точек и отдельно маркер местоположения
  List<Marker> getMarkersAndUserLocation() {
    List<Marker> newList = [];
    newList.addAll(markers);

    newList.add(
      Marker(
        width: 30.0,
        height: 30.0,
        point: _position,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: animatedWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );

    return newList;
  }

  //получение всех маркеров
  List<ListOfObjects> listOfObject = [];

  Future<void> getListOfObjectAddDataToList() async {
    var dataObjects = await getListOfObjects(context);
    if (dataObjects != null) {
      listOfObject = dataObjects;
      getListOfRawMaterialsAddDataToList();
      getListOfFilters();
      addMarkers();
      load = true;
    } else {
      setState(() {
        error = 'Error';
      });
    }
  }

  //получение списка сырья
  List<MaterialListItem> listOfRawMaterials = [];

  Future<void> getListOfRawMaterialsAddDataToList() async {
    var dataListOfRawMaterials = await getListOfRawMaterials();
    if (dataListOfRawMaterials != null) {
      setState(() {
        listOfRawMaterials = dataListOfRawMaterials;
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
  }

  List<MaterialListItem> listOfFilters = [];

  Future<void> getListOfFilters() async {
    var dataListOfRawMaterials = await getListOfRawMaterials();
    if (dataListOfRawMaterials != null) {
      setState(() {
        listOfFilters = dataListOfRawMaterials;
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
  }

  List<Service> listOfServices = [
    Service(id: 9, name: "garbage_collection".tr()),
  ];
  List<Service> listOfOthers = [
    Service(id: 10, name: "other".tr()),
  ];

  //запись маркеров в лист для их отображения
  List<Marker> markers = [];

  void addMarkers() {
    if (listOfObject.isEmpty) return;
    markers.clear();
    if (selectedMaterialsId.isEmpty) {
      for (var item in listOfObject) {
        markers.add(
          Marker(
            height: selectedIndexMarker == item.id ? 90.0 : 30.0,
            width: selectedIndexMarker == item.id ? 60.0 : 30.0,
            point: LatLng(item.latitude, item.longitude),
            builder: (context) => InkWell(
              onTap: () {
                setState(() {
                  selectedIndexMarker = item.id;
                  addMarkers();
                });
                getListOfRawMaterialsOfSpecificObjectAddDataToList(
                    selectedIndexMarker, true);
              },
              child: selectedIndexMarker != item.id
                  ? Container(
                      decoration: BoxDecoration(
                        color: kColorGreen1,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white, width: 4.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image(image: AssetImage('images/Pin.png')),
                      ),
                    ),
            ),
          ),
        );
      }
      setState(() {
        _sendingMsgProgressBar.hide();
      });
    } else {
      for (var item in listOfObjectFromFilter) {
        markers.add(
          Marker(
            height: selectedIndexMarker == item.id ? 90.0 : 30.0,
            width: selectedIndexMarker == item.id ? 60.0 : 30.0,
            point: LatLng(item.latitude, item.longitude),
            builder: (context) => InkWell(
              onTap: () {
                setState(() {
                  selectedIndexMarker = item.id;
                  addMarkers();
                });
                getListOfRawMaterialsOfSpecificObjectAddDataToList(
                    selectedIndexMarker, true);
              },
              child: selectedIndexMarker != item.id
                  ? Container(
                      decoration: BoxDecoration(
                        color: kColorGreen1,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white, width: 4.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image(image: AssetImage('images/Pin.png')),
                      ),
                    ),
            ),
          ),
        );
      }
      setState(() {
        _sendingMsgProgressBar.hide();
      });
    }
  }

  List<ListOfRawMaterialsOfSpecificObject> listOfRawMaterialsOfSpecificObject =
      [];

  //лист для точек маршрута на машине
  List<LatLng> latLngDriving = [];

  double distanceDriving = 0;
  double durationsDriving = 0;

  //лист для точек маршрута пешком
  List<LatLng> latLngWalking = [];

  double distanceWalking = 0;
  double durationsWalking = 0;

  List<ListOfRawMaterialsOfSpecificObject>?
      dataListOfRawMaterialsOfSpecificObject;

  Future<void> getListOfRawMaterialsOfSpecificObjectAddDataToList(
      int selectedIndexMarker, bool update) async {
    if (update)
      dataListOfRawMaterialsOfSpecificObject =
          await getListOfRawMaterialsOfSpecificObject(
              selectedIndexMarker, context);
    if (dataListOfRawMaterialsOfSpecificObject != null) {
      setState(() {
        listOfRawMaterialsOfSpecificObject =
            dataListOfRawMaterialsOfSpecificObject!;
        locationOpened = true;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LocationInfoWidget(
            materials: listOfRawMaterialsOfSpecificObject,
            selectedIndexMarker: selectedIndexMarker,
          );
        }));
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
  }

  double latSelectedObject = 0;
  double lngSelectedObject = 0;

  List<int> selectedMaterialsId = [];

  void getSelectedMaterialsIdAddToList(int id) {
    selectedMaterialsId.add(id);
    getListOfObjectFromFilterAddDataToList();
  }

  List<ListOfObjectsFromFilter> listOfObjectFromFilter = [];

  //получение маркеров из  фильтра
  Future<void> getListOfObjectFromFilterAddDataToList() async {
    setState(() {
      _sendingMsgProgressBar.show(context);
    });
    var dataObjects =
        await getListOfObjectsInFilter(selectedMaterialsId, context);
    if (dataObjects != null) {
      listOfObjectFromFilter = dataObjects;
    } else {
      setState(() {
        _sendingMsgProgressBar.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('no_dots'.tr()),
        ));
      });
    }
    addMarkers();
  }

  void removeFilter(int id) {
    selectedMaterialsId.remove(id);
    getListOfObjectFromFilterAddDataToList();
    if (selectedMaterialsId.isEmpty) {
      addMarkers();
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String address = '';

  bool selectedToggleSwitch = false;

  List<LatLng> selectedListLatLng = [];

  List<LatLng> getSelectedToggleSwitch() {
    if (updatedSelectedToggleSwitch == false) {
      setState(() {
        selectedListLatLng = latLngWalking;
      });
    } else {
      setState(() {
        selectedListLatLng = latLngDriving;
      });
    }
    return selectedListLatLng;
  }

  bool updatedSelectedToggleSwitch = false;

  String assetImage = '';

  Color colorFilterElement = kColorGrey4;

  onServiceTap(index) {
    scaffoldKey.currentState!.showBottomSheet(
      (context) =>
          GarbageWidget(materials: listOfRawMaterials, position: _position),
      backgroundColor: Colors.transparent,
    );
  }

  onFilterTap(index) {
    setState(() {
      listOfFilters[index].selected = !listOfFilters[index].selected;
      if (listOfFilters[index].selected == false) {
        removeFilter(listOfFilters[index].id);
      } else {
        getSelectedMaterialsIdAddToList(listOfFilters[index].id);
      }
    });
  }

  onFavouritesTap(index) {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => FavouritesBottomSheet(),
      backgroundColor: Colors.transparent,
    );
  }

  List<ListObjectWorkingHours> listWorkingHours = [];
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

  void initAnimation() {
    rotationAnimation.addListener(() {
      setState(() {
        animatedWidth = rotationAnimation.value;
      });
    });
    animationController.repeat();
  }

  onError() {
    print("error");
  }
}
