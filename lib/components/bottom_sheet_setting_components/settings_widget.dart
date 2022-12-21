import 'dart:async';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/language_select.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:app/utils/user_session.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../confirmation_button.dart';
import 'information_column.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  static const platform = MethodChannel('rawmaterials/openTelegram');
  UserData? userData;
  String error = '';
  String birthDateUser = '';
  ProgressBar? _sendingMsgProgressBar;
  Future<void> _openTelegram() async {
    try {
      await platform.invokeMethod('openTelegram');
    } on PlatformException catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getToken();
    _sendingMsgProgressBar = ProgressBar();
  }

  @override
  Widget build(BuildContext context) {
    return userData == null
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
            child: SingleChildScrollView(
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
                        child: Center(
                            child:
                                Text('settings'.tr(), style: kAlertTextStyle)),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 0,
                          maxWidth: double.infinity,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //66 * 4
                              InformationColumn(
                                text1: 'name'.tr(),
                                text2: userData!.name,
                              ),
                              InformationColumn(
                                text1: 'surname'.tr(),
                                text2: userData!.surname,
                              ),
                              InformationColumn(
                                text1: 'phone_number'.tr(),
                                text2: userData!.phone,
                              ),
                              InformationColumn(
                                text1: 'date_birthday'.tr(),
                                text2: birthDateUser,
                              ),
                              SizedBox(height: sizedBoxHeight1),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('language'.tr(),
                                    style: kAlertTextStyle4),
                              ),
                              SizedBox(height: sizedBoxHeight2),
                              LanguageSelect(),
                              SizedBox(height: sizedBoxHeight3),
                              Container(
                                width: double.infinity,
                                height: containerHeight2,
                                color: kColorGrey1,
                              ),
                              SizedBox(height: sizedBoxHeight4),
                              Text(
                                "connect".tr(),
                                style: kTextStyle2,
                              ),
                              InkWell(
                                  onTap: () {
                                    _openTelegram();
                                  },
                                  child: Image(
                                    image: AssetImage("images/telegram.png"),
                                    height: 25,
                                  )),
                              SizedBox(height: sizedBoxHeight4),
                              ConfirmationButton(
                                //46
                                text: 'logout'.tr(),
                                onTap: () {
                                  _sendingMsgProgressBar?.show(context);
                                  UserSession.setTokenFromSharedPref('');
                                  getIt<MyRequests>().logout(context).then((value) {
                                    _sendingMsgProgressBar?.hide();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(value!.message.toString()),
                                    ));
                                  });
                                },
                              ),
                              SizedBox(height: sizedBoxHeight5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
  void getToken() async {
    await getIt<MyRequests>().getUserData(context).then((data) {
      setState(() {
        userData = data;
      });
    });

    String birthDate = userData!.birthDate.toString();
    birthDateUser = birthDate.substring(0, birthDate.indexOf(' '));
  }
}
