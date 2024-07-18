import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import '../common_values.dart';

void autoDeleteAlertDialog({required BuildContext context,required String message,required Function() futureFunction})
{
  alertOkStatus = false;
  showDialog(
      barrierDismissible : false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 1), futureFunction
        );
        return AlertDialog(
          title: Text(message),
          // actions: <Widget>[
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       TextButton(
          //         onPressed:(){
          //           alertOkStatus = true;
          //           Navigator.of(context).pop();
          //           },
          //         child: Text('OK',style: TextStyle(color: appThemeColor,fontWeight: FontWeight.bold,fontSize: 18)),
          //       ),
          //     ],
          //   ),
          // ],
        );
      });
}

void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

void showMessageAlertDialog({required BuildContext context,required String message})
{
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(message),
    );
  });
}

void showCommonAlertDialog({required BuildContext context,required String message,required Function() onTap})
{
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed:()=>Navigator.of(context).pop(),
          child:  Text('Cancel',style: TextStyle(color: appThemeColor)),
        ),
        TextButton(
          onPressed:onTap,
          child:  Text('OK',style: TextStyle(color: appThemeColor)),
        ),
      ],
    );
  });
}

void showErrorAlertDialog({required BuildContext context,required String message})
{
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: const Text('Error',style: TextStyle(color: Colors.red)),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed:()=>Navigator.of(context).pop(),
          child: const Text('OK',style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  });
}
