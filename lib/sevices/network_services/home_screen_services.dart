import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mgm_parking_app/model/report_model.dart';
import 'package:provider/provider.dart';
import '../../model/floor_table_model.dart';
import '../../utils/common_values.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;
import '../provider_services/floorTableProviderService.dart';

// Future<bool> getFloorTableData({required BuildContext context}) async{
//   print('kAuthTokenVal = $kAuthTokenVal');
//   print("getFloorTableData url = $baseUrl$floorTableUrl");
//   var response = await http.get(Uri.parse("$baseUrl$floorTableUrl"),headers: {'OID': kOrganizationCodeVal,'EID': kEmployeeCodeVal,'Authorization': 'Bearer $kAuthTokenVal'});
//   print("getFloorTableData status code = ${response.statusCode}\nbody = ${response.body}");
//   if(response.statusCode == 200 && response.body!="")
//   {
//     List jsonBody = json.decode(response.body);
//     List<FloorTableModel> floorTableList = jsonBody.map((element) => FloorTableModel.fromJson(element)).toList();
//     final List<String?> floorNameList = floorTableList.map((element) => element.floorName).toSet().toList();
//     for (var floorName in floorNameList) {
//       var floorList = floorTableList.where((element) => element.floorName == floorName).toList();
//       listOfFloorTableListVal.add(floorList);
//     }
//     if(context.mounted)
//     {
//       FloorTableProviderService provider = Provider.of<FloorTableProviderService>(context,listen: false);
//       provider.listOfFloorTableList = listOfFloorTableListVal;
//     }
//     return true;
//   }
//   return false;
// }

//20240430&tdate=20240430

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
    // print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
    // UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
    // saveUserData(userBaseModel.data);
    // return userBaseModel;
  }
  return null;
}

//TODO Old server database values
// Future<bool> getFloorTableData({required BuildContext context, branchCode = 'B0001',companyCode = 'C0001'}) async{
//   print("getFloorTableData url = $baseUrl$floorTableUrl$branchCode&company_code=$companyCode");
//   var response = await http.get(Uri.parse("$baseUrl$floorTableUrl$branchCode&company_code=$companyCode"));
//   print("getFloorTableData status code = ${response.statusCode}\nbody = ${response.body}");
//   if(response.statusCode == 200 && response.body!="")
//   {
//     List jsonBody = json.decode(response.body);
//     List<FlorTableModel> floorTableList = jsonBody.map((element) => FlorTableModel.fromJson(element)).toList();
//     final List<String> floorNameList = floorTableList.map((element) => element.floorName).toSet().toList();
//     for (var floorName in floorNameList) {
//       var floorList = floorTableList.where((element) => element.floorName == floorName).toList();
//       listOfFloorTableListVal.add(floorList);
//     }
//     if(context.mounted)
//       {
//         FloorTableProviderService provider = Provider.of<FloorTableProviderService>(context,listen: false);
//         provider.listOfFloorTableList = listOfFloorTableListVal;
//       }
//     return true;
//   }
//   return false;
// }
