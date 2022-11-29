import 'package:app/screens/map_screen.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/user_session.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'constants/color_constants.dart';

Locale? mainLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
    getPermission();


  }
  void initPos() async{
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .timeout(new Duration(seconds: 25));
    var p = await SharedPreferences.getInstance();
    p.setDouble("lat", newPosition.latitude);
    p.setDouble("lng", newPosition.longitude);
  }
  Future<bool> getPermission() async {
    var enabled = await Geolocator.checkPermission();
    if (enabled == LocationPermission.denied) {
      enabled = await Geolocator.requestPermission();
      if(enabled != LocationPermission.denied &&
          enabled != LocationPermission.deniedForever)
        initPos();
    }
    return enabled != LocationPermission.denied &&
        enabled != LocationPermission.deniedForever;
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
