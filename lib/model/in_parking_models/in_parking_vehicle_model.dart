class InParkingVehicleModel {
  int? transid;
  String? uniqueId;
  String? vehicleType;
  String? vehicleNo;
  String? date;
  String? intime;
  String? barcode;
  String? createdate;
  String? status;
  String? booth;
  String? userid;
  double? amount;
  String? design;
  String? userName;

  InParkingVehicleModel(
      {this.transid,
        this.uniqueId,
        this.vehicleType,
        this.vehicleNo,
        this.date,
        this.intime,
        this.barcode,
        this.createdate,
        this.status,
        this.booth,
        this.userid,
        this.amount,
        this.design,
        this.userName});

  InParkingVehicleModel.fromJson(Map<String, dynamic> json) {
    transid = json['transid'];
    uniqueId = json['uniqueId'];
    vehicleType = json['vehicleType'];
    vehicleNo = json['vehicleNo'];
    date = json['date'];
    intime = json['intime'];
    barcode = json['barcode'];
    createdate = json['createdate'];
    status = json['status'];
    booth = json['booth'];
    userid = json['userid'];
    amount = json['amount'];
    design = json['design'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transid'] = this.transid;
    data['uniqueId'] = this.uniqueId;
    data['vehicleType'] = this.vehicleType;
    data['vehicleNo'] = this.vehicleNo;
    data['date'] = this.date;
    data['intime'] = this.intime;
    data['barcode'] = this.barcode;
    data['createdate'] = this.createdate;
    data['status'] = this.status;
    data['booth'] = this.booth;
    data['userid'] = this.userid;
    data['amount'] = this.amount;
    data['design'] = this.design;
    data['userName'] = this.userName;
    return data;
  }
}
