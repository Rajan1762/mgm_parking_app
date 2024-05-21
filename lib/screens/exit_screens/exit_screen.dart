import 'package:flutter/material.dart';
import 'package:mgm_parking_app/model/entry_model.dart';
import 'package:mgm_parking_app/model/errorResponseModel.dart';
import 'package:mgm_parking_app/model/exit_screen_model/exit_screen_models.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';
import 'package:uuid/uuid.dart';
import '../../model/exit_screen_model/exit_screen_response_model.dart';
import '../../sevices/network_services/exit_screen_services.dart';
import '../../utils/common_functions.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/common_widget.dart';
import '../../utils/custom_widgets/loading_widgets.dart';
import '../../utils/custom_widgets/profile_screen_widget.dart';
import 'package:intl/intl.dart';

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
  ErrorResponseModel? errorResponseModel;
  Map<String, bool> paymentModeMap = {
    cashString: true,
    cardString: false,
    creditString: false,
    upiString: false
  };

  choosePaymentMode(String paymentMode) {
    paymentModeMap.forEach((key, value) {
      if (key == paymentMode) {
        paymentModeMap[key] = true;
      } else {
        paymentModeMap[key] = false;
      }
    });
    setState(() {});
  }

  Future<ExitResponseModel?> _saveExitVehicleData() async {
    print('shiftIDValue = $shiftIDValue');
    var dateTime = DateTime.now();
    return await saveExitVehicle(
        exitSaveModel: ExitSaveModel(
      uniqueId: const Uuid().v4(),
      vehicleType: entryModel?.vehicleType,
      vehicleNo: _idNumber.toString(),
      date: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime),
      //formatDate(dateTime),
      outime: DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime),
      //formatTime(dateTime),
      barcode: '',
      duration:
          '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
      intime: DateFormat("yyyy-MM-dd HH:mm:ss")
          .format(DateTime.parse( entryModel!.date!)),
      payment: '$amount',
      createdate: entryModel?.date,
      status: 'D',
      booth: '1',
      userid: '1',
      paymode: paymentModeMap.entries.where((data) => data.value).map((data)=>data.key).first,
      remarks: '',
      shiftid: shiftIDValue,
      userName: '',
      refNo: '',
      printDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime),
    ));
  }

  Future<ErrorResponseModel?> _checkVehicleDetails() async {
    errorResponseModel =
        await getExitVehicleDetails(scanID: _idNumber.toString());
    if (errorResponseModel != null) {
      if (errorResponseModel?.errorMessage != null) {
        return errorResponseModel;
      }
      entryModel = errorResponseModel?.obj;
      calculateAmount(entryModel!);
    }
    return errorResponseModel;
  }

  calculateAmount(EntryModel em) {
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
    VehicleValueModel vm = setVehicleValues(vehicleType: em.vehicleType ?? '');
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
      amount = remainingHours < 2 || (remainingHours == 2 && seconds == 0) ? vm.baseAmount : vm.baseAmount + ((remainingHours - 2) * vm.extraAmount) + (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
    } else {
      amount = (noOfDays * vm.perDayAmount) + (remainingHours * vm.extraAmount) + (((minutes != 0) || (seconds != 0)) ? vm.extraAmount : 0);
    }
    print('amount = $amount');
  }

  @override
  void initState() {
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileScreenFieldWidget(
                              fieldName: kIdString,
                              focusNode: _idFocusNode,
                              textEditingController: _idController,
                              textInputType: TextInputType.number,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  _idFocusNode.requestFocus();
                                  return "Required field cannot be empty";
                                }
                                return null;
                              },
                              onChangValue: (v) {
                                _idNumber.clear();
                                _idNumber.write(v);
                              }),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SaveClearWidget(
                                  title: 'Check Details',
                                  onPressed: () async {
                                    if (_idNumber.toString().isNotEmpty) {
                                      setState(() => _isLoading = true);
                                      await _checkVehicleDetails();
                                      setState(() => _isLoading = false);
                                      if (context.mounted) {
                                        if (errorResponseModel != null) {
                                          if (errorResponseModel
                                                  ?.errorMessage !=
                                              null) {
                                            showErrorAlertDialog(
                                                context: context,
                                                message: errorResponseModel!
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
                                      autoDeleteAlertDialog(
                                          context: context,
                                          message: 'Scan ID to Check');
                                      // showToast('Scan ID to Check');
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   content: Text('Scan ID to Check'),
                                      // ));
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
                            margin: const EdgeInsets.only(top: 15,bottom: 5),
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
                                          ? entryModel?.vehicleType == '1'
                                              ? 'Car'
                                              : 'Bike'
                                          : ''),
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
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: appThemeColor)),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Payment Mode',
                                    style:
                                    TextStyle(fontSize: 18, color: appThemeColor,fontWeight: FontWeight.w600)),
                                Row(
                                  children: [
                                    PaymentModeWidget(
                                      iconData: Icons.currency_rupee,
                                      title: cashString,
                                      selectedStatus: paymentModeMap[cashString]!,
                                      onTap: () {
                                        choosePaymentMode(cashString);
                                      },
                                    ),
                                    PaymentModeWidget(
                                      iconData: Icons.credit_card,
                                      title: cardString,
                                      selectedStatus: paymentModeMap[cardString]!,
                                      onTap: () {
                                        choosePaymentMode(cardString);
                                      },
                                    ),
                                    PaymentModeWidget(
                                      iconData: Icons.library_books_outlined,
                                      title: creditString,
                                      selectedStatus: paymentModeMap[creditString]!,
                                      onTap: () {
                                        choosePaymentMode(creditString);
                                      },
                                    ),
                                    PaymentModeWidget(
                                      iconData: Icons.qr_code,
                                      title: upiString,
                                      selectedStatus: paymentModeMap[upiString]!,
                                      onTap: () {
                                        choosePaymentMode(upiString);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SaveClearWidget(
                          title: 'Save',
                          onPressed: () async {
                            print('entryModel = $entryModel');
                            String s = paymentModeMap.entries.where((data) => data.value).map((data)=>data.key).first;
                            // for (var v in s) {
                              print('It string s = $s');
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
                          }),
                    ],
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
    setState(() => _isLoading = false);
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
              Text(title,
                  style: TextStyle(
                      color: selectedStatus ? Colors.white : Colors.black))
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
