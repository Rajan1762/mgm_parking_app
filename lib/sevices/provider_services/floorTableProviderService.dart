import 'package:flutter/material.dart';
import '../../model/floor_table_model.dart';
import '../../utils/common_values.dart';

enum FloorTableTypeEnum { availableTables, bookedTable }

class FloorTableProviderService extends ChangeNotifier{
  List<List<FloorTableModel>> _orderFloorTableList = [];
  FloorTableTypeEnum? _floorTableTypeEnum = FloorTableTypeEnum.availableTables;

  List<List<FloorTableModel>> get orderFloorTableList => _orderFloorTableList;

  FloorTableTypeEnum? get floorTableTypeEnum => _floorTableTypeEnum;

  set floorTableTypeEnum(FloorTableTypeEnum? value) {
    _floorTableTypeEnum = value;
    _orderFloorTableList = value == FloorTableTypeEnum.availableTables ? activeFloorTableVal : deActiveFloorTableVal;
    notifyListeners();
  }

  List<List<FloorTableModel>> get listOfFloorTableList => listOfFloorTableListVal;

  set listOfFloorTableList(List<List<FloorTableModel>> value) {
    // listOfFloorTableListVal = value;
    // activeFloorTableVal.clear();
    // deActiveFloorTableVal.clear();
    //
    // for (var element in value) {
    //   final activeSub = element.where((e) => e.isAvailable == 'A').toList();
    //   final deActiveSub = element.where((e) => e.isAvailable == 'D').toList();
    //   if (activeSub.isNotEmpty) activeFloorTableVal.add(activeSub);
    //   if (deActiveSub.isNotEmpty) deActiveFloorTableVal.add(deActiveSub);
    // }
    // _orderFloorTableList = activeFloorTableVal;
    notifyListeners();
  }

  // List<List<FlorTableModel>> get activeFloorTableList => activeFloorTableVal;
  //
  // set activeFloorTableList(List<List<FlorTableModel>> value) {
  //   activeFloorTableVal = value;
  // }
  //
  // List<List<FlorTableModel>> get deActiveFloorTableList =>
  //     deActiveFloorTableVal;
  //
  // set deActiveFloorTableList(List<List<FlorTableModel>> value) {
  //   deActiveFloorTableVal = value;
  // }
}
