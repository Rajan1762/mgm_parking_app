class LoginResponseModel {
  bool? status;
  String? message;
  String? transid;
  String? shiftid;
  bool? shiftOpen;
  String? fbcode;
  String? error;

  LoginResponseModel(
      {this.status,
        this.message,
        this.transid,
        this.shiftid,
        this.shiftOpen,
        this.fbcode,
        this.error});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    transid = json['transid'];
    shiftid = json['shiftid'];
    shiftOpen = json['shiftOpen'];
    fbcode = json['fbcode'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['Message'] = this.message;
    data['transid'] = this.transid;
    data['shiftid'] = this.shiftid;
    data['shiftOpen'] = this.shiftOpen;
    data['fbcode'] = this.fbcode;
    data['error'] = this.error;
    return data;
  }
}