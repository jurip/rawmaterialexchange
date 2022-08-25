import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:app/api/models/response_list_of_object.dart';
import 'package:app/api/models/response_list_of_row_materials.dart';
import 'package:app/api/models/response_objects_from_filter.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/block_with_all_materials.dart';
import 'package:app/components/bottom_sheet_of_selected_marker.dart';
import 'package:app/components/bottom_sheet_route.dart';
import 'package:app/components/bottom_sheet_setting_components/bottom_sheet_setting.dart';
import 'package:app/components/custom_app_bar.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/favourites_bottom_sheet.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;
import 'package:app/utils/progress_bar.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong2/latlong.dart';

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

  //Position? _position;

  String error = '';

  bool load = false;

  int selectedMaterials = -1;

  bool userInfoClicked = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
    getLocation();
    //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _determinePosition());
    getListOfObjectAddDataToList();
  }

  void getLocation() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _position = LatLng(currentLocation.latitude!, currentLocation.longitude!);
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

  @override
  Widget build(BuildContext context) {
    return listOfRawMaterials.isEmpty || listOfObject.isEmpty || _position == null
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
                cbs.showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  barrierColor: Colors.white.withOpacity(0),
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheetSetting();
                  },
                ).whenComplete(() {
                  getListOfRawMaterialsAddDataToList();
                  if (userInfoClicked) getListOfRawMaterialsOfSpecificObjectAddDataToList(selectedIndexMarker, false);
                });
              },
              returnListOfSelectedMarkerBottomSheet: () {
              },
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
              updatingLanguageInTheFilter: () {
            },
            ),
            key: scaffoldKey,
            body: SlidingUpPanel(
              margin: EdgeInsets.only(top: 110.0),
              controller: _pc,
              minHeight: 64 * 4,
              maxHeight: listOfRawMaterials.length * 64,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
              panel: Padding(
                padding: EdgeInsets.only(top: 12.0),
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
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 4.0,),
                            InkWell(
                              onTap: () {
                                scaffoldKey.currentState!.showBottomSheet((context) => FavouritesBottomSheet(),
                                  backgroundColor: Colors.transparent,
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_border, color: Colors.yellow),
                                      SizedBox(width: 4.0),
                                      Text('favourites'.tr(), style: kTextStyle2,),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white,
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
                            SizedBox(height: 24.0),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12.0),
                              color: Colors.white,
                              constraints: BoxConstraints(
                                minHeight: 64.0,
                                maxWidth: double.infinity,
                                maxHeight: MediaQuery.of(context).size.height - 36,
                              ),
                              child:
                              StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 0),
                                crossAxisCount: 4,
                                itemCount: listOfRawMaterials.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BlockWithAllMaterials(
                                    colorShadow: listOfRawMaterials[index].selectedRawMaterials == true ? kColorShadowInFilter : Colors.transparent,
                                    assetImage: imageDefinitionInFilter(listOfRawMaterials[index].id),
                                    color: colorDefinitionInFilter(listOfRawMaterials[index].id),
                                    onTap: () {
                                      setState(() {
                                        listOfRawMaterials[index].selectedRawMaterials = !listOfRawMaterials[index].selectedRawMaterials;
                                        if (listOfRawMaterials[index].selectedRawMaterials == false) {
                                          removeFilter(listOfRawMaterials[index].id);
                                        } else {
                                          getSelectedMaterialsIdAddToList(listOfRawMaterials[index].id);
                                        }
                                      });
                                    },
                                    text: listOfRawMaterials[index].name,
                                  );
                                },
                                staggeredTileBuilder: (int index) => StaggeredTile.count(2, 1),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                            ),
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
                      boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(800.0)),
                        center: _position,
                        minZoom: 3.0,
                        maxZoom: 18.4,
                    ),
                    layers: [
                      TileLayerOptions(
              urlTemplate: 'https://api.mapbox.com/styles/v1/logiman/ckweydbul0r7015mv54fy9u17/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA'
                  ,
              additionalOptions: {
                            'accessToken': 'pk.eyJ1IjoibG9naW1hbiIsImEiOiJja3c5aTJtcW8zMTJyMzByb240c2Fma29uIn0.3oWuXoPCWnsKDFxOqRPgjA',
                            'id': 'mapbox.mapbox-streets-v8'
                          }

            ),
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
                          icon: Icon(Icons.location_on, color: kColorGrey2, size: 30.0,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
  }

  //запрос на использование геоданных
  // void _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     print('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print('Location permissions are denied');
  //       _sendingMsgProgressBar!.hide();
  //       geolocatorAlert();
  //     }else{
  //       getLocation();
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     print('Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   getLocation();
  // }

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
          builder: (context) =>
              Container(
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

  // void geolocatorAlert () {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.transparent,
  //         content: Container(
  //           height: 160.0,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10.0),
  //             border: Border.all(width: 2.0, color: kColorGreen2),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               SizedBox(height: 10.0),
  //               Text(
  //                 'permission_to_use_geodata'.tr(),
  //                 textAlign: TextAlign.center,
  //                 style: kAlertTextStyle2,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     color: kColorGreen1,
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           _determinePosition();
  //                           Navigator.of(context).pop(false);
  //                         },
  //                         child: Text(
  //                           'provide'.tr(),
  //                           style: kAlertTextStyle3,
  //                         ),
  //                       ),
  //                       Container(
  //                         height: 30.0,
  //                         width: 1.0,
  //                         color: Colors.white,
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           SystemNavigator.pop();
  //                         },
  //                         child: new Text(
  //                           'reject'.tr(),
  //                           style: kAlertTextStyle3,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  //определение геопозиции
  // Future<void> getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _position = position;
  //     // getListOfObjectAddDataToList();
  //   });
  // }

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
  List<ListOfRawMaterials> listOfRawMaterials = [];
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
            builder: (context) =>
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndexMarker = item.id;
                      addMarkers();
                    });
                    getListOfRawMaterialsOfSpecificObjectAddDataToList(selectedIndexMarker, true);
                  },
                  child: selectedIndexMarker != item.id ? Container(
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
                  ) : Container(
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
            builder: (context) =>
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndexMarker = item.id;
                      addMarkers();
                    });
                    getListOfRawMaterialsOfSpecificObjectAddDataToList(selectedIndexMarker, true);
                  },
                  child: selectedIndexMarker != item.id ? Container(
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
                  ) : Container(
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

  List<ListOfRawMaterialsOfSpecificObject> listOfRawMaterialsOfSpecificObject = [];

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

  List<ListOfRawMaterialsOfSpecificObject>? dataListOfRawMaterialsOfSpecificObject;

  Future<void> getListOfRawMaterialsOfSpecificObjectAddDataToList(int selectedIndexMarker, bool update) async {
    if (update) dataListOfRawMaterialsOfSpecificObject = await getListOfRawMaterialsOfSpecificObject(selectedIndexMarker, context);
    if (dataListOfRawMaterialsOfSpecificObject != null) {
      setState(() {
        listOfRawMaterialsOfSpecificObject = dataListOfRawMaterialsOfSpecificObject!;

        cbs.showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            barrierColor: Colors.white.withOpacity(0),
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomSheetOfSelectedMarker(
                    listOfRawMaterialsOfSpecificObject: listOfRawMaterialsOfSpecificObject,
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
                      controllerBottomSheetRout = scaffoldKey.currentState!.showBottomSheet<Null>((BuildContext context) {
                            return BottomSheetRoute(

                              address: address,
                              durationsWalkingToString: durationsWalkingToString,
                              durationsDrivingToString: durationsDrivingToString,
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
                          if (!userInfoClicked) getListOfRawMaterialsOfSpecificObjectAddDataToList(selectedIndexMarker, false);
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
                    latLngSelectedObject: (latSelectedObject, lngSelectedObject) {
                      setState(() {
                        latSelectedObject = latSelectedObject;
                        lngSelectedObject = lngSelectedObject;
                        markers.add(
                          Marker(
                            height: 30.0,
                            width: 30.0,
                            point: LatLng(latSelectedObject, lngSelectedObject),
                            builder: (context) =>
                                InkWell(
                                  onTap: () {},
                                  child: Container(
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
                                  ),
                                ),
                          ),
                        );
                      });
                    },
                  ),
                ],
              );
            }
        ).whenComplete(() {
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
      var dataObjects = await getListOfObjectsInFilter(selectedMaterialsId, context);
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
      if((distanceDriving / 1000) % 10 == 1) {
        distanceDrivingToString = '${(distanceDriving / 1000).round()} ' + 'kilometer'.tr();
      } else if ((distanceDriving / 1000) % 10 > 1 && (distanceDriving / 1000) % 10 < 5) {
        distanceDrivingToString = '${(distanceDriving / 1000).round()} ' + 'kilometers'.tr();
      } else {
        distanceDrivingToString = '${(distanceDriving / 1000).round()} ' + 'kilometrov'.tr();
      }
    } else {
      if(distanceDriving % 10 == 1) {
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
      if((distanceDriving / 1000) % 10 == 1) {
        distanceWalkingToString = '${(distanceWalking / 1000).round()} ' + 'kilometer'.tr();
      } else if ((distanceWalking / 1000) % 10 > 1 && (distanceWalking / 1000) % 10 < 5) {
        distanceWalkingToString = '${(distanceWalking / 1000).round()} ' + 'kilometers'.tr();
      } else {
        distanceWalkingToString = '${(distanceWalking / 1000).round()} ' + 'kilometrov'.tr();
      }
    } else {
      if(distanceWalking % 10 == 1) {
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
  String twoDigits(int n)=>n.toString().padLeft(2,'0');

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
        switch(int.parse(minutes) % 10) {
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
        switch(int.parse(minutes) % 10) {
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
      switch(int.parse(hours) % 10) {
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
      switch(int.parse(minutes) % 10) {
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
        switch(int.parse(minutes) % 10) {
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
        switch(int.parse(minutes) % 10) {
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
      switch(int.parse(hours) % 10) {
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
      switch(int.parse(minutes) % 10) {
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

  List<LatLng> getSelectedToggleSwitch () {
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
  String imageDefinitionInFilter(int id) {
    switch (id) {
      case 1:
        assetImage = 'images/paperboard.png';
        break;
      case 2:
        assetImage = 'images/tape.png';
        break;
      case 3:
        assetImage = 'images/plastic.png';
        break;
      case 4:
        assetImage = 'images/glass.png';
        break;
      case 5:
        assetImage = 'images/metal.png';
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

  Color colorFilterElement = kColorGrey4;
  Color colorDefinitionInFilter(int id) {
    switch (id) {
      case 1:
        colorFilterElement = kColorGrey1InFilter;
        break;
      case 2:
        colorFilterElement = kColorGrey2InFilter;
        break;
      case 3:
        colorFilterElement = kColorBlueInFilter;
        break;
      case 4:
        colorFilterElement = kColorYellowInFilter;
        break;
      case 5:
        colorFilterElement = kColorGrey3InFilter;
        break;
      case 6:
        colorFilterElement = kColorYellow2InFilter;
        break;
      case 7:
        colorFilterElement = kColorGreyInFilter;
        break;
      case 8:
        colorFilterElement = kColorOrangeInFilter;
        break;
    }
    return colorFilterElement;
  }
}
