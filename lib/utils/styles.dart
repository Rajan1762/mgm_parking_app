import 'package:flutter/material.dart';

InputDecoration profileTextFieldStyles({required String label,Widget? prefixIcon}){
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: label,
      isDense: true,
      prefixIcon: prefixIcon,
      counterText: "",
      contentPadding:
      const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      focusedBorder: homeTextInputBorder(),
      border: homeTextInputBorder(),
      enabledBorder: homeTextInputBorder()

  );
}

OutlineInputBorder homeTextInputBorder() {
  return OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(8),
  );
}
