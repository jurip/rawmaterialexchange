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
import 'confirmation_button.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class GarbageOrderResultWidget extends StatefulWidget {
  const GarbageOrderResultWidget({
    Key? key,
  }) : super(key: key);

  @override
  _GarbageOrderResultWidgetState createState() =>
      _GarbageOrderResultWidgetState();
}

class _GarbageOrderResultWidgetState extends State<GarbageOrderResultWidget> {
  List<PopupMenuEntry<PopupItem>> popUpMenuItem = [];

  @override
  void initState() {
    super.initState();
    getToken();
    _sendingMsgProgressBar = ProgressBar();
    getListOfLanguageAddDataToList();
  }

  int selectedLanguageId = 1;

  ProgressBar? _sendingMsgProgressBar;

  ListLanguages? dropdownValue;

  final double topPadding1 = 12.0;
  final double topPadding2 = 16.0;
  final double containerHeight1 = 4.0;
  final double informationColumnHeight = 66.0;
  final double sizedBoxHeight1 = 24.0;
  final double sizedBoxHeight2 = 0.0;
  final double sizedBoxHeight3 = 8.0;
  final double sizedBoxHeight4 = 40.0;
  final double confirmationButtonHeight = 46.0;
  final double sizedBoxHeight5 = 40.0;

  final double textHeight1 = 20.0;
  final double textHeight2 = 12.0;
  final double textHeight3 = 18.0;

  final double containerHeight2 = 2.0;

  double heightBottomSheetSettings = 0;

  double definitionHeightBottomSheetSettings() {
    if (topPadding1 +
            topPadding2 +
            containerHeight1 +
            (informationColumnHeight * 4) +
            sizedBoxHeight1 +
            sizedBoxHeight2 +
            sizedBoxHeight3 +
            sizedBoxHeight4 +
            confirmationButtonHeight +
            sizedBoxHeight5 +
            textHeight1 +
            textHeight2 +
            textHeight3 +
            containerHeight2 >=
        MediaQuery.of(context).size.height) {
      heightBottomSheetSettings = MediaQuery.of(context).size.height;
    } else {
      heightBottomSheetSettings = topPadding1 +
          topPadding2 +
          containerHeight1 +
          (informationColumnHeight * 4) +
          sizedBoxHeight1 +
          sizedBoxHeight2 +
          sizedBoxHeight3 +
          sizedBoxHeight4 +
          confirmationButtonHeight +
          sizedBoxHeight5 +
          textHeight1 +
          textHeight2 +
          textHeight3 +
          containerHeight2;
    }
    return heightBottomSheetSettings;
  }

  @override
  Widget build(BuildContext context) {
    return userData == null || listLanguage.isEmpty
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
                      child: Center(
                          child:
                              Text('order_done'.tr(), style: kAlertTextStyle)),
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
                            Text("orded_done_text".tr()),
                            SizedBox(height: sizedBoxHeight3),
                            Container(
                              width: double.infinity,
                              height: containerHeight2,
                              color: kColorGrey1,
                            ),
                            SizedBox(height: sizedBoxHeight4),
                            ConfirmationButton(
                              //46
                              text: 'to_main'.tr(),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: sizedBoxHeight5),
                            SizedBox(height: 300),
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

  UserData? userData;

  void getToken() async {
    await getUserData(context).then((data) {
      setState(() {
        userData = data;
      });
    });
    definitionLanguage();
    definitionBirthDate();
  }

  String language = '';

  void definitionLanguage() {
    if (userData!.languageId == 1) {
      language = 'Русский';
    } else if (userData!.languageId == 2) {
      language = 'Узбекский';
    } else if (userData!.languageId == 3) {
      language = 'Таджитский';
    } else if (userData!.languageId == 4) {
      language = 'Киргизский';
    }
  }

  String birthDateUser = '';

  void definitionBirthDate() {
    String birthDate = userData!.birthDate.toString();
    birthDateUser = birthDate.substring(0, birthDate.indexOf(' '));
  }

  String error = '';

  //получение списка языков
  List<ListLanguages> listLanguage = [];

  Future<void> getListOfLanguageAddDataToList() async {
    // _sendingMsgProgressBar?.show(context); // TODO Что-то не так с ним
    var dataLanguage = await getLanguages();
    if (dataLanguage != null) {
      setState(() {
        listLanguage = dataLanguage;
        for (int index = 0; index < listLanguage.length; index++) {
          if (listLanguage[index].id == 4) {
            listLanguage.removeAt(index);
          }
        }
        if (listLanguage.isNotEmpty) languageDefinition();
        //dropdownValue = listLanguage.first;
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
    _sendingMsgProgressBar?.hide();
  }

  void languageDefinition() {
    if (mainLocale!.languageCode == 'ru') {
      dropdownValue = listLanguage[0];
    } else if (mainLocale!.languageCode == 'kk') {
      dropdownValue = listLanguage[2];
    } else if (mainLocale!.languageCode == 'uz') {
      dropdownValue = listLanguage[1];
    }
  }
}
