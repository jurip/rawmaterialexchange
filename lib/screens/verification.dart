import 'dart:async';

import 'package:app/api/requests/requests.dart';
import 'package:app/components/confirmation_button.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/map_screen.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:app/utils/user_session.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verification extends StatefulWidget {
  const Verification({
    Key? key,
    required this.phone,
    this.smsCode,
    this.name,
    this.selectedLanguageId,
    this.surname,
    this.dateBirthday,
  }) : super(key: key);

  final String phone;
  final int? smsCode;
  final String? name;
  final String? surname;
  final String? dateBirthday;
  final int? selectedLanguageId;

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _timer!.cancel();
    super.dispose();
  }

  int code = 0;

  var dataList;

  @override
  void initState() {
    super.initState();
    //Geolocator.openLocationSettings();
    smsCode = widget.smsCode;
    startTimer();
    _sendingMsgProgressBar = ProgressBar();
  }

  ProgressBar? _sendingMsgProgressBar;

  Timer? _timer;
  late int _start;

  void startTimer() {
    setState(() {
      _start = 60;
    });

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  int? smsCode = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _start = 0;
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(smsCode.toString()),
                            ));
                          },
                          child: Text('verification'.tr(), style: kTextStyle1),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: PinCodeTextField(
                        keyboardType: TextInputType.phone,
                        autoFocus: true,
                        textStyle: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'GothamProNarrow-Medium',
                          fontWeight: FontWeight.w500,
                        ),
                        validator: null,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          inactiveColor: kColorGrey1,
                          activeColor: kColorGrey1,
                          disabledColor: kColorGrey1,
                          errorBorderColor: kColorGrey1,
                          inactiveFillColor: kColorGrey1,
                          selectedColor: kColorGrey1,
                          selectedFillColor: kColorGrey1,
                          shape: PinCodeFieldShape.underline,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 64,
                          activeFillColor: Colors.black,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.white,
                        enableActiveFill: false,
                        controller: _codeController,
                        onCompleted: (v) {
                          print("Completed");
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            //currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                        appContext: context,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Text('you_will_receive_SMS_to_number'.tr(),
                        style: kTextStyle6),
                    SizedBox(height: 6.0),
                    Text(widget.phone, style: kTextStyle7),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _start > 0
                            ? Text(
                                'no_sms_coming'.tr() + ' ' + _start.toString(),
                                style: kTextStyle8)
                            : InkWell(
                          onTap: () {
                            if (widget.name == null) {
                              getAuthorization(widget.phone).then((data) {
                                _sendingMsgProgressBar?.hide();
                                if (data != null) {
                                  if (data.smsSended !=
                                      null /* && data.sms_sended! */ &&
                                      data.smsCode != null) {
                                    smsCode = data.smsCode;
                                  } else {
                                    if (data.errors != null &&
                                        data.errors!.isNotEmpty) {
                                      String toastMessage =
                                          data.errors!.first;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(toastMessage),
                                      ));
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'check_your_network_connection'
                                            .tr()),
                                  ));
                                }
                              });
                            } else {
                              getRegistration(
                                  widget.name!,
                                  widget.surname!,
                                  widget.phone,
                                  widget.dateBirthday!,
                                  widget.selectedLanguageId!)
                                  .then((data) {
                                _sendingMsgProgressBar?.hide();
                                if (data != null) {
                                  if (data.sms_sended !=
                                      null /* && data.sms_sended! */ &&
                                      data.sms_code != null) {
                                    smsCode = data.sms_code;
                                    //TODO !!!!!!!!!!!!!!!!!!
                                  } else {
                                    if (data.errors != null &&
                                        data.errors!.isNotEmpty) {
                                      String toastMessage =
                                          data.errors!.first;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(toastMessage),
                                      ));
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'check_your_network_connection'
                                            .tr()),
                                  ));
                                }
                              });
                            }
                            startTimer();
                          },
                                child:
                                    Text('send_again'.tr(), style: kTextStyle8),
                              ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    ConfirmationButton(
                      text: 'сontinue'.tr(),
                      onTap: () {
                        if (_codeController.text != '') {
                          code = int.parse(_codeController.text);
                          _sendingMsgProgressBar!.show(context);
                          getSMSCode(code).then((data) {
                            _sendingMsgProgressBar!.hide();
                            if (data != null) {
                              if (data.accessToken != '' &&
                                  data.accessToken != null) {
                                UserSession.setTokenFromSharedPref(
                                    data.accessToken!);
                                UserSession.setPhoneFromSharedPref(
                                    widget.phone);
                                UserSession.setLanguageFromSharedPref(
                                    widget.selectedLanguageId);

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MapScreen();
                                }));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(data.errors!.first),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('check_your_network_connection'.tr()),
                              ));
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
