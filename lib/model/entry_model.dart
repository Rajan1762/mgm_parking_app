class EntryModel {
  // int? transid;
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

  EntryModel(
      {
        // this.transid,
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

  EntryModel.fromJson(Map<String, dynamic> json) {
    // transid = json['transid'];
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
    // data['transid'] = this.transid;
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

// class EntryModel {
//   String? id;
//   String? scanId;
//   String? ownerName;
//   String? ownerMobile;
//   String? location;
//   String? driverName;
//   String? driverMobile;
//   String? date;
//   String? time;
//   String? image_data;
//   String? vehicleno;
//   String? vehicletype;
//
//   EntryModel(
//       {this.id,
//         this.scanId,
//         this.ownerName,
//         this.ownerMobile,
//         this.location,
//         this.driverName,
//         this.driverMobile,
//         this.date,
//         this.time, this.image_data, this.vehicleno, this.vehicletype});
//
//   EntryModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     scanId = json['scan_id'];
//     ownerName = json['owner_name'];
//     ownerMobile = json['owner_mobile'];
//     location = json['location'];
//     driverName = json['driver_name'];
//     driverMobile = json['driver_mobile'];
//     date = json['date'];
//     time = json['time'];
//     image_data = json['image_data'];
//     vehicleno = json['vehicleno'];
//     vehicletype = json['vehicletype'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['scan_id'] = scanId;
//     data['owner_name'] = ownerName;
//     data['owner_mobile'] = ownerMobile;
//     data['location'] = location;
//     data['driver_name'] = driverName;
//     data['driver_mobile'] = driverMobile;
//     data['date'] = date;
//     data['time'] = time;
//     data['image_data'] = image_data;
//     data['vehicleno'] = vehicleno;
//     data['vehicletype'] = vehicletype;
//     return data;
//   }
// }