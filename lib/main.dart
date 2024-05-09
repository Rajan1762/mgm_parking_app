import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mgm_parking_app/screens/profile_screens/login_screen.dart';
import 'package:mgm_parking_app/sevices/provider_services/date_time_provider.dart';
import 'package:mgm_parking_app/sevices/provider_services/floorTableProviderService.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import 'package:mgm_parking_app/utils/common_values.dart';
import 'package:mgm_parking_app/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _getSharedPrefValue();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    HttpOverrides.global = MyHttpOverrides();
    DateTime dateTime = DateTime.now();
    currentDate = "${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}-${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}-${dateTime.year}";
    print('currentDate = $currentDate');
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

Future<void> _getSharedPrefValue() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  kOrganizationCodeVal = prefs.getString(kOrganizationCode) ?? "";
  kEmployeeCodeVal = prefs.getString(kEmployeeCode) ?? "";
  kIsCaptainVal = prefs.getString(kIsCaptain) ?? "";
  kAuthTokenVal = prefs.getString(kAuthToken) ?? "";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>FloorTableProviderService()),
        ChangeNotifierProvider(create: (context)=>DateTimeProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ParkingApp',
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: appThemeColor),
          useMaterial3: true,
        ),
        home: const LoginScreen()//kEmployeeCodeVal == '' ? const LoginScreen() : const HomeMainScreen(),
      ),
    );
  }
}

