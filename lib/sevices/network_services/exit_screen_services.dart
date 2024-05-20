import 'dart:convert';
import 'package:mgm_parking_app/model/entry_model.dart';
import 'package:mgm_parking_app/model/errorResponseModel.dart';
import 'package:mgm_parking_app/model/exit_screen_model/exit_screen_models.dart';
import 'package:mgm_parking_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../../model/exit_screen_model/exit_screen_response_model.dart';

Future<ExitResponseModel?> saveExitVehicle({required ExitSaveModel exitSaveModel}) async{
  print('saveExitVehicle = $baseUrl$exitSaveVehicleUrl');
  print('json.encode(exitSaveModel.toJson() = ${json.encode(exitSaveModel.toJson())}');
  http.Response response = await http.post(Uri.parse('$baseUrl$exitSaveVehicleUrl'),body: json.encode(exitSaveModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print('saveExitVehicle response = ${response.body}, statusCode = ${response.statusCode}');
  if((response.statusCode >= 200 && response.statusCode < 300) && response.body.isNotEmpty)
  {
    return ExitResponseModel.fromJson(json.decode(response.body));
    // print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
    // UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
    // saveUserData(userBaseModel.data);
    // return userBaseModel;
  }
  return null;
}

Future<ErrorResponseModel?> getExitVehicleDetails({required String scanID}) async
{
  print('getExitVehicleDetails URL = $exitVehicleDetailsURL$scanID');
  http.Response response = await http.get(Uri.parse('$exitVehicleDetailsURL$scanID'));
  print('response statusCode = ${response.statusCode},\nbody = ${response.body}');
  if(response.statusCode >=200 && response.statusCode < 300)
    {
      if(response.body == '"No Data Found!"')
        {
          return ErrorResponseModel(obj: null, errorMessage: 'No Data Found!');
        }
      List body = json.decode(response.body);
      return ErrorResponseModel(obj: EntryModel.fromJson(body[0]), errorMessage: null);
    }
  return null;
}
