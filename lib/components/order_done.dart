import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:app/utils/shared_preferences.dart';
import '../../main.dart';
import 'confirmation_button.dart';
import 'order_column.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Order extends StatefulWidget {
  const Order({
    Key? key,
  }) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {

  List<PopupMenuEntry<PopupItem>> popUpMenuItem = [ ];

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
        containerHeight2
        >= MediaQuery.of(context).size.height
    ) {
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
    return userData == null || listLanguage.isEmpty ?
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green,
          color: Colors.white,
        ),
      ),
    ) :
    SafeArea(
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
              topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
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
                child: Center(child: Text('order'.tr(), style: kAlertTextStyle)),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 0,
                  maxWidth: double.infinity,
                  maxHeight: definitionHeightBottomSheetSettings(),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //66 * 4
                      InformationColumn(
                        text1: 'phone'.tr(),
                        text2: userData!.name,
                      ),
                      InformationColumn(
                        text1: 'address'.tr(),
                        text2: userData!.surname,
                      ),
                      InformationColumn(
                        text1: 'day'.tr(),
                        text2: userData!.phone,
                      ),
                      InformationColumn(
                        text1: 'time'.tr(),
                        text2: birthDateUser,
                      ),
                      SizedBox(height: sizedBoxHeight1),
                      Align(
                        alignment: Alignment.centerLeft,
                          child: Text('language'.tr(), style: kAlertTextStyle4),
                      ),
                      SizedBox(height: sizedBoxHeight2),
                      Row(
                        children: [
                          DropdownButton<ListLanguages>(
                            value: dropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_right), //TODO!!!!!!!!!!!!!!!!
                            style: kTextStyle2,
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (ListLanguages? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                setState(() {
                                  if (dropdownValue!.id == 1) {
                                    selectedLanguageId = 1;
                                    context.setLocale(Locale('ru'));
                                  } else if (dropdownValue!.id == 2) {
                                    selectedLanguageId = 2;
                                    context.setLocale(Locale('uz'));
                                  } else if (dropdownValue!.id == 3) {
                                    selectedLanguageId = 3;
                                    context.setLocale(Locale('kk'));
                                  }
                                  mainLocale = context.locale;
                                  // } else if (value.image == 'images/Ellipse td.png') {
                                  //   selectedLanguageId = 4;
                                  //   //context.setLocale(Locale('tjk'));
                                  //   //EasyLocalization.of(context)!.locale = Locale('ar', 'SA');
                                  // }
                                });
                              });
                            },
                            items: listLanguage.map<DropdownMenuItem<ListLanguages>>((ListLanguages value) {
                              return DropdownMenuItem<ListLanguages>(
                                value: value,
                                child: Text(value.name),//value.name
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: sizedBoxHeight3),
                      Container(width: double.infinity, height: containerHeight2, color: kColorGrey1,),
                      SizedBox(height: sizedBoxHeight4),
                      ConfirmationButton(//46
                        text: 'make_order'.tr(),
                        onTap: () async {
                          cbs.showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            barrierColor: Colors.white.withOpacity(0),
                            context: context,
                            builder: (BuildContext context) {
                              return Order();
                            },
                          ).whenComplete(() {

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