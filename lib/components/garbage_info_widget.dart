import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
class GarbageInfoWidget extends StatefulWidget {
  const GarbageInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  _GarbageInfoWidgetState createState() => _GarbageInfoWidgetState();
}

class _GarbageInfoWidgetState extends State<GarbageInfoWidget> {
  List<PopupMenuEntry<PopupItem>> popUpMenuItem = [];

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
  }

  ProgressBar? _sendingMsgProgressBar;

  @override
  Widget build(BuildContext context) {
    return false
        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                color: Colors.white,
              ),
            ),
          )
        : SafeArea(
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: topPadding1),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kColorGrey1,
                          ),
                          height: containerHeight1,
                          width: 42.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: topPadding2),
                      child: Text('how_it_works'.tr(), style: kAlertTextStyle),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: 0,
                          maxWidth: double.infinity,
                          maxHeight: double
                              .infinity //definitionHeightBottomSheetSettings(),
                          ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //66 * 4
                            SizedBox(height: sizedBoxHeight1),
                            Text('how_it_works_text'.tr()),
                            Text("\n\n\n\n\n\n\n\n\n")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
