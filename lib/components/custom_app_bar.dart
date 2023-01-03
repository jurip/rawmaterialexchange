import 'package:app/constants/color_constants.dart';
import 'package:flutter/material.dart';

import 'bottom_sheet_setting_components/settings_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);
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
          onPressed:  () async {
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
