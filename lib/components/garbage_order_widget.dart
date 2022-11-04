import 'package:app/api/requests/requests.dart';
import 'package:app/components/garbage_order_result_widget.dart';
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

import '../api/models/Order.dart';
import '../api/models/material_list_item.dart';
import '../utils/garbage_order_date_time_picker.dart';
import '../utils/time_picker.dart';
import '../utils/user_session.dart';
import 'confirmation_button.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class GarbageOrderWidget extends StatefulWidget {
  final String address;
  final List<MaterialListItem> materials;
  final double income;
  final LatLng? position;

  GarbageOrderWidget({
    Key? key,
    required this.income,
    required this.materials,
    required this.address,
    required this.position,
  }) : super(key: key);

  @override
  _GarbageOrderWidgetState createState() => _GarbageOrderWidgetState();
}

class _GarbageOrderWidgetState extends State<GarbageOrderWidget> {
  List<PopupMenuEntry<PopupItem>> popUpMenuItem = [];
  ProgressBar? _sendingMsgProgressBar;
  String? phone;
  String language = '';
  final Order order = Order();

  void getUserData() {
    UserSession.getUserPhone().then((value) {
      setState(() {
        phone = value;
      });
    });
    UserSession.getUserLanguage().then((value) {
      setState(() {
        language = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();

    _sendingMsgProgressBar = ProgressBar();
  }

  @override
  Widget build(BuildContext context) {
    return phone == null
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
        : SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 200,
      ),
      //height: 900,
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
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1),
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
                          top: 16.0, left: 16.0, right: 16.0),
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
                      padding: EdgeInsets.only(top: 1),
                      child: Center(
                          child: Text('order'.tr(), style: kAlertTextStyle)),
                    ),

                    GarbageOrderForm(
                      phone: phone,
                      address: widget.address,
                      items: widget.materials,
                      position: widget.position,
                    ),
                    //66 * 4
                  ],
                ),
              ),
    ),
          );
  }

  String error = '';

//получение списка языков
}

// Define a custom Form widget.
class GarbageOrderForm extends StatefulWidget {
  final String? phone;
  final String? address;
  final List<MaterialListItem> items;
  final LatLng? position;

  GarbageOrderForm({
    Key? key,
    required this.phone,
    required this.address,
    required this.items,
    required this.position,
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
    DateTime newDate = DateTime.now().add(const Duration(days: 3));
    _dateController.text = DateFormat("yyyy-MM-dd").format(newDate);
  }

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##');
  final TextEditingController _dateController = TextEditingController();

  final _timeController = TextEditingController();
  String valid = '';
  var dropdownValue;
  var order = Order();

  String getValidateBirthday() {
    if (_dateController.text.isNotEmpty) {
      valid = 'images/icon.svg';
    } else {
      valid = 'images/icon1.svg';
    }
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text('phone_number'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
              onSaved: (String? value) {
                order.phone = value;
              },
              decoration: InputDecoration(
                suffixIcon: valid == ''
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
                if (value.length != 11) {
                  return 'wrong_format'.tr();
                }
                return null;
              },
              initialValue: widget.phone),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text('where_from'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
            onSaved: (String? value) {
              order.address = value;
            },
            decoration: InputDecoration(
              suffixIcon:
                  valid == '' ? null : SvgPicture.asset(getValidateBirthday()),
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
            alignment: Alignment.topLeft,
            child: Text('when_take'.tr(), style: kAlertTextStyle4),
          ),
          TextFormField(
            onSaved: (String? value) {
              if (value != null) order.datetimePickup = value;
            },
            autofocus: false,
            maxLength: 10,
            inputFormatters: [
              maskFormatter,
            ],
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              GarbageOrderDateTimePicker.showSheetDate(context,
                  dateTime: DateTime.now().add(const Duration(days: 3)), minimumDate: DateTime.now().add(const Duration(days: 2)), onClicked: (date) {
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
              suffixIcon:
                  valid == '' ? null : SvgPicture.asset(getValidateBirthday()),
              suffixIconConstraints:
                  BoxConstraints(minHeight: 22, minWidth: 22),
              counterText: "",
              hintText: 'dd.mm.yyyy',
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
            alignment: Alignment.topLeft,
            child: Text('take_time'.tr(), style: kAlertTextStyle4),
          ),
          TimePeriodPicker(
            onOptionSelected: (item) => {order.time = timePeriods[item]},
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text('comment'.tr(), style: kAlertTextStyle4),
          ),
          Align(

            alignment: Alignment.topLeft,
            child: TextFormField(
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom +100),

              onSaved: (String? value) {
                order.comment = value;
              },
              // The validator receives the text that the user has entered.
              decoration: InputDecoration(
                suffixIcon: valid == ''
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
          ),
          SizedBox(height: 10.0),
          ConfirmationButton(
            //46
            text: 'make_order'.tr(),
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                _formKey.currentState!.save();

                order.items = widget.items;

                order.latitude = widget.position!.latitude;
                order.longitude = widget.position!.longitude;
                if (order.time == null)
                  order.time = timePeriods[(DateTime.now().hour / 2).toInt()];
                addOrder(context, order);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                Navigator.pop(context);
                widget.items.forEach((element) {
                  element.amount = 0;
                });

                cbs
                    .showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      barrierColor: Colors.white.withOpacity(0),
                      context: context,
                      builder: (BuildContext context) {
                        return GarbageOrderResultWidget();
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
