import 'dart:async';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:app/api/models/response_list_of_services.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/bottom_sheet_setting_components/settings_widget.dart';
import 'package:app/components/custom_app_bar.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/favourites_bottom_sheet.dart';
import 'package:app/components/location_info_widget.dart';
import 'package:app/components/material_card_widget.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../api/models/material_list_item.dart';
import '../components/garbage_widget.dart';
import '../components/other_material_card_widget.dart';
import '../constants/image_constants.dart';
import '../main.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen>
{

  ProgressBar _sendingMsgProgressBar = ProgressBar();
  late MapboxMapController mapController;
  List<MaterialListItem> listOfFilters = [];
  List<Service> listOfServices = [
    Service(id: 9, name: "garbage_collection".tr(), image: imageDefinitionInFilter(9)),
  ];
  List<Service> listOfOthers = [
    Service(id: 10, name: "other".tr(),image: imageDefinitionInFilter(10)),
  ];
  List<int> selectedMaterialsId = [];

  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData() {
    getIt<MyRequests>().getListOfRawMaterials().then((value) => {
      setState(() {
        if(value!=null)
          listOfFilters = value;
      })
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            assetImage: list[index].image,
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

  Widget otherHorizontalScrollList(BuildContext context,List<Service> list, onTap) {
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
            assetImage: list[index].image,
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
    return listOfFilters.isEmpty //|| _position == null
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
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              barrierColor: Colors.white.withOpacity(0),
              context: context,
              builder: (BuildContext context) {
                return SettingsWidget();
              },
            )
                .whenComplete(() {
            });
          },
        ),
        key: scaffoldKey,
        body: SlidingUpPanel(
          minHeight: 140,
          maxHeight: 590,
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
              MapboxMap(
                myLocationEnabled: true,
                trackCameraPosition: true,
                onMapCreated: _onMapCreated,
                styleString: 'mapbox://styles/mapbox/light-v11',
                minMaxZoomPreference: MinMaxZoomPreference(3.0, 18.4),
                initialCameraPosition: CameraPosition(
                  target: LatLng(55.76350864466721, 37.61888069876945),
                  zoom: 15.0,
                ),
                onStyleLoadedCallback: () => onStyleLoaded(mapController),
                accessToken: dotenv.env["ACCESS_TOKEN"],),

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
                    onPressed: () async {

                      await moveToMyLocation();
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

  Future<void> moveToMyLocation() async {
    var loc = await mapController.requestMyLocationLatLng();
    if(loc!=null)
      mapController.moveCamera(CameraUpdate.newLatLng(loc));
  }

  Future<void> loadPoints() async {
    setState(() {
      _sendingMsgProgressBar.show(context);
    });
    var dataObjects =
    await getIt<MyRequests>().getObjectsGeojson(selectedMaterialsId, context);
    if (dataObjects != null) {
      mapController.setGeoJsonSource("points", dataObjects);
      _sendingMsgProgressBar.hide();
    } else {
      setState(() {
        _sendingMsgProgressBar.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('no_dots'.tr()),
        ));
      });
    }
  }


  onServiceTap(index) {
    scaffoldKey.currentState!.showBottomSheet(
          (context) =>
          GarbageWidget(materials: listOfFilters, position: mapController.cameraPosition?.target),
      backgroundColor: Colors.transparent,
    );
  }

  onFilterTap(index) {
    setState(() {
      listOfFilters[index].selected = !listOfFilters[index].selected;
      if (listOfFilters[index].selected == false) {
        selectedMaterialsId.remove(listOfFilters[index].id);
        loadPoints();
      } else {
        selectedMaterialsId.add(listOfFilters[index].id);
        loadPoints();
      }
    });
  }

  onFavouritesTap(index) {
    scaffoldKey.currentState!.showBottomSheet(
          (context) => FavouritesBottomSheet(),
      backgroundColor: Colors.transparent,
    );
  }

  void onStyleLoaded(MapboxMapController controller) async{
    this.mapController = controller;
    await controller.setMapLanguage("name_ru");
    var json = await getIt<MyRequests>().getObjectsGeojson(selectedMaterialsId, context);
    if(json!=null)
      await controller.addGeoJsonSource("points", json);
    await controller.addSymbolLayer(
      "points",
      "symbols",
      SymbolLayerProperties(
        iconImage: "images/point.png",
        iconSize: 2,
        iconAllowOverlap: true,
      ),
    );
  }
  void _onMapCreated(MapboxMapController controller) {
    this.mapController = controller;
    mapController.onFeatureTapped.add(onFeatureTap);
    mapController.requestMyLocationLatLng().then((value) =>
        mapController.moveCamera(CameraUpdate.newLatLngZoom(value!, 15)));
  }
  Future<void> onFeatureTap(dynamic featureId, Point<double> point, LatLng latLng) async {
    _sendingMsgProgressBar.show(context);
    int id = int.parse(featureId);
    _sendingMsgProgressBar.hide();
    Navigator.push(context, MaterialPageRoute(builder: (context)  {
      return LocationInfoWidget(id:id
      );
    }));
  }

}
