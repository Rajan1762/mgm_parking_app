import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgm_parking_app/sevices/network_services/profile_services.dart';
import 'package:mgm_parking_app/sevices/provider_services/date_time_provider.dart';
import 'package:mgm_parking_app/utils/custom_widgets/loading_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../model/entry_model.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/common_widget.dart';
import '../../utils/custom_widgets/notification_widgets.dart';
import '../../utils/custom_widgets/profile_screen_widget.dart';

const List<String> list = <String>[
  'CityCenter',
  'VRMall',
  'ExpressAvenue',
  'SkyWalk'
];
const List<String> driverList = <String>[
  'Rajan',
  'Dhana',
  'Antony',
  'Karthic',
  'Aravind',
  'Vinoth'
];

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final StringBuffer _ownerMobileNumber = StringBuffer();
  final StringBuffer _ownerName = StringBuffer();
  final StringBuffer _driverMobileNumber = StringBuffer();
  final StringBuffer _idNumber = StringBuffer();

  // final ScrollController _scrollController = ScrollController();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _ownerNameFocusNode = FocusNode();
  final FocusNode _ownerNumberFocusNode = FocusNode();
  final FocusNode _driveNameFocusNode = FocusNode();
  final FocusNode _driverNumberFocusNode = FocusNode();
  final TextEditingController _idController = TextEditingController();

  bool obscureStatus = true;
  bool _isLoading = false;
  String dropdownValue = list.first;
  String dropdownDriverValue = driverList.first;
  bool carSelected = true;
  List<XFile>? _mediaFileList;
  bool isLoading = false;
  bool _touchStatus = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _idFocusNode.requestFocus();
      }
    });
    DateTimeProvider? dateTimeProvider =
        Provider.of<DateTimeProvider>(context, listen: false);
    dateTimeProvider.runTimer();
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _idFocusNode.dispose();
    _ownerNameFocusNode.dispose();
    _ownerNumberFocusNode.dispose();
    _driveNameFocusNode.dispose();
    _driverNumberFocusNode.dispose();
    _idController.dispose();
    // dateTimeProvider?.dispose();
    super.dispose();
  }

  Future<bool> _addNewVehicle() async {
    var dateTime = DateTime.now();
    String img64 = '';
    if (_mediaFileList != null) {
      final bytes = File(_mediaFileList![0].path).readAsBytesSync();
      img64 = base64Encode(bytes);
    }
    print('dateTime = $dateTime');
    try {
      await saveEntryVehicle(
        registerModel: EntryModel(
            // transid: 1,
            uniqueId: const Uuid().v4(),
            vehicleNo: _idNumber.toString(),
            vehicleType: carSelected ? "1" : "2",
            barcode: "",
            date: '$dateTime',
            intime: '$dateTime',
            createdate: '$dateTime',
            status: "A",
            booth: "2",
            userid: "1",
            amount: 0,
            design: "",
            userName: ""),
      );
      _formKey.currentState?.reset();
    } catch (e) {
      print('_saveUserData Error Occurred = $e');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade300,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.796,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          }, touchStatus: _touchStatus, onTap: () {
                        if(!_touchStatus)
                        {
                          setState(() {
                            print('_touchStatus = $_touchStatus');
                            _touchStatus = true;
                            _idFocusNode.unfocus();
                          });
                          Future.delayed(const Duration(milliseconds: 500),(){
                            setState(() {
                              _idFocusNode.requestFocus();
                            });
                          });
                        }
                      }),
                      // const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Date', style: TextStyle(fontSize: 16)),
                                Text('Time', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Consumer<DateTimeProvider>(
                              builder: (BuildContext context,
                                  DateTimeProvider provider, Widget? child) {
                                return Row(
                                  children: [
                                    DataTimeContainerWidget(
                                      value: provider.date,
                                      dateStatus: true,
                                    ),
                                    DataTimeContainerWidget(
                                      value: provider.time,
                                      dateStatus: false,
                                    ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            BikeCarSelectionWidget(
                                title: 'Car',
                                onTap: () {
                                  carSelected = true;
                                  setState(() {});
                                },
                                selectedStatus: carSelected),
                            const SizedBox(width: 15),
                            BikeCarSelectionWidget(
                                title: 'Bike',
                                onTap: () {
                                  carSelected = false;
                                  setState(() {});
                                },
                                selectedStatus: !carSelected)
                          ],
                        ),
                      ),
                      // const Text('Choose Location',
                      //     style: TextStyle(fontSize: 16)),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //     border: Border.all(color: appThemeColor)
                      //   ),
                      //   child: Center(
                      //     child: DropdownButtonHideUnderline(
                      //       child: DropdownButton(
                      //         // iconEnabledColor: Colors.white,
                      //         isExpanded: true,
                      //         // hint: const Text('Select Waiter'),
                      //         value: dropdownValue,
                      //         items: list.map<DropdownMenuItem<String>>((String value) {
                      //           return DropdownMenuItem<String>(value: value, child: Text(value,));
                      //         }).toList(),
                      //         onChanged: (String? value) {
                      //           setState(() {
                      //             dropdownValue = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text('Choose Location',
                      //     style: TextStyle(fontSize: 16)),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                      //       border: Border.all(color: appThemeColor)
                      //   ),
                      //   child: Center(
                      //     child: DropdownButtonHideUnderline(
                      //       child: DropdownButton(
                      //         // iconEnabledColor: Colors.white,
                      //         isExpanded: true,
                      //         // hint: const Text('Select Waiter'),
                      //         value: dropdownValue,
                      //         items: list.map<DropdownMenuItem<String>>((String value) {
                      //           return DropdownMenuItem<String>(value: value, child: Text(value,));
                      //         }).toList(),
                      //         onChanged: (String? value) {
                      //           setState(() {
                      //             dropdownValue = value!;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Spacer(),
                      Row(
                        children: [
                          SaveClearWidget(
                            title: 'Add',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isLoading = true);
                                _addNewVehicle().then((value) {
                                  if (value) {
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(SnackBar(
                                    //   backgroundColor: appThemeColor,
                                    //   content: const Text(
                                    //     'Saved Successfully!',
                                    //     style: TextStyle(color: Colors.white),
                                    //   ),
                                    // ));
                                    autoDeleteAlertDialog(
                                        context: context,
                                        message: 'Added Successfully!');
                                    _clearData();
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeMainScreen()));
                                  }
                                  // _formKey.currentState?.reset();
                                });
                              }
                            },
                          ),
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        FullScreenLoadingWidget(isLoading: _isLoading),
      ],
    );
  }

  _clearData() {
    _isLoading = false;
    carSelected = true;
    _idNumber.clear();
    _idFocusNode.requestFocus();
    dropdownValue = list.first;
    _idController.clear();
    _touchStatus = false;
    setState(() {});
  }
}

class BikeCarSelectionWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool selectedStatus;

  const BikeCarSelectionWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: selectedStatus ? appThemeColor : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Icon(
                  title == 'Bike'
                      ? Icons.directions_bike
                      : Icons.directions_car,
                  color: selectedStatus ? Colors.white : appThemeColor,
                  size: 30,
                ),
                const SizedBox(height: 5),
                Text(title,
                    style: TextStyle(
                        color: selectedStatus ? Colors.white : appThemeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            )),
      ),
    );
  }
}

class DataTimeContainerWidget extends StatelessWidget {
  final String value;
  final bool dateStatus;

  const DataTimeContainerWidget({
    super.key,
    required this.value,
    required this.dateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.teal,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: dateStatus
                  ? const Radius.circular(8)
                  : const Radius.circular(0),
              bottomLeft: dateStatus
                  ? const Radius.circular(8)
                  : const Radius.circular(0),
              topRight: !dateStatus
                  ? const Radius.circular(8)
                  : const Radius.circular(0),
              bottomRight: !dateStatus
                  ? const Radius.circular(8)
                  : const Radius.circular(0)),
        ),
        child: Text(value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
