import '../model/dummy_model.dart';
// const String baseUrl = "https://lak.brositecom.com/";
const String dealsUrl = "/api/GetProdcut?branch=B00001";
const String floorTableUrl = 'get_Tables?branch_code=';


const String baseUrl = "https://mgm.brosonetech.com";
const String registerUrl = '/api/Entries';
const String reportUrl = '/api/Entries/getReports?fdate=';
const String kDefaultNetworkImage = 'https://en.wikipedia.org/wiki/Food#/media/File:Good_Food_Display_-_NCI_Visuals_Online.jpg';
const String kDefaultAssetImage = "assets/images/loading_image.jpg";
const String tableAssetImage = 'assets/images/table.png';
const String loginUrl = 'https://botapi.brosonetech.com/api/employees/login';
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

List<DealsCardModel>? dealsCardList;
const String rupeeSymbol = '\u{20B9}';
