import 'package:flutter/material.dart';
import 'package:mgm_parking_app/utils/colors.dart';

void showCommonAlertDialog({required BuildContext context,required String message,required Function() onTap})
{
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      content: Text(message),
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
