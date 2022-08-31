import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RouteWidget extends StatefulWidget {
  RouteWidget({
    Key? key,
    required this.address,
    required this.durationsWalkingToString,
    required this.durationsDrivingToString,
    required this.selectedToggleSwitch,
    required this.onSelectedToggleSwitchChange,
    required this.distanceDrivingToString,
    required this.distanceWalkingToString,
    required this.removeRoute,
    required this.returnMarkers,
  }) : super(key: key);

  final String address;
  final String durationsWalkingToString;
  final String durationsDrivingToString;
  bool selectedToggleSwitch;
  final Function(bool) onSelectedToggleSwitchChange;
  String distanceDrivingToString;
  String distanceWalkingToString;
  final Function() removeRoute;
  final Function() returnMarkers;

  @override
  _RouteWidgetState createState() => _RouteWidgetState();
}

class _RouteWidgetState extends State<RouteWidget> {
  _RouteWidgetState();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    timeAndDistance =
        '${widget.durationsWalkingToString} (${widget.distanceWalkingToString})';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            SizedBox(height: 14.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kColorGrey1,
              ),
              height: 4.0,
              width: 42.0,
            ),
            SizedBox(height: 14.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.removeRoute();
                      widget.returnMarkers();
                    },
                    child: Icon(Icons.arrow_back_ios_outlined, size: 24.0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'your_position'.tr(),
                                style: kTextStyle7,
                              ),
                              Icon(Icons.location_on, color: Colors.yellow),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            width: double.infinity,
                            height: 2.0,
                            color: kColorGrey1,
                          ),
                          SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(widget.address,
                                      style: kTextStyle7, softWrap: true)),
                              Container(
                                height: 22.0,
                                width: 22.0,
                                decoration: BoxDecoration(
                                  color: kColorGreen1,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      width: 4.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            width: double.infinity,
                            height: 2.0,
                            color: kColorGrey1,
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            decoration: BoxDecoration(
                              color: kColorGrey1,
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ToggleSwitch(
                                animate: false,
                                fontSize: 18.0,
                                minWidth: 80.0,
                                cornerRadius: 20.0,
                                activeBgColors: [
                                  [Colors.white],
                                  [Colors.white]
                                ],
                                inactiveBgColor: kColorGrey1,
                                inactiveFgColor: Colors.black,
                                activeFgColor: Colors.black,
                                initialLabelIndex: selectedIndex,
                                totalSwitches: 2,
                                icons: [
                                  Icons.directions_walk,
                                  Icons.directions_car
                                ],
                                radiusStyle: true,
                                onToggle: (index) {
                                  setState(() {
                                    selectedIndex = index!;
                                    widget.selectedToggleSwitch =
                                        !widget.selectedToggleSwitch;
                                    widget.onSelectedToggleSwitchChange(
                                        widget.selectedToggleSwitch);
                                    getTimeAndDistance(index);
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'travel_time'.tr(),
                            style: kBottomSheetTextStyle3,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.0),
                          Text(timeAndDistance,
                              style: kAlertTextStyle,
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeAndDistance = '';

  bool updatedSelectedToggleSwitch = false;

  String getTimeAndDistance(int index) {
    if (index == 1) {
      setState(() {
        timeAndDistance =
            '${widget.durationsDrivingToString} (${widget.distanceDrivingToString})';
      });
    } else {
      setState(() {
        timeAndDistance =
            '${widget.durationsWalkingToString} (${widget.distanceWalkingToString})';
      });
    }
    return timeAndDistance;
  }
}
