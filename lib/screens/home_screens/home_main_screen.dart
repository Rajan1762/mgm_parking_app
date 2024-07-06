import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mgm_parking_app/model/profile_models/logout_model.dart';
import 'package:mgm_parking_app/model/profile_models/logout_response_model.dart';
import 'package:mgm_parking_app/screens/enrty_screens/entry_screen.dart';
import 'package:mgm_parking_app/screens/exit_screens/exit_screen.dart';
import 'package:mgm_parking_app/screens/profile_screens/login_screen.dart';
import 'package:mgm_parking_app/sevices/network_services/home_screen_services.dart';
import 'package:mgm_parking_app/utils/constants.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import '../../sevices/network_services/exit_screen_services.dart';
import '../../sevices/print_services/sunmi.dart';
import '../../utils/colors.dart';
import '../../utils/common_values.dart';
import '../offline_screen.dart';
import 'top_entries_page.dart';
import 'full_screen_loading.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  int bottomBarIndex = 0;

  _printReceipt(LogOutResponseModel e) {
    List<ColumnMaker> cList = [];
    cList.add(alignColumn(
      text: '--------------------------------',
    ));
    double total = 0;
    e.data?.forEach((element) {
      String s = "";
      int length = 32 - ((element.cASH?.length ?? 0) + element.aMOUNT.toString().length);
      for(int  i =0;i<length;i++)
        {
          s += " ";
        }
      cList.add(alignColumn(text: '${element.cASH}$s${element.aMOUNT}'));
      total += element.aMOUNT ?? 0.0;
    });
    cList.add(alignColumn(
      text: '--------------------------------',
    ));
    String s = '';
    int l = 32 - ('Total'.length + '$rupeeSymbol$total'.length);
    for(int  i =0;i<l;i++)
    {
      s += " ";
    }
    cList.add(alignColumn(text: 'Total$s$rupeeSymbol$total'));
    cList.add(alignColumn(
      text: '--------------------------------',
    ));
    cList.add(alignColumn(text: 'Booth : BOOTH_2'));
    cList.add(alignColumn(text: 'UserID : $userIDValue'));
    cList.add(alignColumn(text: 'LogInTime : $logInTimeVal'));
    cList.add(alignColumn(
        text:
            'LogOutTime : ${DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now())}'));
    cList.add(alignColumn(
      text: '--------------------------------',
    ));
    Sunmi printer = Sunmi();
    printer.printExitReceipt(cl: cList, userName: userIDValue);
  }

  ColumnMaker alignColumn({required String text, SunmiPrintAlign? align}) {
    return ColumnMaker(
      text: text,
      width: 10,
      align: align ?? SunmiPrintAlign.LEFT,
    );
  }

  Future<bool> _logOutUser(BuildContext context) async {
    try {
      LogOutResponseModel? logOutResponseModel = await logOutUser(
          logoutModel: LogOutModel(shiftname: shiftIDValue, username: userIDValue));
      if (logOutResponseModel == null && context.mounted) {
        showErrorAlertDialog(context: context, message: networkIssueMessage);
        return false;
      }
      _printReceipt(logOutResponseModel!);
    } catch (e) {
      if (context.mounted) {
        showErrorAlertDialog(context: context, message: e.toString());
      }
      return false;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(shiftIdString, '');
    shiftIDValue = '';
    prefs.setString(userIdString, '');
    userIDValue = '';
    prefs.setString(logInTimeString, '');
    logInTimeVal = '';
    prefs.setString(openingAmountString, '');
    openingAmountValue = '';
    return true;
  }

  @override
  void initState() {
    var s = '--------------------------------';
    print("s.length = ${s.length}");
    subscription =
        Connectivity().onConnectivityChanged.listen(_handlesConnectivity);
    super.initState();
  }

  _handlesConnectivity(List<ConnectivityResult> result) async {
    print("connectivity result = $result");

    if (result.contains(ConnectivityResult.none)) {
      if (networkDownCount == 0) {
        networkDownCount = 1;
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OfflineScreen()));
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(userIDValue,
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(color: appThemeColor),
                        )),
                  ),
                  SizedBox(
                    width: 150,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(' $logInTimeVal',
                          style: GoogleFonts.oswald(
                            textStyle: TextStyle(color: appThemeColor),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return TopEntriesPage(entryStatus: entryExitStatus);
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.remove_red_eye_outlined,size: 30,color: appThemeColor),
                )),
            GestureDetector(
                onTap: () {
                  showCommonAlertDialog(
                      context: context,
                      message: 'Are you sure to Log Out?',
                      onTap: () async {
                        bool result = await _logOutUser(context);
                        if (result && context.mounted) {
                          shiftIDValue = '';
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                          // Navigator.pop(context);
                          // SystemNavigator.pop();
                        }
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.exit_to_app_outlined,size: 30,
                      color: Colors.grey.shade700),
                ))
          ],
        ),
      ),
      body: bottomBarIndex == 0 ? const EntryScreen() : const ExitScreen() ,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_outlined, size: 20),
            label: 'Entry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, size: 20),
            label: 'Exit',
          ),
        ],
        currentIndex: bottomBarIndex,
        selectedItemColor: appThemeColor,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey.shade600,
        onTap: (index) {
          setState(() {
            bottomBarIndex = index;
          });
        },
      ),
    ));
  }
}
