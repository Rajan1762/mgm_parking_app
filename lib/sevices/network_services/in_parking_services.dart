import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mgm_parking_app/utils/constants.dart';

import '../../model/in_parking_models/in_parking_vehicle_model.dart';

Future<List<InParkingVehicleModel>> getInParkingVehicleList({required String fromDate,required String toDate}) async
{
  print('inParkingVehicleURL = $inParkingVehicleURL$fromDate/$toDate');
  http.Response response = await http.get(Uri.parse('$inParkingVehicleURL$fromDate/$toDate'));
  print('response.statusCode = ${response.statusCode}\nbody = ${response.body}');
  if(response.statusCode>=200&&response.statusCode<300)
    {
      List pList = json.decode(response.body);
      List<InParkingVehicleModel> parkingVehicleList = [];
      for (var element in pList) {
        parkingVehicleList.add(InParkingVehicleModel.fromJson(element));
      }
      return parkingVehicleList;
    }
  throw Exception('Network Error. status code : ${response.statusCode}');
}
