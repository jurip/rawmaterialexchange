import 'package:app/screens/language_bloc.dart';
import 'package:app/screens/map_screen.dart';
import 'package:app/screens/registration.dart';
import 'package:app/utils/user_session.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'api/requests/requests.dart';
import 'api/requests/requests_prod.dart';
import 'constants/color_constants.dart';

Locale? mainLocale;
final getIt = GetIt.instance;
void setup() {
  getIt.registerSingleton<MyRequests>(MyRequestsProd());
}

void setupTest() {
  getIt.registerSingleton<MyRequests>(MyRequestsDev());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  //setupTest();

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => LanguageBloc(),
      ),
    ],
    child: EasyLocalization(
        supportedLocales: [
          Locale('ru'),
          Locale('kk'),
          //Locale('tj'),
          Locale('uz')
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('ru'),
        child: MyApp()),
  ));
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

  Future<bool> getPermission() async {
    var enabled = await Geolocator.checkPermission();
    if (enabled == LocationPermission.denied) {
      enabled = await Geolocator.requestPermission();
    }
    return enabled != LocationPermission.denied &&
        enabled != LocationPermission.deniedForever;
  }

  @override
  Widget build(BuildContext context) {
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
