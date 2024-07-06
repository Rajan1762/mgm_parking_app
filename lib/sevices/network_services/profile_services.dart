import 'dart:convert';
import 'package:mgm_parking_app/model/exit_screen_model/exit_screen_response_model.dart';
import 'package:mgm_parking_app/model/profile_models/login_model.dart';
import 'package:mgm_parking_app/model/profile_models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/entry_model.dart';
import '../../model/profile_models/login_list_model.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

// "User_Name":"some",
// "Password":"123456"

Future<bool?> checkLoginStatus() async {
  print('loginStatusCheckURL = $loginStatusCheckURL$shiftIDValue');
  http.Response response = await http.get(Uri.parse('$loginStatusCheckURL$shiftIDValue'));
  print('checkLoginStatus response.body = ${response.body}, statusCode = ${response.statusCode}');
  if ((response.statusCode >= 200 && response.statusCode < 300) &&
      response.body.isNotEmpty) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    List<Map<String, dynamic>>? val = jsonData.map((item) => Map<String, dynamic>.from(item)).toList();

    if(val[0]['sstatus'] == 'OPEN')
      {
        return true;
      }else{
      return false;
    }

    // return ExitResponseModel.fromJson(json.decode(response.body));
    // print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
    // UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
    // saveUserData(userBaseModel.data);
    // return userBaseModel;
  }
  return null;
}

Future<bool> shiftUser({required String openingAmount}) async {
  print('loginUrl = $shiftOpenUrl$userIDValue');
  print('json.encode({openingamount : openingAmount}) = ${json.encode({'openingamount' : openingAmount})}');
  http.Response response = await http.post(Uri.parse('$shiftOpenUrl$userIDValue'),
      body: json.encode({
        'openingamount' : openingAmount
      }),
      headers: {'Content-Type': 'application/json'});
  print(
      'shiftUser response = ${response.body}, statusCode = ${response.statusCode}');
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Map<String, dynamic> json = jsonDecode(response.body);
    prefs.setString(shiftIdString, '${jsonDecode(response.body)}');
    shiftIDValue = '${jsonDecode(response.body)}';
    prefs.setString(openingAmountString, openingAmount);
    openingAmountValue = openingAmount;
   return true;
  }
  return false;
}

Future<LoginResponseModel?> loginUser({required LoginModel loginModel}) async {
  print('loginUrl = $loginUrl\n json.encode(loginModel.toJson() = ${json.encode(loginModel.toJson())}');
  http.Response response = await http.post(Uri.parse(loginUrl),
      body: json.encode(loginModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print(
      'loginUser response = ${response.body}, statusCode = ${response.statusCode}');
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(json.decode(response.body));
        saveDate(loginResponseModel);
    return loginResponseModel;
  }
  return null;
}

saveDate(LoginResponseModel loginResponseModel) async
{
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(loginResponseModel.shiftOpen ?? false) {
    prefs.setString(shiftIdString, loginResponseModel.shiftid ?? '');
    shiftIDValue = loginResponseModel.shiftid ?? '';
  }
  prefs.setString(userIdString, loginResponseModel.transid ?? '');
  userIDValue = loginResponseModel.transid ?? '';
}

Future<List<LoginListModel>?> loginUserList() async {
  print('loginUserListURL = $loginUserListURL');
  http.Response response = await http.get(Uri.parse(loginUserListURL));
  print(
      'loginUserList response = ${response.body}, statusCode = ${response.statusCode}');
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    List body = json.decode(response.body);
    List<LoginListModel> loginUserList = [];
    for (var element in body) {
      loginUserList.add(LoginListModel.fromJson(element));
    }
    return loginUserList;
  }
  return null;
}

// Future<UserBaseModel?> loginUser({required String userName, required String password}) async{
//   print('loginUrl = $loginUrl, userName = $userName, password = $password');
//   http.Response response = await http.post(Uri.parse(loginUrl),body: json.encode({
//     "Account_Id":"231012345",
//     "User_Name":userName,
//     "Password":password
//   }),headers: {'Content-Type': 'application/json'});
//   print('loginUser response = ${response.body}, statusCode = ${response.statusCode}');
//   if(response.statusCode == 200 && response.body.isNotEmpty)
//     {
//       print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
//       UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
//       saveUserData(userBaseModel.data);
//       return userBaseModel;
//     }
//   return null;
// }

Future<ExitResponseModel?> saveEntryVehicle(
    {required EntryModel registerModel}) async {
  print('saveVehicleUrl = $baseUrl$saveVehicleUrl');
  print('json.encode(registerModel.toJson()) = ${json.encode(registerModel.toJson())}');
  http.Response response = await http.post(Uri.parse('$baseUrl$saveVehicleUrl'),
      body: json.encode(registerModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print('registerUserUrl response.body = ${response.body}, statusCode = ${response.statusCode}');
  if ((response.statusCode >= 200 && response.statusCode < 300) &&
      response.body.isNotEmpty) {
    return ExitResponseModel.fromJson(json.decode(response.body));
    // print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
    // UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
    // saveUserData(userBaseModel.data);
    // return userBaseModel;
  }
  return null;
}
//
// saveUserData(UserModel? data) async {
//   kAuthTokenVal = data?.authToken ?? '';
//   kOrganizationCodeVal = data?.organizationCode ?? '';
//   kEmployeeCodeVal = data?.employeeCode ?? '';
//   kIsCaptainVal = data?.isCaptain ?? '';
//
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString(kOrganizationCode, data?.organizationCode ?? '');
//   prefs.setString(kEmployeeCode, data?.employeeCode ?? '');
//   prefs.setString(kIsCaptain, data?.isCaptain ?? '');
//   prefs.setString(kAuthToken, data?.authToken ?? '');
// }
