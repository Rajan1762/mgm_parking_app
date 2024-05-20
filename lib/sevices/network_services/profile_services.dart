import 'dart:convert';
import 'package:mgm_parking_app/model/profile_models/login_model.dart';
import 'package:mgm_parking_app/model/profile_models/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/entry_model.dart';
import '../../model/profile_models/login_list_model.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;

// "User_Name":"some",
// "Password":"123456"

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
  prefs.setString(shiftIdString, loginResponseModel.shiftid ?? '');
  shiftIDValue = loginResponseModel.shiftid ?? '';
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

Future<EntryModel?> saveEntryVehicle(
    {required EntryModel registerModel}) async {
  print('saveVehicleUrl = $baseUrl$saveVehicleUrl');
  print(
      'json.encode(registerModel.toJson()) = ${json.encode(registerModel.toJson())}');
  http.Response response = await http.post(Uri.parse('$baseUrl$saveVehicleUrl'),
      body: json.encode(registerModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print('registerUserUrl response.body = ${response.body}, statusCode = ${response.statusCode}');
  if ((response.statusCode >= 200 && response.statusCode < 300) &&
      response.body.isNotEmpty) {
    return EntryModel.fromJson(json.decode(response.body));
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
