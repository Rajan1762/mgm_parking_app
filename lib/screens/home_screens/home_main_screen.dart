import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mgm_parking_app/screens/enrty_screens/entry_screen.dart';
import 'package:mgm_parking_app/screens/exit_screens/exit_screen.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';
import '../../utils/colors.dart';
import '../report_screen/report_screen.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  int bottomBarIndex = 0;

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
                  showCommonAlertDialog(context: context, message: 'Are you sure to Exit App', onTap: () {
                    Navigator.pop(context);
                    SystemNavigator.pop();
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
