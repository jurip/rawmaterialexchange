import 'package:app/screens/map_screen.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/user_session.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'constants/color_constants.dart';

Locale? mainLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('ru'),
          Locale('kk'),
          //Locale('tjk'),
          Locale('uz')
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('ru'),
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    getToken();

  }

  @override
  Widget build(BuildContext context) {
    mainLocale = context.locale;

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'GothamProNarrow-Medium',
          textSelectionTheme: TextSelectionThemeData(
        cursorColor: kColorGreen1,

        selectionColor: kColorGreen2,
        selectionHandleColor: kColorGreen1,
      )),
      home: token == '' ? Registration() : MapScreen(),
    );
  }

  static String token = '';

  void getToken() {
    UserSession.getTokenFromSharedPref().then((value) {
      setState(() {
        token = value;
      });
    });
  }
}
