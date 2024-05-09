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
            elevation: MaterialStateProperty.all<double?>(5),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 12)),
            backgroundColor: MaterialStateProperty.all<Color>(appThemeColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          )),
    );
  }
}