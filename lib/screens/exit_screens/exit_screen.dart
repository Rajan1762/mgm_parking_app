import 'package:flutter/material.dart';
import 'package:mgm_parking_app/model/entry_model.dart';
import 'package:mgm_parking_app/model/errorResponseModel.dart';
import 'package:mgm_parking_app/model/exit_screen_model/exit_screen_models.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:uuid/uuid.dart';
import '../../model/exit_screen_model/exit_screen_response_model.dart';
import '../../sevices/network_services/exit_screen_services.dart';
import '../../sevices/network_services/profile_services.dart';
import '../../sevices/print_services/sunmi.dart';
import '../../utils/common_functions.dart';
import '../../utils/common_values.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/common_widget.dart';
import '../../utils/custom_widgets/loading_widgets.dart';
import '../../utils/custom_widgets/profile_screen_widget.dart';
import 'package:intl/intl.dart';

import '../enrty_screens/entry_screen.dart';
import '../profile_screens/login_screen.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({super.key});

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  final TextEditingController _idController = TextEditingController();
  final StringBuffer _idNumber = StringBuffer();
  final FocusNode _idFocusNode = FocusNode();
  bool _isLoading = false;
  EntryModel? entryModel;
  int amount = 0;
  String entryDateTime = '';
  String exitDateTime = '';
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int noOfDays = 0;
  int remainingHours = 0;
  bool textFieldVisibility = true;
  bool _touchStatus = false;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  ErrorResponseModel? errorResponseModel;
  bool _saveBtVisibility = false;
  bool _doublePrintStatus = false;
  bool _dialysisChoosed = false;
  Map<String, bool> paymentModeMap = {
    cashString: false,
    gPayCardString: false,
    mgmPaymentModeString: false,
    inPatientString: false
  };

  choosePaymentMode(
      {required String paymentMode, required BuildContext context}) async {
    checkLoginStatus().then((logStatus) async {
      if (logStatus != null) {
        if (logStatus) {
          if (entryModel == null) {
            showMessageAlertDialog(
                context: context, message: 'Failed. Invalid Vehicle Details');
            return;
          }
          paymentModeMap.forEach((key, value) {
            if (key == paymentMode) {
              paymentModeMap[key] = true;
            } else {
              paymentModeMap[key] = false;
            }
          });
          setState(() => _isLoading = true);
          ExitResponseModel? e;
          try {
            e = await _saveExitVehicleData();
          } catch (error) {
            print('Error Occurred = $error');
            if (context.mounted) {
              showErrorAlertDialog(context: context, message: error.toString());
            }
          }
          print('e.message = ${e?.message}');
          if (context.mounted) {
            if (e != null && e.message == 'Succesfully OutChecked!') {
              autoDeleteAlertDialog(
                  context: context, message: 'Saved Successfully!');
            } else {
              autoDeleteAlertDialog(
                  context: context, message: 'Failed to Save Data');
            }
          }
          _clearData();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false);
        }
      } else {
        showErrorAlertDialog(
            context: context, message: 'Something went wrong try again later');
      }
    });
  }

  printSunmiReceipt() {
    print('userIDValue = $userIDValue');
    List<ColumnMaker> cList = [];
    cList.add(alignColumn(
      text: 'UHF ID       : ${entryModel?.vehicleNo}',
    ));
    cList.add(alignColumn(text: 'Vehicle Type : ${entryModel?.vehicleType}'));
    cList.add(alignColumn(text: 'IN  : $entryDateTime'));
    cList.add(alignColumn(text: 'OUT : $exitDateTime'));
    cList.add(alignColumn(
        text:
            'Time Duration : $noOfDays : ${remainingHours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}'));
    cList.add(alignColumn(text: 'Fare Rs : $rupeeSymbol$amount /-'));
    cList.add(alignColumn(
        text:
            'Payment Mode : ${paymentModeMap.containsValue(true) ? paymentModeMap.entries.where((data) => data.value).map((data) => data.key).first : cashString}'));
    cList.add(alignColumn(
      text: '\n--------------------------------',
    ));
    cList.add(alignColumn(text: 'Print Date : $exitDateTime\n\n\n'));
    Sunmi printer = Sunmi();
    printer.printReceipt(cl: cList, userName: userIDValue);
  }

  ColumnMaker alignColumn({required String text, SunmiPrintAlign? align}) {
    return ColumnMaker(
      text: text,
      width: 10,
      align: align ?? SunmiPrintAlign.LEFT,
    );
  }

  Future<ExitResponseModel?> _saveExitVehicleData() async {
    print('shiftIDValue = $shiftIDValue');
    var dateTime = DateTime.now();
    String remarks = 'Other';
    String paymentMode = 'Other';
    if (paymentModeMap.containsValue(true)) {
      remarks = paymentModeMap.entries
          .where((data) => data.value)
          .map((data) => data.key)
          .first;
      paymentMode =
          (remarks == mgmPaymentModeString || remarks == inPatientString)
              ? creditString
              : remarks;
    }
    print(
        'paymentMode = $paymentMode, mgmPaymentModeString = $mgmPaymentModeString, inPatientString = $inPatientString');
    ExitResponseModel? exitResponseModel = await saveExitVehicle(
        exitSaveModel: ExitSaveModel(
      uniqueId: const Uuid().v4(),
      vehicleType:
          _dialysisChoosed ? vehicleTypeDialysis : entryModel?.vehicleType,
      vehicleNo: _idNumber.toString(),
      date: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime),
      //formatDate(dateTime),
      outime: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime),
      //formatTime(dateTime),
      barcode: '',
      duration:
          '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
      intime: DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.parse(entryModel!.date!)),
      payment: '$amount',
      amount: '$amount',
      createdate: entryModel?.date,
      status: 'D',
      booth: '2',
      userid: userIDValue,
      paymode: paymentMode,
      remarks: remarks,
      shiftid: shiftIDValue,
      userName: '',
      refNo: '',
      printDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime),
    ));
    if (exitResponseModel != null) {
      print('object');
      if ((remarks != mgmPaymentModeString) &&
          (remarks != inPatientString) &&
          (amount != 0)) {
        int printCount = (_doublePrintStatus) ? 2 : 1;
        for (int i = 0; i < printCount; i++) {
          await printSunmiReceipt();
        }
      }
    }
    return exitResponseModel;
  }

  Future<ErrorResponseModel?> _checkVehicleDetails() async {
    errorResponseModel =
        await getExitVehicleDetails(scanID: _idNumber.toString());
    if (errorResponseModel != null) {
      if (errorResponseModel?.errorMessage != null) {
        return errorResponseModel;
      }
      entryModel = errorResponseModel?.obj;
      calculateAmount(entryModel?.vehicleType);
      textFieldVisibility = false;
    }
    return errorResponseModel;
  }

  calculateAmount(String? vehicleType) {
    var dateTime = DateTime.now();
    DateTime entryDate = DateTime.parse("${entryModel?.date}");
    entryDateTime = "${formatDate(entryDate)} ${formatTime(entryDate)}";
    exitDateTime = "${formatDate(dateTime)} ${formatTime(dateTime)}";
    DateTime dateTime1 = DateTime.parse("${entryModel?.date}");
    DateTime dateTime2 = DateTime.parse(exitDateTime);
    Duration difference = dateTime2.difference(dateTime1);
    print("Time difference: ${difference.toString()}");
    hours = difference.inHours;
    minutes = difference.inMinutes % 60;
    seconds = difference.inSeconds % 60;
    VehicleValueModel vm = setVehicleValues(vehicleType: vehicleType ?? '');
    noOfDays = hours ~/ 24;
    remainingHours = (hours % 24).toInt();
    print(
        'Difference in noOfDays = $noOfDays, remainingHours = $remainingHours\nhours = $hours, minutes = $minutes, seconds = $seconds');
    print(
        'noOfDays * vm.perDayAmount = ${noOfDays * vm.perDayAmount}\nremainingHours * vm.extraAmount = ${(remainingHours * vm.extraAmount)}\n'
        '((minutes != 0) || (seconds != 0)) = ${((minutes != 0) || (seconds != 0))}');
    if (noOfDays == 0) {
      if (remainingHours == 0 &&
          (minutes < 15 || (minutes == 15 && seconds == 0))) {
        amount = 0;
        return;
      }
      amount = remainingHours < 2 || (remainingHours == 2 && seconds == 0)
          ? vm.baseAmount
          : vm.baseAmount +
              ((remainingHours - 2) * vm.extraAmount) +
              (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
    } else {
      amount = (noOfDays * vm.perDayAmount) +
          (remainingHours * vm.extraAmount) +
          (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
    }
    print('amount = $amount');
  }

  @override
  void dispose() {
    _idController.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    entryExitStatus = false;
    _idFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.grey.shade300,
        // height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: textFieldVisibility,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: ProfileScreenFieldWidget(
                                    fieldName: kIdString,
                                    focusNode: _idFocusNode,
                                    textEditingController: _idController,
                                    textInputType: TextInputType.number,
                                    validate: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   _idFocusNode.requestFocus();
                                      //   return "Required field cannot be empty";
                                      // }
                                      return null;
                                    },
                                    onChangValue: (v) {
                                      _idNumber.clear();
                                      _idNumber.write(v);
                                    },
                                    touchStatus: _touchStatus,
                                    onTap: () {
                                      if (!_touchStatus) {
                                        setState(() {
                                          print('_touchStatus = $_touchStatus');
                                          _touchStatus = true;
                                          _idFocusNode.unfocus();
                                        });
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          setState(() {
                                            _idFocusNode.requestFocus();
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                QrCodeScannerWidget(
                                  onTap: () {
                                    _qrBarCodeScannerDialogPlugin
                                        .getScannedQrBarCode(
                                            context: context,
                                            onCode: (code) {
                                              setState(() {
                                                _idController.text = code ?? '';
                                                _idNumber.clear();
                                                _idNumber.write(code);
                                              });
                                            });
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: textFieldVisibility ? 15 : 5),
                          Row(
                            children: [
                              SaveClearWidget(
                                  title: 'Check Details',
                                  onPressed: () async {
                                    if (_idNumber.toString().isNotEmpty) {
                                      setState(() => _isLoading = true);
                                      checkLoginStatus()
                                          .then((logStatus) async {
                                        if (logStatus != null) {
                                          if (logStatus) {
                                            await _checkVehicleDetails();
                                            _saveBtVisibility = amount == 0;
                                            setState(() => _isLoading = false);
                                            if (context.mounted) {
                                              if (errorResponseModel != null) {
                                                if (errorResponseModel
                                                        ?.errorMessage !=
                                                    null) {
                                                  showErrorAlertDialog(
                                                      context: context,
                                                      message:
                                                          errorResponseModel!
                                                              .errorMessage!);
                                                  // showToast(errorResponseModel!.errorMessage!);
                                                  // ScaffoldMessenger.of(context)
                                                  //     .showSnackBar(SnackBar(
                                                  //   content: Text(errorResponseModel!.errorMessage!),
                                                  // ));
                                                }
                                              }
                                            }
                                          } else {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                        } else {
                                          showErrorAlertDialog(
                                              context: context,
                                              message:
                                                  'Something went wrong try again later');
                                        }
                                      });
                                    } else {
                                      autoDeleteAlertDialog(
                                          context: context,
                                          message: 'Scan ID to Check');
                                    }
                                  }),
                              GestureDetector(
                                onTap: () {
                                  _clearData();
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: appThemeColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 6)
                                        ]),
                                    child: const Icon(Icons.delete_outline,
                                        color: Colors.white, size: 26)),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: appThemeColor),
                                boxShadow: [
                                  BoxShadow(color: appThemeColor, blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ExitFieldWidgets(
                                      title: 'UHF ID',
                                      value: entryModel?.vehicleNo != null
                                          ? '#${entryModel?.vehicleNo}'
                                          : ''),
                                  ExitFieldWidgets(
                                      title: 'Vehicle Type',
                                      value: entryModel != null
                                          ? _dialysisChoosed
                                              ? vehicleTypeDialysis
                                              : entryModel?.vehicleType ?? ''
                                          : ''),
                                  // value: entryModel != null ? vehicleTypeList[(int.parse(entryModel?.vehicleType??'1'))-1] : ''),
                                  // ExitFieldWidgets(
                                  //     title: 'Status',
                                  //     value: entryModel?.status ?? ''),
                                  ExitFieldWidgets(
                                      title: 'Entry Time',
                                      value: entryDateTime),
                                  ExitFieldWidgets(
                                      title: 'Exit Time', value: exitDateTime),
                                  ExitFieldWidgets(
                                      title: 'Amount',
                                      value: '$rupeeSymbol$amount'),
                                  const Text(
                                    'Time Difference',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  // const Row(
                                  //   children: [
                                  //     TimeDifferenceWidget(title: 'Hours', headerStatus: true,),
                                  //     TimeDifferenceWidget(title: 'Minutes', headerStatus: true,),
                                  //     TimeDifferenceWidget(title: 'Seconds', headerStatus: true,),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     TimeDifferenceWidget(title: '$hours'),
                                  //     TimeDifferenceWidget(title: '$minutes'),
                                  //     TimeDifferenceWidget(title: '$seconds'),
                                  //   ],
                                  // ),
                                  Text(
                                      '$noOfDays : ${remainingHours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          color: appThemeColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      TableColumn(
                                          title: 'Days', value: '$noOfDays'),
                                      TableColumn(
                                          title: 'Hours',
                                          value: remainingHours
                                              .toString()
                                              .padLeft(2, '0')),
                                      TableColumn(
                                          title: 'Minutes',
                                          value: minutes
                                              .toString()
                                              .padLeft(2, '0')),
                                      TableColumn(
                                          title: 'Seconds',
                                          value: seconds
                                              .toString()
                                              .padLeft(2, '0')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      DialysisNormalWidget(
                                        title: vehicleTypeDialysis,
                                        onTap: () {
                                          if (entryModel != null) {
                                            calculateAmount(
                                                vehicleTypeDialysis);
                                            setState(() {});
                                            _dialysisChoosed = true;
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      DialysisNormalWidget(
                                        title: 'Normal',
                                        onTap: () {
                                          if (entryModel != null) {
                                            calculateAmount(
                                                entryModel?.vehicleType);
                                            setState(() {});
                                            _dialysisChoosed = false;
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: Checkbox(
                                          activeColor: appThemeColor,
                                          value: _doublePrintStatus,
                                          onChanged: (s) {
                                            setState(() => _doublePrintStatus =
                                                s ?? false);
                                          }),
                                    ),
                                    GestureDetector(
                                        onTap: () => setState(() =>
                                            _doublePrintStatus =
                                                !_doublePrintStatus),
                                        child: const Text('Double Print'))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_saveBtVisibility,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: appThemeColor)),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Payment Mode',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: appThemeColor,
                                  fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              PaymentModeWidget(
                                iconData: Icons.currency_rupee,
                                title: cashString,
                                selectedStatus: paymentModeMap[cashString]!,
                                onTap: () {
                                  choosePaymentMode(
                                      paymentMode: cashString,
                                      context: context);
                                },
                              ),
                              PaymentModeWidget(
                                iconData: Icons.credit_card,
                                title: gPayCardString,
                                selectedStatus: paymentModeMap[gPayCardString]!,
                                onTap: () {
                                  choosePaymentMode(
                                      paymentMode: gPayCardString,
                                      context: context);
                                },
                              ),
                              PaymentModeWidget(
                                iconData: Icons.local_hospital_outlined,
                                title: mgmPaymentModeString,
                                selectedStatus:
                                    paymentModeMap[mgmPaymentModeString]!,
                                onTap: () {
                                  choosePaymentMode(
                                      paymentMode: mgmPaymentModeString,
                                      context: context);
                                },
                              ),
                              PaymentModeWidget(
                                iconData: Icons.sick_outlined,
                                title: inPatientString,
                                selectedStatus:
                                    paymentModeMap[inPatientString]!,
                                onTap: () {
                                  choosePaymentMode(
                                      paymentMode: inPatientString,
                                      context: context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _saveBtVisibility,
                    child: Row(
                      children: [
                        SaveClearWidget(
                            title: 'Save',
                            onPressed: () async {
                              checkLoginStatus().then((logStatus) async {
                                if (logStatus != null) {
                                  if (logStatus) {
                                    print('entryModel = $entryModel');
                                    // String s = paymentModeMap.entries.where((data) => data.value).map((data)=>data.key).first;
                                    // for (var v in s) {
                                    //   print('It string s = $s');
                                    // }
                                    if (entryModel != null) {
                                      setState(() => _isLoading = true);
                                      ExitResponseModel? e =
                                      await _saveExitVehicleData();
                                      if (context.mounted) {
                                        if (e != null &&
                                            e.message == 'Succesfully OutChecked!') {
                                          autoDeleteAlertDialog(
                                              context: context,
                                              message: 'Saved Successfully!');
                                        } else {
                                          autoDeleteAlertDialog(
                                              context: context,
                                              message: 'Failed to Save Data');
                                        }
                                      }
                                      _clearData();
                                    } else {
                                      showMessageAlertDialog(
                                          context: context,
                                          message: 'Failed. Invalid Vehicle Details');
                                    }
                                  } else {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (Route<dynamic> route) => false);
                                  }
                                } else {
                                  showErrorAlertDialog(
                                      context: context,
                                      message:
                                          'Something went wrong try again later');
                                }
                              });
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            FullScreenLoadingWidget(isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  _clearData() {
    // checkStatus = true;
    _idNumber.clear();
    entryModel = null;
    _idFocusNode.requestFocus();
    _idController.clear();
    amount = 0;
    entryDateTime = '';
    exitDateTime = '';
    hours = 0;
    minutes = 0;
    seconds = 0;
    noOfDays = 0;
    remainingHours = 0;
    textFieldVisibility = true;
    _touchStatus = false;
    _saveBtVisibility = false;
    paymentModeMap.updateAll((key, value) => false);
    setState(() => _isLoading = false);
  }
}

class DialysisNormalWidget extends StatelessWidget {
  final String title;
  final Function() onTap;

  const DialysisNormalWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: appThemeColor),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 3)]),
          child: Center(
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      fontSize: 16))),
        ),
      ),
    );
  }
}

class PaymentModeWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selectedStatus;
  final Function() onTap;

  const PaymentModeWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.selectedStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          decoration: BoxDecoration(
              color: selectedStatus ? appThemeColor : Colors.grey.shade300,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Column(
            children: [
              Icon(iconData,
                  color: selectedStatus ? Colors.white : Colors.black),
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(title,
                      style: TextStyle(
                          color: selectedStatus ? Colors.white : Colors.black)))
            ],
          ),
        ),
      ),
    );
  }
}

class TableColumn extends StatelessWidget {
  final String title;
  final String value;

  const TableColumn({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableContainer(
            value: title,
            titleStatus: true,
          ),
          TableContainer(
            value: value,
            titleStatus: false,
          ),
        ],
      ),
    );
  }
}

class TableContainer extends StatelessWidget {
  final String value;
  final bool titleStatus;

  const TableContainer({
    super.key,
    required this.value,
    required this.titleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Center(
          child: Text(
        value,
        maxLines: 1,
        style: TextStyle(
            color: titleStatus ? appThemeColor : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      )),
    );
  }
}

class TimeDifferenceWidget extends StatelessWidget {
  final String title;
  final bool? headerStatus;

  const TimeDifferenceWidget({
    super.key,
    required this.title,
    this.headerStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: decoration(),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight:
                    headerStatus != null ? FontWeight.w600 : FontWeight.normal,
                color: headerStatus != null ? appThemeColor : Colors.black),
          ))),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(),
    );
  }
}

class ExitFieldWidgets extends StatelessWidget {
  final String title;
  final String value;

  const ExitFieldWidgets({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(title,
                  style: TextStyle(
                      color: appThemeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: title == 'Amount' ? 18 : 14))),
          Text(' :     ',
              style:
                  TextStyle(color: appThemeColor, fontWeight: FontWeight.w600)),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: title == 'Amount' ? 18 : 14)))
        ],
      ),
    );
  }
}
