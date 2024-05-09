import 'package:flutter/material.dart';
import '../colors.dart';

class FullScreenLoadingWidget extends StatelessWidget {
  final bool isLoading;
  const FullScreenLoadingWidget({
    super.key, required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: GestureDetector(
        onTap: (){},
        onDoubleTap: (){},
        child: Container(
          color: Colors.black12,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CircularProgressIndicator(
              color: appThemeColor,
              strokeWidth: 6,
            ),
          ),
        ),
      ),
    );
  }
}