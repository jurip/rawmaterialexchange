import 'package:app/api/models/response_authorization.dart';
import 'package:app/api/models/response_list_languages.dart';
import 'package:app/api/requests/requests.dart';
import 'package:app/components/confirmation_button.dart';
import 'package:app/components/exit_alert.dart';
import 'package:app/components/input_fields.dart';
import 'package:app/components/language_popup_menu.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/registration.dart';
import 'package:app/screens/verification.dart';
import 'package:app/utils/progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../main.dart';
import '../utils/user_session.dart';
import 'map_screen.dart';

class Authorisation extends StatefulWidget {
  const Authorisation({Key? key}) : super(key: key);

  @override
  _AuthorisationState createState() => _AuthorisationState();
}

class _AuthorisationState extends State<Authorisation> {
  List<PopupItem> items = [
    PopupItem(title: "Русский", image: 'images/Ellipse ru.png'),
    PopupItem(title: "Узбекский", image: 'images/Ellipse uz.png'),
    //PopupItem(title: "Таджикский", image: 'images/Ellipse td.png'),
    PopupItem(title: "Киргизский", image: 'images/Ellipse kz.png')
  ];

  List<Widget> languages2 = [
    Row(children: [
      Image(
        image: AssetImage('images/Ellipse ru.png'),
        width: 20,
        height: 20,
      ),
      SizedBox(
        width: 10.0,
      ),
      Text('Русский')
    ]),
    Row(children: [
      Image(image: AssetImage('images/Ellipse uz.png'), width: 20, height: 20),
      SizedBox(
        width: 10.0,
      ),
      Text('Узбекский')
    ]),
    //Row(children: [Image(image: AssetImage('images/Ellipse td.png'), width: 20, height: 20), SizedBox(width: 10.0,),Text('Таджикский')]),
    Row(children: [
      Image(image: AssetImage('images/Ellipse kz.png'), width: 20, height: 20),
      SizedBox(
        width: 10.0,
      ),
      Text('Киргизский')
    ]),
  ];

  List<PopupMenuEntry<PopupItem>> popUpMenuItem = [];

  List<String> _numberForm = ['### ### ## ##', '## ### ## ##', '### ## ####'];

  //Россия Казахстан +7 XXX XXX XX XX
  //Узбекистан +998 XX ХХХ-ХХ-ХХ
  //Таджикистан +992 XXX XX XXXX
  List<String> _regionNumber = ['+7', '+998', '+992'];

  var maskFormatter = new MaskTextInputFormatter(mask: '### ### ## ##');

  var selectedLanguage =
      PopupItem(title: "Русский", image: 'images/Ellipse ru.png');

  void languageDefinition() {
    if (mainLocale!.languageCode == 'ru') {
      selectedLanguage =
          PopupItem(title: "Русский", image: 'images/Ellipse ru.png');
    } else if (mainLocale!.languageCode == 'kk') {
      selectedLanguage =
          PopupItem(title: "Казахский", image: 'images/Ellipse kz.png');
    } else if (mainLocale!.languageCode == 'uz') {
      selectedLanguage =
          PopupItem(title: "Узбекский", image: 'images/Ellipse uz.png');
    }
  }

  final _phoneController = TextEditingController();

  String imagePhone = '';

  String _region = '+7';

  int selectedLanguageId = 1;

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
    languageDefinition();
    getListOfLanguageAddDataToList().then((value) {
      if (listLanguage.isNotEmpty)
        listLanguage.forEach((element) {
          if (element.id != 4)
            popUpMenuItem.add(PopupMenuItem(
                value: PopupItem(
                    title: element.name,
                    image: definitionLanguageImage(element.id)),
                child: Row(children: [
                  Image(
                      image: AssetImage(definitionLanguageImage(element.id)),
                      width: 20,
                      height: 20),
                  SizedBox(width: 10.0),
                  Text(element.name)
                ])));
        });
    });
    _sendingMsgProgressBar = ProgressBar();
  }

  String languageImage = '';

  String definitionLanguageImage(int languageId) {
    switch (languageId) {
      case 1:
        languageImage = 'images/Ellipse ru.png';
        break;
      case 2:
        languageImage = 'images/Ellipse uz.png';
        break;
      case 3:
        languageImage = 'images/Ellipse kz.png';
        break;
      case 4:
        languageImage = 'images/Ellipse td.png';
        break;
    }
    return languageImage;
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
                          LanguagePopupMenu(
                            onSelected: (value) {
                              setState(() {
                                selectedLanguage = value;
                                if (value.image == 'images/Ellipse ru.png') {
                                  selectedLanguageId = 1;
                                  context.setLocale(Locale('ru'));
                                } else if (value.image ==
                                    'images/Ellipse uz.png') {
                                  selectedLanguageId = 2;
                                  context.setLocale(Locale('uz'));
                                } else if (value.image ==
                                    'images/Ellipse kz.png') {
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
                            },
                            assetImage: AssetImage(selectedLanguage.image),
                            itemBuilder: (context) => popUpMenuItem,
                          ),
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
                            getAuthorization(phoneNumber).then((data) {
                              _sendingMsgProgressBar?.hide();
                              if (data != null) {
                                if (data.smsSended !=
                                    null /* && data.smsCode != null */) {
                                  nextScreen(context, data);
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

  void nextScreen(BuildContext context, ResponseAuthorization data) {
    getVerificationResponse(9999, phoneNumber).then((data) {
      _sendingMsgProgressBar!.hide();
      if (data != null) {
        if (data.accessToken != '' &&
            data.accessToken != null) {
          UserSession.setTokenFromSharedPref(
              data.accessToken!);
          UserSession.setPhoneFromSharedPref(
              phoneNumber);
          UserSession.setLanguageFromSharedPref(
              selectedLanguageId);

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

    /* Navigator.push(context,
        MaterialPageRoute(builder: (context) {
      return Verification(
        phone: phoneNumber,
        smsCode: data.smsCode,
      );
    }));*/
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

  //получение списка языков
  List<ListLanguages> listLanguage = [];

  Future<void> getListOfLanguageAddDataToList() async {
    _sendingMsgProgressBar?.show(context);
    var dataLanguage = await getLanguages();
    if (dataLanguage != null) {
      setState(() {
        listLanguage = dataLanguage;
      });
    } else {
      setState(() {
        error = 'Error';
      });
    }
    _sendingMsgProgressBar?.hide();
  }
}
