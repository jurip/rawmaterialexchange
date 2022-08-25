import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.removeRoute,
    required this.returnMarkers,
    required this.updatingLanguageInTheFilter,
    required this.returnListOfSelectedMarkerBottomSheet,
    required this.showUserSettingsInfo,
  }) : super(key: key);

  final Function() removeRoute;
  final Function() returnMarkers;
  final Function() updatingLanguageInTheFilter;
  final Function() returnListOfSelectedMarkerBottomSheet;

  final Function() showUserSettingsInfo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Container(
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
        child: IconButton(
          icon: Icon(Icons.person, color: kColorGrey2, size: 30.0),
          onPressed: () {
            removeRoute();
            returnMarkers();
            showUserSettingsInfo();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
