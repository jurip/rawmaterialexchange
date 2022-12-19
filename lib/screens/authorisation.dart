import 'package:app/api/requests/requests.dart';
import 'package:app/components/confirmation_button.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/input_fields.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/language_select.dart';
import 'package:app/screens/registration.dart';
import 'package:app/screens/verification.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../main.dart';

class Authorisation extends StatefulWidget {
  const Authorisation({Key? key}) : super(key: key);

  @override
  _AuthorisationState createState() => _AuthorisationState();
}

class _AuthorisationState extends State<Authorisation> {

  List<String> _numberForm = ['### ### ## ##', '## ### ## ##', '### ## ####'];

  //Россия Казахстан +7 XXX XXX XX XX
  //Узбекистан +998 XX ХХХ-ХХ-ХХ
  //Таджикистан +992 XXX XX XXXX
  List<String> _regionNumber = ['+7', '+998', '+992'];

  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##');
  final _phoneController = TextEditingController();

  String imagePhone = '';

  String _region = '+7';


  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _sendingMsgProgressBar = ProgressBar();
  }

  ProgressBar? _sendingMsgProgressBar;

  @override
  void initState() {
    super.initState();
    _sendingMsgProgressBar = ProgressBar();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: MyWillPop(context: context).onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('entrance'.tr(), style: kTextStyle1),
                          LanguageSelect(),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              underline: Container(
                                height: 2,
                                color: kColorGrey1,
                              ),
                              style: kTextStyle2,
                              itemHeight: 66.0,
                              value: _region,
                              items: _regionNumber
                                  .map<DropdownMenuItem<String>>((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? region) {
                                if (region != null)
                                  setState(() {
                                    _region = region;
                                    changeForm(_region);
                                  });
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: PhoneInputField(
                              hintText: definitionPlaceHolder(),
                              inputFormatters: [maskFormatter],
                              controller: _phoneController,
                              //_phoneController,
                              //maskFormatter.getUnmaskedText(phoneNumber);
                              svgPicture: imagePhone == ''
                                  ? null
                                  : SvgPicture.asset(getValidatePhone()),
                              textChange: (str) {
                                setState(() {});
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text('enter_your_authorization_number'.tr(),
                          style: kTextStyle5),
                      SizedBox(height: 40.0),
                      ConfirmationButton(
                        text: 'enter'.tr(),
                        onTap: () {
                          getValidatePhone();
                          if (_phoneController.text != '' &&
                              _region !=
                                  '' /* && imagePhone == 'images/icon.svg'*/) {
                            _sendingMsgProgressBar?.show(context);
                            changingNumber();
                            getIt<MyRequests>().getAuthorization(phoneNumber).then((data) {
                              _sendingMsgProgressBar?.hide();
                              if (data != null) {
                                if (data.smsSended !=
                                    null /* && data.smsCode != null */) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Verification(
                                      phone: phoneNumber,
                                      smsCode: data.smsCode,
                                    );
                                  }));
                                } else {
                                  if (data.errors != null &&
                                      data.errors!.isNotEmpty) {
                                    String toastMessage = data.errors!.first;
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
                                      'check_your_network_connection'.tr()),
                                ));
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text('dont_have_account_yet'.tr(), style: kTextStyle5),
                      SizedBox(height: 4.0),
                      InkWell(
                        child: Text('register'.tr(), style: kTextStyle4),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Registration()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String placeHolder = '';

  String definitionPlaceHolder() {
    if (_region.isNotEmpty) {
      if (_region == '+7') {
        placeHolder = '(___)___-__-__';
      } else if (_region == '+998') {
        placeHolder = '__ ___-__-__';
      } else if (_region == '+992') {
        placeHolder = '___ __ ____';
      }
    }
    return placeHolder;
  }

  void changeForm(String str) {
    int position = 0;
    for (int index = 0; index < _regionNumber.length; index++) {
      if (_regionNumber[index] == str) {
        position = index;
      }
    }
    setState(() {
      _region = str;
      maskFormatter = new MaskTextInputFormatter(mask: _numberForm[position]);
    });
  }

  String getValidatePhone() {
    setState(() {
      if (_phoneController.text.isNotEmpty || _region.isNotEmpty) {
        if (_region == '+7') {
          if (_phoneController.text.length == 13) {
            imagePhone = 'images/icon.svg';
          } else {
            imagePhone = 'images/icon1.svg';
          }
        } else if (_region == '+998') {
          if (_phoneController.text.length == 12) {
            imagePhone = 'images/icon.svg';
          } else {
            imagePhone = 'images/icon1.svg';
          }
        } else if (_region == '+992') {
          if (_phoneController.text.length == 11) {
            imagePhone = 'images/icon.svg';
          } else {
            imagePhone = 'images/icon1.svg';
          }
        }
      } else {
        imagePhone = 'images/icon1.svg';
      }
    });
    return imagePhone;
  }

  String phoneNumber = '';

  void changingNumber() {
    String tempRegion = '';
    if (_region == '+7') {
      tempRegion = '7';
    } else if (_region == '+998') {
      tempRegion = '998';
    } else if (_region == '+992') {
      tempRegion = '992';
    }
    var unformattedStr = maskFormatter.getUnmaskedText();
    phoneNumber = tempRegion + unformattedStr;
  }
  String error = '';
}
