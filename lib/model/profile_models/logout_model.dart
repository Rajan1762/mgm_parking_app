class LogOutModel {
  // String? username;
  // String? pwd;
  // String? boothId;
  String? shiftname;
  // String? sdate;
  // String? sstatus;
  // String? openingamount;
  // String? csdate;
  // String? closingamount;
  // String? fuser;
  // bool? shiftStatus;

  LogOutModel(
      {
        // this.username,
        // this.pwd,
        // this.boothId,
        this.shiftname,
        // this.sdate,
        // this.sstatus,
        // this.openingamount,
        // this.csdate,
        // this.closingamount,
        // this.fuser,
        // this.shiftStatus
      });

  LogOutModel.fromJson(Map<String, dynamic> json) {
    // username = json['username'];
    // pwd = json['pwd'];
    // boothId = json['boothId'];
    shiftname = json['shiftname'];
    // sdate = json['sdate'];
    // sstatus = json['sstatus'];
    // openingamount = json['openingamount'];
    // csdate = json['csdate'];
    // closingamount = json['closingamount'];
    // fuser = json['fuser'];
    // shiftStatus = json['shiftStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['username'] = this.username;
    // data['pwd'] = this.pwd;
    // data['boothId'] = this.boothId;
    data['shiftname'] = this.shiftname;
    // data['sdate'] = this.sdate;
    // data['sstatus'] = this.sstatus;
    // data['openingamount'] = this.openingamount;
    // data['csdate'] = this.csdate;
    // data['closingamount'] = this.closingamount;
    // data['fuser'] = this.fuser;
    // data['shiftStatus'] = this.shiftStatus;
    return data;
  }
}