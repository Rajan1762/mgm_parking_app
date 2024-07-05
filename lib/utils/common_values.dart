import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../model/floor_table_model.dart';

String? currentDate;
List<List<FloorTableModel>> listOfFloorTableListVal = [];
List<List<FloorTableModel>> activeFloorTableVal = [];
List<List<FloorTableModel>> deActiveFloorTableVal = [];
int networkDownCount = 0;
StreamSubscription<List<ConnectivityResult>>? subscription;
bool alertOkStatus = false;
List<Map<String,String>>? topEntryValue;
List<Map<String,String>>? topExitValue;
bool entryExitStatus = true;
