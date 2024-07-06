import 'package:flutter/material.dart';
import 'package:mgm_parking_app/utils/colors.dart';

class FullScreenLoading extends StatefulWidget {
  const FullScreenLoading({super.key});

  @override
  State<FullScreenLoading> createState() => _FullScreenLoadingState();
}

class _FullScreenLoadingState extends State<FullScreenLoading> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.black12,
      child: Center(
        child: CircularProgressIndicator(
          color: appThemeColor,
          strokeWidth: 6,
        ),
      ),
    );
  }
}
