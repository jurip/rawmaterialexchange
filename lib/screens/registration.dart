import 'package:app/api/requests/requests.dart';
import 'package:app/components/confirmation_button.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/input_fields.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/language_bloc.dart';
import 'package:app/screens/language_select.dart';
import 'package:app/screens/verification.dart';
import 'package:app/utils/date_time_picker.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../main.dart';
import 'authorisation.dart';

class Registration extends StatefulWidget {
  const Registration({
    Key? key,
  }) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  List<String> _numberForm = ['### ### ## ##', '## ### ## ##', '### ## ####'];

  //Россия Казахстан +7 XXX XXX XX XX
  //Узбекистан +998 XX ХХХ-ХХ-ХХ
  //Таджикистан +992 XXX XX XXXX
  List<String> _regionNumber = ['+7', '+998', '+992'];
  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##');

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  String _region = '+7';
  String imageName = '';
  String imageSurname = '';
  String imagePhone = '';
  String imageBirthday = '';
  ProgressBar? _sendingMsgProgressBar = ProgressBar();
  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = context.select((LanguageBloc value) => value.state.lang,);
    return WillPopScope(
      onWillPop: MyWillPop(context: context).onWillPop,
      child: GestureDetector(
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
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('registration'.tr(), style: kTextStyle1),
                            LanguageSelect(),
                          ],
                        ),
                        SizedBox(height: 32.0),
                        NameInputField(
                          hintText: 'name'.tr(),
                          controller: _nameController,
                          svgPicture: imageName == ''
                              ? null
                              : SvgPicture.asset(getValidateName()),
                          textChange: (_) {
                            setState(() {});
                            return null;
                          },
                        ),
                        SizedBox(height: 24.0),
                        NameInputField(
                          hintText: 'surname'.tr(),
                          controller: _surnameController,
                          svgPicture: imageSurname == ''
                              ? null
                              : SvgPicture.asset(getValidateSurname()),
                          textChange: (_) {
                            setState(() {});
                            return null;
                          },
                        ),
                        SizedBox(height: 14.0),
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
                                    .map<DropdownMenuItem<String>>(
                                        (String item) {
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
                        SizedBox(height: 24.0),
                        TextFormField(
                          autofocus: false,
                          maxLength: 10,
                          inputFormatters: [
                            maskFormatter,
                          ],
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            DateTimePicker.showSheetDate(context,
                                dateTime: DateTime.now(), onClicked: (date) {
                              setState(() {
                                DateTime newDate =
                                    DateFormat('yyyy-MM-dd').parse(date);
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
                            hintText: 'date_birthday'.tr(),
                            hintStyle: kHintStyle,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: kColorGrey1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: kColorGreen1),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        ConfirmationButton(
                          text: 'registration'.tr(),
                          onTap: () {
                            getValidation();
                            if (_nameController.text != '' &&
                                _surnameController.text != '' &&
                                _phoneController.text != '' &&
                                _dateController.text != '' &&
                                _region != '') {
                              _sendingMsgProgressBar?.show(context);
                              changingNumber();
                              getIt<MyRequests>().getRegistration(
                                      _nameController.text,
                                      _surnameController.text,
                                      phoneNumber,
                                      _dateController.text,
                                      lang)
                                  .then((data) {
                                _sendingMsgProgressBar?.hide();
                                if (data != null) {
                                  if (data.smsSended != null) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Verification(
                                        phone: phoneNumber,
                                        smsCode: data.smsCode,
                                        name: _nameController.text,
                                        surname: _surnameController.text,
                                        dateBirthday: _dateController.text,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('have_account'.tr(), style: kTextStyle5),
                            SizedBox(width: 8.0),
                            InkWell(
                              child: Text('enter'.tr(), style: kTextStyle4),
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Authorisation()),
                                    (route) => false);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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

  void getValidation() {
    setState(() {
      if (_nameController.text.isEmpty &&
          _surnameController.text.isEmpty &&
          _phoneController.text.isEmpty &&
          _dateController.text.isNotEmpty &&
          _region.isEmpty) {
        imageName = 'images/icon1.svg';
        imageSurname = 'images/icon1.svg';
        imagePhone = 'images/icon1.svg';
      } else {
        getValidateName();
        getValidateSurname();
        getValidatePhone();
        getValidateBirthday();
      }
    });
  }

  String getValidateName() {
    if (_nameController.text.isNotEmpty) {
      imageName = 'images/icon.svg';
    } else {
      imageName = 'images/icon1.svg';
    }
    return imageName;
  }

  String getValidateSurname() {
    if (_surnameController.text.length >= 2) {
      imageSurname = 'images/icon.svg';
    } else {
      imageSurname = 'images/icon1.svg';
    }
    return imageSurname;
  }

  String getValidatePhone() {
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
    }
    return imagePhone;
  }

  String getValidateBirthday() {
    if (_dateController.text.isNotEmpty) {
      imageBirthday = 'images/icon.svg';
    } else {
      imageBirthday = 'images/icon1.svg';
    }
    return imageBirthday;
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
}
class PopupItem {
  final String title;
  final String image;

  PopupItem({required this.title, required this.image});
}
