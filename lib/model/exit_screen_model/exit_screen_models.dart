class ExitSaveModel {
  String? uniqueId;
  String? vehicleType;
  String? vehicleNo;
  String? date;
  String? outime;
  String? barcode;
  String? duration;
  String? intime;
  String? payment;
  String? amount;
  String? createdate;
  String? status;
  String? booth;
  String? userid;
  String? paymode;
  String? remarks;
  String? shiftid;
  String? userName;
  String? refNo;
  String? printDate;

  ExitSaveModel(
      {this.uniqueId,
        this.vehicleType,
        this.vehicleNo,
        this.date,
        this.outime,
        this.barcode,
        this.duration,
        this.intime,
        this.payment,
        this.amount,
        this.createdate,
        this.status,
        this.booth,
        this.userid,
        this.paymode,
        this.remarks,
        this.shiftid,
        this.userName,
        this.refNo,
        this.printDate});

  ExitSaveModel.fromJson(Map<String, dynamic> json) {
    uniqueId = json['uniqueId'];
    vehicleType = json['vehicleType'];
    vehicleNo = json['vehicleNo'];
    date = json['date'];
    outime = json['outime'];
    barcode = json['barcode'];
    duration = json['duration'];
    intime = json['intime'];
    payment = json['payment'];
    amount = json['amount'];
    createdate = json['createdate'];
    status = json['status'];
    booth = json['booth'];
    userid = json['userid'];
    paymode = json['paymode'];
    remarks = json['remarks'];
    shiftid = json['shiftid'];
    userName = json['userName'];
    refNo = json['refNo'];
    printDate = json['printDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniqueId'] = this.uniqueId;
    data['vehicleType'] = this.vehicleType;
    data['vehicleNo'] = this.vehicleNo;
    data['date'] = this.date;
    data['outime'] = this.outime;
    data['barcode'] = this.barcode;
    data['duration'] = this.duration;
    data['intime'] = this.intime;
    data['payment'] = this.payment;
    data['amount'] = this.amount;
    data['createdate'] = this.createdate;
    data['status'] = this.status;
    data['booth'] = this.booth;
    data['userid'] = this.userid;
    data['paymode'] = this.paymode;
    data['remarks'] = this.remarks;
    data['shiftid'] = this.shiftid;
    data['userName'] = this.userName;
    data['refNo'] = this.refNo;
    data['printDate'] = this.printDate;
    return data;
  }
}
