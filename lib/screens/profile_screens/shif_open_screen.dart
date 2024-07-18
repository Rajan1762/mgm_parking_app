import 'package:flutter/material.dart';
import 'package:mgm_parking_app/screens/home_screens/home_main_screen.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import '../../model/errorResponseModel.dart';
import '../../sevices/network_services/profile_services.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/notification_widgets.dart';

class ShiftOpenScreen extends StatefulWidget {
  const ShiftOpenScreen({super.key});

  @override
  State<ShiftOpenScreen> createState() => _ShiftOpenScreenState();
}

class _ShiftOpenScreenState extends State<ShiftOpenScreen> {
  TextEditingController openingAmountController = TextEditingController();

  _openShift() async
  {
    bool shiftOpenStatus = false;
    String? message;
    try {
      shiftOpenStatus = await shiftUser(openingAmount: openingAmountController.value.text);
      // obj = await loginUser(userName: userName, password: password);
      print('obj = $shiftOpenStatus');
    } catch (e) {
      message = e.toString();
      print('Error Occurred $e');
    }
    print('objsgsg = $shiftOpenStatus');
    return ErrorResponseModel(obj: shiftOpenStatus, errorMessage: message);
  }

  @override
  void dispose() {
    openingAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: appThemeColor
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6
              )
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Opening Amount',style: TextStyle(color: appThemeColor,fontSize: 24,fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(bottom: 40,top: 10),
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: openingAmountController,
                    decoration: InputDecoration(
                      border: buildOutlineInputBorder(),
                      enabledBorder: buildOutlineInputBorder(),
                      errorBorder: buildOutlineInputBorder(),
                      focusedBorder: buildOutlineInputBorder(),
                      disabledBorder: buildOutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(const EdgeInsets.symmetric(vertical: 5,horizontal: 20)),
                  backgroundColor: WidgetStateProperty.all<Color?>(appThemeColor),
                  foregroundColor: WidgetStateProperty.all<Color?>(Colors.white),
                  shape: WidgetStateProperty.all<OutlinedBorder?>(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ))
                ),onPressed: ()async{
                  if(openingAmountController.value.text.isNotEmpty)
                    {
                      ErrorResponseModel e = await _openShift();
                      if(context.mounted)
                      {
                        print('e.obj = ${e.obj}');
                        if(e.obj)
                        {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeMainScreen()));
                        }else{
                          showErrorAlertDialog(context: context, message: e.errorMessage ?? networkIssueMessage);
                        }
                      }
                    }else{
                    showCommonAlertDialog(context: context, message: 'Enter Amount to Continue', onTap: (){Navigator.pop(context);});
                  }
              }, child: const Text('Shift Open',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),))
            ],
          ),
        ),
      ),
    ));
  }

  OutlineInputBorder buildOutlineInputBorder() => OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Colors.grey.shade700,
          width: 2
    )
  );
}

