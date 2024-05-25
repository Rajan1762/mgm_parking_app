import 'dart:convert';
import 'package:mgm_parking_app/model/profile_models/login_response_model.dart';
import 'package:mgm_parking_app/model/profile_models/logout_model.dart';
import 'package:mgm_parking_app/model/profile_models/logout_response_model.dart';
import 'package:mgm_parking_app/model/report_model.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

Future<LogOutResponseModel?> logOutUser({required LogOutModel logoutModel}) async{
  print('logOutUser = $logOutURL${logoutModel.shiftname}');
  print('json.encode(logoutModel.toJson() = ${json.encode(logoutModel.toJson())}');
  http.Response response = await http.post(Uri.parse('$logOutURL${logoutModel.shiftname}'),body: json.encode(logoutModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print('logOutUser response = ${response.body}, statusCode = ${response.statusCode}');
  if((response.statusCode >= 200 && response.statusCode < 300) && response.body.isNotEmpty)
  {
    return LogOutResponseModel.fromJson(json.decode(response.body));
  }
  return null;
}

Future<List<ReportModel>?> getReportData({required String fromDate,required String toDate}) async{
  print('getReportData = $baseUrl$reportUrl$fromDate&tdate=$toDate');
  http.Response response = await http.get(Uri.parse('$baseUrl$reportUrl$fromDate&tdate=$toDate'));
  print('getReportData response = ${response.body},\nstatusCode = ${response.statusCode}');
  if((response.statusCode >= 200 && response.statusCode < 300) && response.body.isNotEmpty)
  {
    if(response.body=='"No Data Found!"')
      {
        return null;
      }
    List body = json.decode(response.body);
    List<ReportModel> reportList = [];
    for (var element in body) {
      reportList.add(ReportModel.fromJson(element));
    }
    return reportList;
  }
  return null;
}

