import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../utils/common_functions.dart';

class DateTimeProvider extends ChangeNotifier{
  String _date = '';
  String _time = '';

  String get date => _date;
  String get time => _time;

  runTimer()
  {
    _date = formatDate(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _time = formatTime(DateTime.now());
      notifyListeners();
    });
  }
}