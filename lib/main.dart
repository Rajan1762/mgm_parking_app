import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mgm_parking_app/dummy_screen.dart';
import 'package:mgm_parking_app/screens/enrty_screens/entry_screen.dart';
import 'package:mgm_parking_app/screens/home_screens/home_main_screen.dart';
import 'package:mgm_parking_app/screens/offline_screen.dart';
import 'package:mgm_parking_app/screens/profile_screens/login_screen.dart';
import 'package:mgm_parking_app/screens/profile_screens/shif_open_screen.dart';
import 'package:mgm_parking_app/screens/scan_dummy.dart';
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
    // subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async
    // {
    //   print("connectivity result = $result");
    //
    //   if(result.contains(ConnectivityResult.none))
    //   {
    //     if(networkDownCount==0)
    //     {
    //       networkDownCount = 1;
    //       const MaterialApp(
    //         home: OfflineScreen(),
    //       );
    //       // await Navigator.of(context as BuildContext).push(MaterialPageRoute(builder: (context) => const OfflineScreen()));
    //     }
    //   }
    // });
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

Future<void> _getSharedPrefValue() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  shiftIDValue = prefs.getString(shiftIdString) ?? '';
  userIDValue = prefs.getString(userIdString) ?? '';
  logInTimeVal = prefs.getString(logInTimeString) ?? '';
  openingAmountValue = prefs.getString(openingAmountString) ?? '';
  print('shiftIDValue = $shiftIDValue, userIDValue = $userIDValue,\n logInTimeVal = $logInTimeVal, openingAmountValue = $openingAmountValue');
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
          scaffoldBackgroundColor: Colors.grey.shade300,
          textTheme: GoogleFonts.nunitoSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: appThemeColor),
          useMaterial3: true,
        ),
        // home: const ShiftOpenScreen()
        // home: const DummyScreen()
        home: shiftIDValue == '' ? const LoginScreen() : openingAmountValue == '' ? const ShiftOpenScreen() : const HomeMainScreen()
      ),
    );
  }
}

