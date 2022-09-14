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
import 'package:app/components/location_widget.dart';
import 'package:app/components/material_card_widget.dart';
import 'package:app/components/route_widget.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../api/models/material_list_item.dart';
import '../api/models/response_list_object_working_hours.dart';
import '../components/garbage_widget.dart';
import '../constants/image_constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();

  ProgressBar? _sendingMsgProgressBar;

  int selectedIndexMarker = -1;

  Location location = new Location();

  LatLng? _position;

  String error = '';

  bool load = false;

  int selectedMaterials = -1;

  bool userInfoClicked = false;

  Timer? timer;

  var locationOpened = false;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    getLocation();
    getListOfObjectAddDataToList();
  }

  void getLocation() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _position =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  PanelController _pc = new PanelController();
  PersistentBottomSheetController? controllerBottomSheetRout;

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

  @override
  Widget build(BuildContext context) {
    return listOfRawMaterials.isEmpty ||
            listOfObject.isEmpty ||
            _position == null
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
                  _closeRoutBottomSheet();
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
                margin: EdgeInsets.only(top: 110.0),
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
                      SizedBox(height: 20.0),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 30),
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              //Services
                              header("services".tr()),
                              SizedBox(height: 10.0),
                              horizontalScrollList(
                                  context, listOfServices, onServiceTap),
                              header("filters".tr()),
                              SizedBox(height: 10.0),
                              horizontalScrollList(
                                  context, listOfRawMaterials, onFilterTap),
                              header("other".tr()),
                              SizedBox(height: 10.0),
                              horizontalScrollList(
                                  context, listOfServices, onFavouritesTap),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        boundsOptions:
                            FitBoundsOptions(padding: EdgeInsets.all(800.0)),
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
                            if (_position != null) {
                              _mapController.move(_position!, 18);
                            }
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

    if (_position != null) {
      newList.add(
        Marker(
          width: 30.0,
          height: 30.0,
          point: _position!,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
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
          ),
        ),
      );
    }

    return newList;
  }

  //получение всех маркеров
  List<ListOfObjects> listOfObject = [];

  Future<void> getListOfObjectAddDataToList() async {
    var dataObjects = await getListOfObjects(context);
    if (dataObjects != null) {
      listOfObject = dataObjects;
      getListOfRawMaterialsAddDataToList();
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

  List<Service> listOfServices = [
    Service(id: 9, name: "favourites".tr()),
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
                        //kPurpleTransparent,
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
        _sendingMsgProgressBar?.hide();
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
                        //kPurpleTransparent,
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
        _sendingMsgProgressBar?.hide();
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

  void _closeRoutBottomSheet() {
    if (controllerBottomSheetRout != null) {
      userInfoClicked = true;
      controllerBottomSheetRout?.close();
      controllerBottomSheetRout = null;
    }
  }

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
              position: _position);
        }));

        cbs
            .showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                barrierColor: Colors.white.withOpacity(0),
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LocationWidget(
                        listOfRawMaterialsOfSpecificObject:
                            listOfRawMaterialsOfSpecificObject,
                        selectedIndexMarker: selectedIndexMarker,
                        position: _position,
                        onAddressChange: (val) {
                          setState(() {
                            address = val;
                          });
                        },
                        onDistanceDrivingChange: (val) {
                          setState(() {
                            distanceDriving = val;
                          });
                        },
                        onDurationDrivingChange: (val) {
                          setState(() {
                            durationsDriving = val;
                          });
                        },
                        onDistanceWalkingChange: (val) {
                          setState(() {
                            distanceWalking = val;
                          });
                        },
                        onDurationWalkingChange: (val) {
                          setState(() {
                            durationsWalking = val;
                          });
                        },
                        onRouteWalkingChange: (val) {
                          setState(() {
                            latLngWalking = val;
                            converterDistanceDriving();
                          });
                          Navigator.pop(context);
                          controllerBottomSheetRout = scaffoldKey.currentState!
                              .showBottomSheet<Null>((BuildContext context) {
                            return RouteWidget(
                              address: address,
                              durationsWalkingToString:
                                  durationsWalkingToString,
                              durationsDrivingToString:
                                  durationsDrivingToString,
                              selectedToggleSwitch: selectedToggleSwitch,
                              onSelectedToggleSwitchChange: (bool) {
                                updatedSelectedToggleSwitch = bool;
                                getSelectedToggleSwitch();
                              },
                              distanceDrivingToString: distanceDrivingToString,
                              distanceWalkingToString: distanceWalkingToString,
                              removeRoute: () {
                                latLngDriving.clear();
                                latLngWalking.clear();
                                setState(() {});
                              },
                              returnMarkers: () {
                                setState(() {
                                  getListOfObjectAddDataToList();
                                });
                              },
                            );
                          });
                          controllerBottomSheetRout!.closed.then((value) {
                            setState(() {
                              latLngDriving.clear();
                              latLngWalking.clear();
                              getListOfObjectAddDataToList();
                              if (!userInfoClicked)
                                getListOfRawMaterialsOfSpecificObjectAddDataToList(
                                    selectedIndexMarker, false);
                            });
                          });
                        },
                        onRouteDrivingChange: (val) {
                          setState(() {
                            latLngDriving = val;
                          });
                        },
                        removeMarkers: () {
                          setState(() {
                            markers.clear();
                          });
                        },
                        latLngSelectedObject:
                            (latSelectedObject, lngSelectedObject) {
                          setState(() {
                            latSelectedObject = latSelectedObject;
                            lngSelectedObject = lngSelectedObject;
                            markers.add(
                              Marker(
                                height: 30.0,
                                width: 30.0,
                                point: LatLng(
                                    latSelectedObject, lngSelectedObject),
                                builder: (context) => InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kColorGreen1,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          color: Colors.white, width: 4.0),
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
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  );
                })
            .whenComplete(() {
          userInfoClicked = false;
        });
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
      _sendingMsgProgressBar?.show(context);
    });
    var dataObjects =
        await getListOfObjectsInFilter(selectedMaterialsId, context);
    if (dataObjects != null) {
      listOfObjectFromFilter = dataObjects;
    } else {
      setState(() {
        _sendingMsgProgressBar?.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('no_dots'.tr()),
        ));
      });
    }
    addMarkers();

    var bounds = new LatLngBounds();
    for (var item in listOfObjectFromFilter) {
      bounds.extend(LatLng(item.latitude, item.longitude));
    }
    _mapController.fitBounds(
      bounds,
      options: FitBoundsOptions(
        maxZoom: 9.6,
        inside: false,
      ),
    );
  }

  //удаление фильтра
  void removeFilter(int id) {
    selectedMaterialsId.remove(id);
    getListOfObjectFromFilterAddDataToList();
    if (selectedMaterialsId.isEmpty) {
      addMarkers();
    }
  }

  String distanceDrivingToString = '';

  void converterDistanceDriving() {
    if (distanceDriving.toInt().toString().length > 3) {
      if ((distanceDriving / 1000) % 10 == 1) {
        distanceDrivingToString =
            '${(distanceDriving / 1000).round()} ' + 'kilometer'.tr();
      } else if ((distanceDriving / 1000) % 10 > 1 &&
          (distanceDriving / 1000) % 10 < 5) {
        distanceDrivingToString =
            '${(distanceDriving / 1000).round()} ' + 'kilometers'.tr();
      } else {
        distanceDrivingToString =
            '${(distanceDriving / 1000).round()} ' + 'kilometrov'.tr();
      }
    } else {
      if (distanceDriving % 10 == 1) {
        distanceDrivingToString = '${distanceDriving.toInt()} ' + 'metre'.tr();
      } else if (distanceDriving % 10 > 1 && distanceDriving % 10 < 5) {
        distanceDrivingToString = '${distanceDriving.toInt()} ' + 'meters'.tr();
      } else {
        distanceDrivingToString = '${distanceDriving.toInt()} ' + 'metrov'.tr();
      }
    }
    converterDistanceWalking();
  }

  String distanceWalkingToString = '';

  void converterDistanceWalking() {
    if (distanceWalking.toInt().toString().length > 3) {
      if ((distanceDriving / 1000) % 10 == 1) {
        distanceWalkingToString =
            '${(distanceWalking / 1000).round()} ' + 'kilometer'.tr();
      } else if ((distanceWalking / 1000) % 10 > 1 &&
          (distanceWalking / 1000) % 10 < 5) {
        distanceWalkingToString =
            '${(distanceWalking / 1000).round()} ' + 'kilometers'.tr();
      } else {
        distanceWalkingToString =
            '${(distanceWalking / 1000).round()} ' + 'kilometrov'.tr();
      }
    } else {
      if (distanceWalking % 10 == 1) {
        distanceWalkingToString = '${distanceWalking.toInt()} ' + 'metre'.tr();
      } else if (distanceWalking % 10 > 1 && distanceWalking % 10 < 5) {
        distanceWalkingToString = '${distanceWalking.toInt()} ' + 'meters'.tr();
      } else {
        distanceWalkingToString = '${distanceWalking.toInt()} ' + 'metrov'.tr();
      }
    }
    convertDurationsDriving();
  }

  String durationsDrivingToString = '';

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  void convertDurationsDriving() {
    Duration time = Duration(seconds: durationsDriving.toInt());
    final hours = twoDigits(time.inHours.remainder(60));
    final minutes = twoDigits(time.inMinutes.remainder(60));

    String stringHour = '';
    if (int.parse(hours) == 11) {
      stringHour = 'hours'.tr();

      String stringMinute = '';

      if (int.parse(minutes) == 11) {
        stringMinute = 'minutes'.tr();
      } else {
        switch (int.parse(minutes) % 10) {
          case 1:
            stringMinute = 'minute'.tr();
            break;
          case 2:
          case 3:
          case 4:
            stringMinute = 'minuti'.tr();
            break;
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 0:
            stringMinute = 'minutes'.tr();
            break;
        }
      }

      String strHour = hours == '00' ? '' : hours;
      String strMinutes = minutes == '00' ? '' : minutes;

      durationsDrivingToString = '$hours $strHour $strMinutes $stringMinute';
    } else if (int.parse(hours) == 0) {
      String stringMinute = '';
      if (int.parse(minutes) == 11) {
        stringMinute = 'minutes'.tr();
      } else {
        switch (int.parse(minutes) % 10) {
          case 1:
            stringMinute = 'minute'.tr();
            break;
          case 2:
          case 3:
          case 4:
            stringMinute = 'minuti'.tr();
            break;
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 0:
            stringMinute = 'minutes'.tr();
            break;
        }
      }
      durationsDrivingToString = '$minutes $stringMinute';
    } else {
      switch (int.parse(hours) % 10) {
        case 1:
          stringHour = 'hour'.tr();
          break;
        case 2:
        case 3:
        case 4:
          stringHour = 'hour_s'.tr();
          break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 0:
          stringHour = 'hours'.tr();
          break;
      }
    }
    String stringMinute = '';
    if (int.parse(minutes) == 11) {
      stringMinute = 'hours'.tr();
    } else {
      switch (int.parse(minutes) % 10) {
        case 1:
          stringMinute = 'minute'.tr();
          break;
        case 2:
        case 3:
        case 4:
          stringMinute = 'minuti'.tr();
          break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 0:
          stringMinute = 'minutes'.tr();
          break;
      }
    }

    String strHour = hours == '00' ? '' : hours;
    String strMinutes = minutes == '00' ? '' : minutes;

    durationsDrivingToString = '$strHour $stringHour $strMinutes $stringMinute';
    convertDurationsWalking();
  }

  String durationsWalkingToString = '';

  void convertDurationsWalking() {
    Duration time = Duration(seconds: durationsWalking.toInt());
    final hours = twoDigits(time.inHours.remainder(60));
    final minutes = twoDigits(time.inMinutes.remainder(60));

    String stringHour = '';
    if (int.parse(hours) == 11) {
      stringHour = 'hours'.tr();

      String stringMinute = '';

      if (int.parse(minutes) == 11) {
        stringMinute = 'minutes'.tr();
      } else {
        switch (int.parse(minutes) % 10) {
          case 1:
            stringMinute = 'minute'.tr();
            break;
          case 2:
          case 3:
          case 4:
            stringMinute = 'minuti'.tr();
            break;
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 0:
            stringMinute = 'minutes'.tr();
            break;
        }
      }
      durationsWalkingToString = '$hours $stringHour $minutes $stringMinute';
    } else if (int.parse(hours) == 0) {
      String stringMinute = '';
      if (int.parse(minutes) == 11) {
        stringMinute = 'minutes'.tr();
      } else {
        switch (int.parse(minutes) % 10) {
          case 1:
            stringMinute = 'minute'.tr();
            break;
          case 2:
          case 3:
          case 4:
            stringMinute = 'minuti'.tr();
            break;
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 0:
            stringMinute = 'minutes'.tr();
            break;
        }
      }
      durationsWalkingToString = '$minutes $stringMinute';
    } else {
      switch (int.parse(hours) % 10) {
        case 1:
          stringHour = 'hour'.tr();
          break;
        case 2:
        case 3:
        case 4:
          stringHour = 'hour_s'.tr();
          break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 0:
          stringHour = 'hours'.tr();
          break;
      }
    }
    String stringMinute = '';
    if (int.parse(minutes) == 11) {
      stringMinute = 'hours'.tr();
    } else {
      switch (int.parse(minutes) % 10) {
        case 1:
          stringMinute = 'minute'.tr();
          break;
        case 2:
        case 3:
        case 4:
          stringMinute = 'minuti'.tr();
          break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 0:
          stringMinute = 'minutes'.tr();
          break;
      }
    }
    durationsWalkingToString = '$hours $stringHour $minutes $stringMinute';
  }

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
      listOfRawMaterials[index].selected = !listOfRawMaterials[index].selected;
      if (listOfRawMaterials[index].selected == false) {
        removeFilter(listOfRawMaterials[index].id);
      } else {
        getSelectedMaterialsIdAddToList(listOfRawMaterials[index].id);
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
}
