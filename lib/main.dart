import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/map_screen.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/shared_preferences.dart';

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
        child: MyApp()
    ),
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      getToken();
    });
  }

  @override
  Widget build(BuildContext context) {

    mainLocale = context.locale;

    return MaterialApp(

      // supportedLocales: [
      //   Locale('ru'),
      //   Locale('kk'),
      //   Locale('tjk'),
      //   Locale('uz')
      // ],
      //locale: Locale("kk"),

      localizationsDelegates:
      context.localizationDelegates,
      // [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   // ... app-specific localization delegate[s] here
      //   SfGlobalLocalizations.delegate,
      //   AppLocalizations.delegate,
      // ],



      // localeResolutionCallback: (locale, supportedLocales) {
      //   // Check if the current device locale is supported
      //   for (var supportedLocale in supportedLocales) {
      //     if (supportedLocale.languageCode == locale!.languageCode &&
      //         supportedLocale.countryCode == locale.countryCode) {
      //       return supportedLocale;
      //     }
      //   }
      //   // If the locale of the device is not supported, use the first one
      //   // from the list (English, in this case).
      //   return supportedLocales.first;
      // },

      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: kColorGreen1,
            selectionColor: kColorGreen2,
            selectionHandleColor: kColorGreen1,
          )
      ),
      home:  token == '' ? Registration() : MapScreen(),
    );
  }

  static String token = '';
  static String phone = '';

  void getToken() {
    Settings.getTokenFromSharedPref().then((value) {
        setState(() {
          token = value;
        });
    });
  }

}
//      Future.delayed(const Duration(milliseconds: 5000), () {