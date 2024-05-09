class ReportModel {
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

  ReportModel(
      {this.id,
        this.scanId,
        this.ownerName,
        this.ownerMobile,
        this.location,
        this.driverName,
        this.driverMobile,
        this.date,
        this.time, this.image_data});

  ReportModel.fromJson(Map<String, dynamic> json) {
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