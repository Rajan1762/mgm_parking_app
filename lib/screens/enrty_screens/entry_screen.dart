import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgm_parking_app/model/profile_models.dart';
import 'package:mgm_parking_app/sevices/network_services/profile_services.dart';
import 'package:mgm_parking_app/sevices/provider_services/date_time_provider.dart';
import 'package:mgm_parking_app/utils/custom_widgets/loading_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utils/colors.dart';
import '../../utils/common_functions.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/common_widget.dart';
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
  bool bikeSelected = true;
  List<XFile>? _mediaFileList;
  bool isLoading = false;


  @override
  void initState() {
    _idFocusNode.requestFocus();
    DateTimeProvider? dateTimeProvider = Provider.of<DateTimeProvider>(context, listen: false);
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

  Future<bool> _saveUserData() async {
    var dateTime = DateTime.now();
    String img64 = '';
    if (_mediaFileList != null) {
      final bytes = File(_mediaFileList![0].path).readAsBytesSync();
      img64 = base64Encode(bytes);
    }
    try {
      registerUser(
          registerModel: RegisterModel(
              id: const Uuid().v4(),
              scanId: _idNumber.toString(),
              ownerName: _ownerName.toString(),
              ownerMobile: _ownerMobileNumber.toString(),
              location: dropdownValue,
              driverName: dropdownDriverValue,
              driverMobile: _driverMobileNumber.toString(),
              date: formatDate(dateTime),
              time: formatTime(dateTime),
              image_data: img64));
      _formKey.currentState?.reset();
    } catch (e) {
      print('_saveUserData Error Occurred = $e');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
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
                        }),
                    // const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              Text('Date',style: TextStyle(fontSize: 16)),
                              Text('Time',style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Consumer<DateTimeProvider>(
                            builder: (BuildContext context,
                                DateTimeProvider provider, Widget? child) {
                              return Row(
                                children: [
                                  DataTimeContainerWidget(
                                    value: provider.date, dateStatus: true,),
                                  DataTimeContainerWidget(
                                    value: provider.time, dateStatus: false,),
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
                              title: 'Bike',
                              onTap: () {
                                bikeSelected = true;
                                setState(() {});
                              },
                              selectedStatus: bikeSelected),
                          const SizedBox(width: 15),
                          BikeCarSelectionWidget(
                              title: 'Car',
                              onTap: () {
                                bikeSelected = false;
                                setState(() {});
                              },
                              selectedStatus: !bikeSelected)
                        ],
                      ),
                    ),
                    const Text('Choose Location',
                        style: TextStyle(fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: appThemeColor)
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // iconEnabledColor: Colors.white,
                            isExpanded: true,
                            // hint: const Text('Select Waiter'),
                            value: dropdownValue,
                            items: list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value,));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SaveClearWidget(
                          title: 'Save',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              _saveUserData().then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: appThemeColor,
                                    content: const Text(
                                      'Saved Successfully!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                  setState(() => _isLoading = false);

                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeMainScreen()));
                                }
                                // _formKey.currentState?.reset();
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: (){
                            _clearData();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: appThemeColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 6
                                    )
                                  ]
                              ), child: const Icon(Icons.delete_outline,color: Colors.white,size: 26)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          FullScreenLoadingWidget(isLoading: _isLoading),
        ],
      ),
    );
  }

  _clearData()
  {
    bikeSelected = true;
    _idNumber.clear();
    _idFocusNode.requestFocus();
    dropdownValue = list.first;
    _idController.clear();
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
            child: Center(
                child: Text(title,
                    style: TextStyle(
                        color: selectedStatus ? Colors.white : appThemeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)))),
      ),
    );
  }
}

class DataTimeContainerWidget extends StatelessWidget {
  final String value;
  final bool dateStatus;

  const DataTimeContainerWidget({
    super.key,
    required this.value, required this.dateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.teal, border: Border.all(color: Colors.white),borderRadius: BorderRadius.only(
          topLeft: dateStatus ? const Radius.circular(8) : const Radius.circular(0),
          bottomLeft: dateStatus ? const Radius.circular(8) : const Radius.circular(0),
            topRight: !dateStatus ? const Radius.circular(8) : const Radius.circular(0),
            bottomRight: !dateStatus ? const Radius.circular(8) : const Radius.circular(0)
        ),),
        child: Text(value,textAlign: TextAlign.center,style: const TextStyle(color: Colors.white,fontSize: 16)),
      ),
    );
  }
}

