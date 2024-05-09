import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/profile_models.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;
// "User_Name":"somu",
// "Password":"123456"
Future<UserBaseModel?> loginUser({required String userName, required String password}) async{
  print('loginUrl = $loginUrl, userName = $userName, password = $password');
  http.Response response = await http.post(Uri.parse(loginUrl),body: json.encode({
    "Account_Id":"231012345",
    "User_Name":userName,
    "Password":password
  }),headers: {'Content-Type': 'application/json'});
  print('loginUser response = ${response.body}, statusCode = ${response.statusCode}');
  if(response.statusCode == 200 && response.body.isNotEmpty)
    {
      print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
      UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
      saveUserData(userBaseModel.data);
      return userBaseModel;
    }
  return null;
}

Future<RegisterModel?> registerUser({required RegisterModel registerModel}) async{
  print('registerUserUrl = $baseUrl$registerUrl');
  http.Response response = await http.post(Uri.parse('$baseUrl$registerUrl'),body: json.encode(registerModel.toJson()),
      headers: {'Content-Type': 'application/json'});
  print('registerUserUrl response = ${response.body}, statusCode = ${response.statusCode}');
  if((response.statusCode >= 200 && response.statusCode < 300) && response.body.isNotEmpty)
  {
    return RegisterModel.fromJson(json.decode(response.body));
    // print('UserBaseModel.fromJson(json.decode(response.body)) = ${UserBaseModel.fromJson(json.decode(response.body))}');
    // UserBaseModel userBaseModel = UserBaseModel.fromJson(json.decode(response.body));
    // saveUserData(userBaseModel.data);
    // return userBaseModel;
  }
  return null;
}

saveUserData(UserModel? data) async {
  kAuthTokenVal = data?.authToken ?? '';
  kOrganizationCodeVal = data?.organizationCode ?? '';
  kEmployeeCodeVal = data?.employeeCode ?? '';
  kIsCaptainVal = data?.isCaptain ?? '';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(kOrganizationCode, data?.organizationCode ?? '');
  prefs.setString(kEmployeeCode, data?.employeeCode ?? '');
  prefs.setString(kIsCaptain, data?.isCaptain ?? '');
  prefs.setString(kAuthToken, data?.authToken ?? '');
}
