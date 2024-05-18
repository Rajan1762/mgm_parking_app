class LoginListModel {
  String? transid;
  String? username;
  String? pwd;
  String? createdate;
  String? status;
  String? provotion;
  String? prefix;

  LoginListModel(
      {this.transid,
        this.username,
        this.pwd,
        this.createdate,
        this.status,
        this.provotion,
        this.prefix});

  LoginListModel.fromJson(Map<String, dynamic> json) {
    transid = json['transid'];
    username = json['username'];
    pwd = json['pwd'];
    createdate = json['createdate'];
    status = json['status'];
    provotion = json['provotion'];
    prefix = json['prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transid'] = this.transid;
    data['username'] = this.username;
    data['pwd'] = this.pwd;
    data['createdate'] = this.createdate;
    data['status'] = this.status;
    data['provotion'] = this.provotion;
    data['prefix'] = this.prefix;
    return data;
  }
}