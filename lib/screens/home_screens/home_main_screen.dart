import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mgm_parking_app/model/profile_models/logout_model.dart';
import 'package:mgm_parking_app/screens/enrty_screens/entry_screen.dart';
import 'package:mgm_parking_app/screens/exit_screens/exit_screen.dart';
import 'package:mgm_parking_app/screens/profile_screens/login_screen.dart';
import 'package:mgm_parking_app/sevices/network_services/home_screen_services.dart';
import 'package:mgm_parking_app/utils/constants.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  int bottomBarIndex = 0;

  Future<void> _logOutUser()async{
    await logOutUser(logoutModel: LogOutModel(
      shiftname: shiftIDValue
    ));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(shiftIdString, '');
    shiftIDValue = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('BOT PARKING',style:  GoogleFonts.oswald(
                 textStyle: TextStyle(
                   color: appThemeColor
                 ),
               )),
              GestureDetector(
                onTap: (){
                  showCommonAlertDialog(context: context, message: 'Are you sure to Log Out?', onTap: () async{
                    await _logOutUser();
                    if(context.mounted)
                      {
                        shiftIDValue = '';
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                        // Navigator.pop(context);
                        // SystemNavigator.pop();
                      }
                  });
                },
                  child: Icon(Icons.exit_to_app_outlined,color: Colors.grey.shade600))
            ],
          ),),
      body: bottomBarIndex == 0
          ? const EntryScreen()
          : const ExitScreen(),

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
