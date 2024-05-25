import 'dart:ffi';

class LogOutResponseModel {
  bool? status;
  List<Data>? data;
  String? message;
  String? error;

  LogOutResponseModel({this.status, this.data, this.message, this.error});

  LogOutResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['Message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String? cASH;
  double? aMOUNT;
  int? vEHICLECOUNT;

  Data({this.cASH, this.aMOUNT, this.vEHICLECOUNT});

  Data.fromJson(Map<String, dynamic> json) {
    cASH = json['CASH'];
    aMOUNT = json['AMOUNT'];
    vEHICLECOUNT = json['VEHICLE_COUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CASH'] = this.cASH;
    data['AMOUNT'] = this.aMOUNT;
    data['VEHICLE_COUNT'] = this.vEHICLECOUNT;
    return data;
  }
}