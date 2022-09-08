import 'package:app/api/models/response_list_of_raw_materials_of_specific_object.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong2/latlong.dart';

import '../constants/color_constants.dart';
import '../constants/style_constants.dart';

class LocationInfoWidget extends StatefulWidget {
  final List<ListOfRawMaterialsOfSpecificObject> materials;
  final LatLng? position;

  LocationInfoWidget({
    Key? key,
    required this.materials,
    required this.position,
  }) : super(key: key);

  @override
  _LocationInfoWidgetState createState() => _LocationInfoWidgetState();
}

class _LocationInfoWidgetState extends State<LocationInfoWidget> {
  String address = "";
  double income = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/location_background.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                        child:
                            Image(image: AssetImage("images/arrow_back.png")),
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
                            child: Image(image: AssetImage("images/heart.png")),
                          ),
                        ])
                  ]),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Text(
                    "ул. Гагарина 51",
                    style: bigWhite,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 10,
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
                      children: [
                        Text("getCurrentDate()", style: kBottomSheetTextStyle),
                        Icon(
                          Icons.keyboard_arrow_down,
                          //size: iconSize2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: kColorYellowInFilter,
                      border: Border.all(color: kColorGrey1, width: 3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image(image: AssetImage("images/phone.png")),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: kColorYellowInFilter,
                      border: Border.all(color: kColorGrey1, width: 3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image(image: AssetImage("images/site.png")),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 50,
              child: Container(
                // A fixed-height child.
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                child: Expanded(
                  flex: 50,
                  child: Column(

                      children: [
                      Container(
                      height:350,
                      child:
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          crossAxisCount: 4,
                          itemCount: widget.materials.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                //width: 200,

                                decoration: BoxDecoration(
                                  color: kColorGrey1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage("images/paperboard_2.png"),
                                      height: 80,
                                    ),
                                    Text(
                                      "110 p/ kg",
                                      style: kTextStyle11,
                                    ),
                                    Text(
                                      "Karton",
                                      style: kTextStyle11,
                                    )
                                  ],
                                ));
                          },
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, 2),
                          //listOfRawMaterialsOfSpecificObject.length % 2 == 0 || index == listOfRawMaterialsOfSpecificObject.length ? StaggeredTile.count(4, 1) : StaggeredTile.count(2, 1),
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        )
                    ),
                      ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kColorGreen1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                            ),
                            child: Text(
                              "route".tr(),
                              textAlign: TextAlign.center,
                              style: kTextStyle3,
                            ),
                          ),
                        ),
                  ]),
                ),
              ),
            ),
          ]),
        ));
  }

  List<int> selectedMaterials = [];

  //удаление фильтра
  void removeFilter(int id) {
    selectedMaterials.remove(id);
  }
}
