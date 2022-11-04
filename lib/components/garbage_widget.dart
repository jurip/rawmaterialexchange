import 'package:app/api/requests/requests.dart';
import 'package:app/components/garbage_change_amount_button.dart';
import 'package:app/components/garbage_order_widget.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../api/models/material_list_item.dart';
import '../constants/image_constants.dart';
import 'garage_order_button.dart';
import 'garbage_add_button.dart';
import 'garbage_info_widget.dart';

class GarbageWidget extends StatefulWidget {
  final List<MaterialListItem> materials;
  final LatLng? position;

  GarbageWidget({
    Key? key,
    required this.materials,
    required this.position,
  }) : super(key: key);

  @override
  _GarbageWidgetState createState() => _GarbageWidgetState();
}

class _GarbageWidgetState extends State<GarbageWidget> {
  String address = "";
  double income = 0;

  Future<void> setAddress() async {
    getAddressCoordinates(
      context,
      widget.position!.longitude,
      widget.position!.latitude,
    ).then((value) {
      if (value != null) address = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setAddress();
    income = getIncome();
  }

  @override
  Widget build(BuildContext context) {
    return widget.materials == null
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.green,
              ),
            ),
          )
        : Container(
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
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
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
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_left,
                              size: 30.0,
                            ),
                            Text('main'.tr(),
                                style: TextStyle(
                                  color: Color(0xFF2E2E2E),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'GothamProNarrow-Medium',
                                  fontSize: 18.0,
                                ))
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.0),
                          Text('garbage_collection_header'.tr(),
                              style: header),
                          SizedBox(height: 5.0),
                          Text('garbage_collection_text'.tr()),
                          SizedBox(height: 15.0),
                          InkWell(
                            child: Text(
                              'how_it_works_link'.tr(),
                              style: linkStyle,
                            ),
                            onTap: () async {
                              if (true) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );

                                cbs
                                    .showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GarbageInfoWidget();
                                      },
                                    )
                                    .whenComplete(() {});
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.materials.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.materials[index].selected =
                                  !widget.materials[index].selected;
                              if (widget.materials[index].selected == false) {
                                removeFilter(widget.materials[index].id);
                              } else {
                                selectedMaterials
                                    .add(widget.materials[index].id);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.materials[index].name,
                                          style: kTextStyle2,
                                          softWrap: true,
                                        ),
                                      ),
                                      if (widget.materials[index].amount >
                                          0) ...[
                                        Image(
                                          image:
                                              AssetImage("images/ptichka.png"),
                                          width: 30,
                                        )
                                      ]
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  if (widget.materials[index].selected) ...[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(
                                            image: AssetImage("images/" +
                                                imageName(widget
                                                    .materials[index].id) +
                                                "2.png"))),
                                    SizedBox(height: 10.0),
                                    //Text(widget.materials[index].text),
                                    //SizedBox(height: 10.0),
                                    Row(children: [
                                      Text("price:".tr(), style: grey,
                                      ),
                                      Text(" "+widget.materials[index].price
                                          .toString()),
                                      Text("rub_per_100_kilo".tr(),)
                                    ]),
                                    SizedBox(height: 10.0),
                                    Text("you_give".tr(), style: grey,),
                                    SizedBox(height: 10.0),
                                    GarbageChangeAmountButton(
                                      text: widget
                                              .materials[index].changedAmount
                                              .toString() +
                                          ' ' +
                                          "kg".tr(),
                                      onMinusTap: () => {
                                        setState(() {
                                          if (widget.materials[index]
                                                  .changedAmount >
                                              300) {
                                            widget.materials[index]
                                                .changedAmount = widget
                                                    .materials[index]
                                                    .changedAmount -
                                                10;
                                          }
                                          if (widget.materials[index].amount >
                                              0) {
                                            widget.materials[index].amount =
                                                widget.materials[index]
                                                    .changedAmount;
                                            income = getIncome();
                                          }
                                        })
                                      },
                                      onPlusTap: () => {
                                        setState(() {
                                          widget.materials[index]
                                              .changedAmount = widget
                                                  .materials[index]
                                                  .changedAmount +
                                              10;
                                          if (widget.materials[index].amount >
                                              0) {
                                            widget.materials[index].amount =
                                                widget.materials[index]
                                                    .changedAmount;
                                            income = getIncome();
                                          }
                                        })
                                      },
                                    ),
                                    SizedBox(height: 5.0),
                                    if (widget.materials[index].amount ==
                                        0) ...[
                                      GarbageAddButton(
                                        text: "Add".tr(),
                                        onTap: () {
                                          setState(() {
                                            widget.materials[index].selected =
                                                !widget
                                                    .materials[index].selected;
                                            if (widget.materials[index]
                                                    .selected ==
                                                false) {
                                              removeFilter(
                                                  widget.materials[index].id);
                                            } else {
                                              selectedMaterials.add(
                                                  widget.materials[index].id);
                                            }

                                            widget.materials[index].amount =
                                                widget.materials[index]
                                                    .changedAmount;

                                            income = getIncome();
                                          });
                                        },
                                      )
                                    ] else ...[
                                      GarbageAddButton(
                                        text: "Delete".tr(),
                                        onTap: () {
                                          setState(() {
                                            widget.materials[index].selected =
                                                !widget
                                                    .materials[index].selected;
                                            if (widget.materials[index]
                                                    .selected ==
                                                false) {
                                              removeFilter(
                                                  widget.materials[index].id);
                                            } else {
                                              selectedMaterials.add(
                                                  widget.materials[index].id);
                                            }

                                            widget.materials[index].amount = 0;

                                            income = getIncome();
                                          });
                                        },
                                      )
                                    ],
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                income!=0?Padding(
                  padding:
                      const EdgeInsets.only(top: 23.0, left: 16.0, right: 16.0),
                  child: GarbageOrderButton(
                    //46
                    text1: 'your_income'.tr(),
                    text2: income.toString() + ' ' + "rub".tr(),
                    onTap: () async {
                      Navigator.pop(context);

                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            barrierColor: Colors.white.withOpacity(0),
                            context: context,
                            builder: (BuildContext context) {
                              return GarbageOrderWidget(
                                income: income,
                                materials: widget.materials,
                                address: address,
                                position: widget.position,
                              );
                            },
                          )
                          .whenComplete(() {});
                    },
                  ),
                ):Text(""),
                SizedBox(height: 10.0),
              ],
            ),
          );
  }

  double getIncome() {
    double sum = 0;
    widget.materials.forEach((element) {
      sum = sum + element.amount * element.price/100;
    });
    return sum;
  }

  List<int> selectedMaterials = [];

  //удаление фильтра
  void removeFilter(int id) {
    selectedMaterials.remove(id);
  }
}
