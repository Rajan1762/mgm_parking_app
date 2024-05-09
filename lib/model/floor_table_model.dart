class FloorTableBaseModel {
  bool? status;
  String? statusCode;
  List<FloorTableModel>? data;
  String? message;
  Error? error;
  String? log;

  FloorTableBaseModel(
      {this.status,
        this.statusCode,
        this.data,
        this.message,
        this.error,
        this.log});

  FloorTableBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <FloorTableModel>[];
      json['data'].forEach((v) {
        data!.add(FloorTableModel.fromJson(v));
      });
    }
    message = json['message'];
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    log = json['log'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    data['log'] = log;
    return data;
  }
}

class FloorTableModel {
  String? branchCode;
  String? floorName;
  String? tableName;
  String? chairs;
  String? availableStatus;
  String? enableOnlineOrder;
  String? enableMultipleOrder;
  String? enableChairSelection;
  String? orders;
  String? saleOrderList;
  String? guests;

  FloorTableModel(
      {this.branchCode,
        this.floorName,
        this.tableName,
        this.chairs,
        this.availableStatus,
        this.enableOnlineOrder,
        this.enableMultipleOrder,
        this.enableChairSelection,
        this.orders,
        this.saleOrderList,
        this.guests});

  FloorTableModel.fromJson(Map<String, dynamic> json) {
    branchCode = json['Branch_Code'];
    floorName = json['Floor_Name'];
    tableName = json['Table_Name'];
    chairs = json['Chairs'];
    availableStatus = json['Available_Status'];
    enableOnlineOrder = json['Enable_Online_Order'];
    enableMultipleOrder = json['Enable_Multiple_Order'];
    enableChairSelection = json['Enable_Chair_Selection'];
    orders = json['Orders'];
    saleOrderList = json['Sale_Order_List'];
    guests = json['Guests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Branch_Code'] = branchCode;
    data['Floor_Name'] = floorName;
    data['Table_Name'] = tableName;
    data['Chairs'] = chairs;
    data['Available_Status'] = availableStatus;
    data['Enable_Online_Order'] = enableOnlineOrder;
    data['Enable_Multiple_Order'] = enableMultipleOrder;
    data['Enable_Chair_Selection'] = enableChairSelection;
    data['Orders'] = orders;
    data['Sale_Order_List'] = saleOrderList;
    data['Guests'] = guests;
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

// class FlorTableModel {
//   final String floorName;
//   final String tableName;
//   final String noOfChars;
//   final String? isAvailable;
//
//   FlorTableModel._({required this.tableName, required this.noOfChars, required this.floorName, this.isAvailable});
//
//   factory FlorTableModel.fromJson(Map<String,dynamic> json)=>FlorTableModel._(
//       floorName: json['floor_Name'],
//       tableName: json['table_Name'],
//       noOfChars: json['cHairs'],
//     isAvailable: json['is_Available']
//   );
// }
