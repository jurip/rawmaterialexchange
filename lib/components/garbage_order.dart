import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/models/response_list_of_row_materials.dart';
import 'package:app/api/models/response_user_data.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/order_done.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/custom_bottom_sheet.dart' as cbs;
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../main.dart';
import '../utils/order_date_time_picker.dart';
import '../utils/time_picker.dart';
import 'confirmation_button.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Order extends StatefulWidget {
  LatLng? position;
  String? address;

  Order({
    Key? key,
    this.position,
    this.address,
    required double income,
    required List<ListOfRawMaterials> materials,
  }) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
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
                          //height: containerHeight1,
                          //width: 42.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 23.0, left: 16.0, right: 16.0),
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
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: topPadding2),
                      child: Center(
                          child: Text('order'.tr(), style: kAlertTextStyle)),
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
                            GarbageOrderForm(
                              userData: userData,
                              position: widget.position,
                              address: widget.address,
                            ),
                            //66 * 4

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

// Define a custom Form widget.
class GarbageOrderForm extends StatefulWidget {
  UserData? userData;
  LatLng? position;
  String? address;

  GarbageOrderForm({
    Key? key,
    required this.userData,
    required this.position,
    required this.address,
  }) : super(key: key);

  @override
  GarbageOrderFormState createState() {
    return GarbageOrderFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class GarbageOrderFormState extends State<GarbageOrderForm> {
  //для выстраивания маршрута пешком
  @override
  void initState() {
    super.initState();
    //getAddressCoordinates  (context, widget.position!.latitude, widget.position!.longitude);
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##');
  final _dateController = TextEditingController();
  String imageBirthday = '';

  var dropdownValue;

  String getValidateBirthday() {
    if (_dateController.text.isNotEmpty) {
      imageBirthday = 'images/icon.svg';
    } else {
      imageBirthday = 'images/icon1.svg';
    }
    return imageBirthday;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('phone_number'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
              decoration: InputDecoration(
                suffixIcon: imageBirthday == ''
                    ? null
                    : SvgPicture.asset(getValidateBirthday()),
                suffixIconConstraints:
                    BoxConstraints(minHeight: 22, minWidth: 22),
                counterText: "",
                hintText: 'phone_number'.tr(),
                hintStyle: kHintStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: kColorGrey1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2.0, color: kColorGreen1),
                ),
              ),
              // The validator receives the text that the user has entered.

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'required_field'.tr();
                }
                return null;
              },
              initialValue: widget.userData!.phone),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('where_from'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
            decoration: InputDecoration(
              suffixIcon: imageBirthday == ''
                  ? null
                  : SvgPicture.asset(getValidateBirthday()),
              suffixIconConstraints:
                  BoxConstraints(minHeight: 22, minWidth: 22),
              counterText: "",
              hintText: 'where_from'.tr(),
              hintStyle: kHintStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGrey1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGreen1),
              ),
            ),
            // The validator receives the text that the user has entered.

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'required_field'.tr();
              }
              return null;
            },
            initialValue: widget.address,
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('when_take'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
            autofocus: false,
            maxLength: 10,
            inputFormatters: [
              maskFormatter,
            ],
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              OrderDateTimePicker.showSheetDate(context,
                  dateTime: DateTime.now(), onClicked: (date) {
                setState(() {
                  DateTime newDate = DateFormat('yyyy-MM-dd').parse(date);
                  _dateController.text =
                      DateFormat("yyyy-MM-dd").format(newDate);
                });
              });
            },
            controller: _dateController,
            style: kTextStyle2,
            decoration: InputDecoration(
              suffixIcon: imageBirthday == ''
                  ? null
                  : SvgPicture.asset(getValidateBirthday()),
              suffixIconConstraints:
                  BoxConstraints(minHeight: 22, minWidth: 22),
              counterText: "",
              hintText: 'dd.mm.yyyy'.tr(),
              hintStyle: kHintStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGrey1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGreen1),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('take_time'.tr(), style: kAlertTextStyle4),
          ),
          TimePeriodPicker(),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('comment'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: InputDecoration(
              suffixIcon: imageBirthday == ''
                  ? null
                  : SvgPicture.asset(getValidateBirthday()),
              suffixIconConstraints:
                  BoxConstraints(minHeight: 22, minWidth: 22),
              counterText: "",
              hintText: 'comment'.tr(),
              hintStyle: kHintStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGrey1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: kColorGreen1),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text("order_text".tr()),
          SizedBox(height: 40.0),
          ConfirmationButton(
            //46
            text: 'make_order'.tr(),
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                Navigator.pop(context);

                cbs
                    .showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      barrierColor: Colors.white.withOpacity(0),
                      context: context,
                      builder: (BuildContext context) {
                        return OrderDone();
                      },
                    )
                    .whenComplete(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
