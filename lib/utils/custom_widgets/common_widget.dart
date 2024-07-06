import 'package:flutter/material.dart';
import '../colors.dart';
import '../constants.dart';

class DefaultAssetImage extends StatelessWidget {
  const DefaultAssetImage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage(kDefaultAssetImage),fit: BoxFit.fill,);
  }
}

class SaveClearWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const SaveClearWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
          style: ButtonStyle(
            elevation: WidgetStateProperty.all<double?>(5),
            padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical:  title == 'Add' ? 16 : 12)),
            backgroundColor: WidgetStateProperty.all<Color>(appThemeColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: title == 'Add' ? 20 : 16, fontWeight: FontWeight.w700),
          )),
    );
  }
}

