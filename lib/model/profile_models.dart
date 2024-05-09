class RegisterModel {
  String? id;
  String? scanId;
  String? ownerName;
  String? ownerMobile;
  String? location;
  String? driverName;
  String? driverMobile;
  String? date;
  String? time;
  String? image_data;

  RegisterModel(
      {this.id,
        this.scanId,
        this.ownerName,
        this.ownerMobile,
        this.location,
        this.driverName,
        this.driverMobile,
        this.date,
        this.time, this.image_data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scanId = json['scan_id'];
    ownerName = json['owner_name'];
    ownerMobile = json['owner_mobile'];
    location = json['location'];
    driverName = json['driver_name'];
    driverMobile = json['driver_mobile'];
    date = json['date'];
    time = json['time'];
    image_data = json['image_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['scan_id'] = scanId;
    data['owner_name'] = ownerName;
    data['owner_mobile'] = ownerMobile;
    data['location'] = location;
    data['driver_name'] = driverName;
    data['driver_mobile'] = driverMobile;
    data['date'] = date;
    data['time'] = time;
    data['image_data'] = image_data;
    return data;
  }
}

class UserBaseModel {
  bool? status;
  String? statusCode;
  UserModel? data;
  String? message;
  Error? error;
  String? log;

  UserBaseModel(
      {this.status,
        this.statusCode,
        this.data,
        this.message,
        this.error,
        this.log});

  UserBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    log = json['log'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    data['log'] = log;
    return data;
  }
}

class UserModel {
  String? status;
  String? message;
  String? organizationCode;
  String? organizationName;
  String? branchCode;
  String? branchName;
  String? employeeCode;
  String? employeeName;
  String? mobile;
  String? email;
  String? isCaptain;
  String? isActive;
  String? userName;
  String? softwareRightsGroup;
  String? employeeImage;
  String? authToken;
  String? apiVersion;

  UserModel(
      {this.status,
        this.message,
        this.organizationCode,
        this.organizationName,
        this.branchCode,
        this.branchName,
        this.employeeCode,
        this.employeeName,
        this.mobile,
        this.email,
        this.isCaptain,
        this.isActive,
        this.userName,
        this.softwareRightsGroup,
        this.employeeImage,
        this.authToken,
        this.apiVersion});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    organizationCode = json['Organization_Code'];
    organizationName = json['Organization_Name'];
    branchCode = json['Branch_Code'];
    branchName = json['Branch_Name'];
    employeeCode = json['Employee_Code'];
    employeeName = json['Employee_Name'];
    mobile = json['Mobile'];
    email = json['Email'];
    isCaptain = json['Is_Captain'];
    isActive = json['Is_Active'];
    userName = json['User_Name'];
    softwareRightsGroup = json['Software_Rights_Group'];
    employeeImage = json['Employee_Image'];
    authToken = json['AuthToken'];
    apiVersion = json['ApiVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['Organization_Code'] = organizationCode;
    data['Organization_Name'] = organizationName;
    data['Branch_Code'] = branchCode;
    data['Branch_Name'] = branchName;
    data['Employee_Code'] = employeeCode;
    data['Employee_Name'] = employeeName;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Is_Captain'] = isCaptain;
    data['Is_Active'] = isActive;
    data['User_Name'] = userName;
    data['Software_Rights_Group'] = softwareRightsGroup;
    data['Employee_Image'] = employeeImage;
    data['AuthToken'] = authToken;
    data['ApiVersion'] = apiVersion;
    return data;
  }
}

class Error {
  String? code;
  String? message;

  Error({this.code, this.message});

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
