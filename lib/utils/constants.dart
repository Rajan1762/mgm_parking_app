import '../model/dummy_model.dart';
// const String baseUrl = "https://lak.brositecom.com/";
// const String dealsUrl = "/api/GetProdcut?branch=B00001";
// const String floorTableUrl = 'get_Tables?branch_code=';

// const String baseUrl = "https://demomgmapi.brositecom.com";
const String baseUrl = "https://mgmapi.brosonetech.com";
// const String baseUrl = "https://mgm.brosonetech.com";
const String loginUserListURL = '$baseUrl/api/Login/list';
const String exitVehicleDetailsURL = '$baseUrl/api/Entries/getDatabyID?id=';
// const String saveVehicleUrl = '/api/Entries';
const String saveVehicleUrl = '/api/Entries/api/postEntry';
const String exitSaveVehicleUrl = '/api/OutCheck';
const String reportUrl = '/api/Entries/getReports?fdate=';
const String kDefaultNetworkImage = 'https://en.wikipedia.org/wiki/Food#/media/File:Good_Food_Display_-_NCI_Visuals_Online.jpg';
const String kDefaultAssetImage = "assets/images/loading_image.jpg";
const String tableAssetImage = 'assets/images/table.png';
const String loginUrl = '$baseUrl/api/Login';
const String shiftOpenUrl = '$baseUrl/api/Login/openshift/';
const String logOutURL = '$baseUrl/api/Login/closeshift/';
const String loginStatusCheckURL = '$baseUrl/api/Login/CheckLogin/';

const String top10EntryScreenEntriesURL = '$baseUrl/api/Entries/gettop10Entry';
const String top10ExitScreenEntriesURL = '$baseUrl/api/OutCheck/gettop10Exit';

const String kOfflineImage = "assets/images/offline_image.jpg";
const String kOrganizationCode = 'Organization_Code';
const String kEmployeeCode = 'Employee_Code';
const String kIsCaptain = 'Is_Captain';
const String kAuthToken = 'AuthToken';
String kOrganizationCodeVal = '';
String kEmployeeCodeVal = '';
String kIsCaptainVal = '';
String kAuthTokenVal = '';
const String kIdString = 'UHF ID';
String kIdValue = '';
const String kOwnerMobileString = 'Owner MobileNumber';
String kOwnerMobileValue = '';
const String kOwnerNameString = 'Owner Name';
String kOwnerNameValue = '';
const String kDriverMobileString = 'Driver Mobile Number';
String kDriverMobileValue = '';
const String kDriverNameString = 'Driver Name';
String kDriverNameValue = '';
const String shiftIdString = 'shiftId';
String shiftIDValue = '';
const String userIdString = 'userId';
String userIDValue = '';
const String openingAmountString = 'openingAmount';
String openingAmountValue = '';
const String cashString = 'Cash';
const String gPayCardString = 'GPay/Card';
const String mgmPaymentModeString = 'MGM';
const String inPatientString = 'InPatient';
const String creditString = 'Credit';
// const String upiString = 'Upi';
const String logInTimeString = 'logInTime';
String logInTimeVal = '';
const String vehicleTypeCar = 'CAR';
const String vehicleTypeBike = 'BIKE';
const String vehicleTypeDialysis = 'DIALYSIS';

// List<String> vehicleTypeList = ['Car','Bike','Staff Vehicle','Dialysis','IN Patient'];

class VehicleValueModel{
  final int baseAmount;
  final int extraAmount;
  final int perDayAmount;
  VehicleValueModel({required this.baseAmount,required this.extraAmount,required this.perDayAmount});
}

VehicleValueModel setVehicleValues({required String vehicleType}){
  return VehicleValueModel(
      baseAmount: vehicleType == vehicleTypeCar ? 50 : vehicleType == vehicleTypeBike ? 30 : vehicleType == vehicleTypeDialysis ? 20 : 0,
      extraAmount: vehicleType == vehicleTypeCar ? 25 : vehicleType == vehicleTypeBike ? 15 : vehicleType == vehicleTypeDialysis ? 10 : 0,
      perDayAmount: vehicleType == vehicleTypeCar ? 400 : vehicleType == vehicleTypeBike ? 250 : vehicleType == vehicleTypeDialysis ? 250 : 0);
}

// VehicleValueModel setVehicleValues({required String vehicleType}){
//   return VehicleValueModel(
//       baseAmount: vehicleType == '1' ? 50 : vehicleType == '2' ? 30 : (vehicleType == '4' || vehicleType == '5') ? 20 : 0,
//       extraAmount: vehicleType == '1' ? 25 : vehicleType == '2' ? 15 : (vehicleType == '4' || vehicleType == '5') ? 10 : 0,
//       perDayAmount: vehicleType == '1' ? 400 : vehicleType == '2' ? 250 : (vehicleType == '4' || vehicleType == '5') ? 250 : 0);
// }

List<DealsCardModel>? dealsCardList;
const String rupeeSymbol = '\u{20B9}';

// if (noOfDays == 0 && remainingHours == 0) {
//   if (minutes < 15 || (minutes == 15 && seconds == 0)) {
//     amount = 0;
//     return;
//   }
// }
// if(noOfDays == 0)
//   {
//     if(remainingHours<2 || (remainingHours==2 && seconds ==0))
//       {
//         amount = vm.baseAmount;
//       }else{
//       amount = vm.baseAmount + ((remainingHours-2) * vm.extraAmount) + (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
//     }
//   }else{
//   amount = (noOfDays * vm.perDayAmount) + (remainingHours * vm.extraAmount) + (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
// }
