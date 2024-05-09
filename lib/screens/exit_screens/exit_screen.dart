import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mgm_parking_app/utils/colors.dart';
import '../../sevices/provider_services/date_time_provider.dart';
import '../../utils/constants.dart';
import '../../utils/custom_widgets/common_widget.dart';
import '../../utils/custom_widgets/loading_widgets.dart';
import '../../utils/custom_widgets/profile_screen_widget.dart';

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
  DateTimeProvider? dateTimeProvider;
  bool checkStatus = true;

  _calculateAmount()
  {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      // height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                            SaveClearWidget(title: 'Check Details', onPressed: () {
                              setState(() {
                                checkStatus = !checkStatus;
                              });
                            }),
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
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: appThemeColor
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: appThemeColor,
                                    blurRadius: 3
                                )
                              ]
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                ExitFieldWidgets(title: 'UHF ID', value: '#154266765'),
                                ExitFieldWidgets(title: 'Vehicle Type', value: 'Bike'),
                                ExitFieldWidgets(title: 'Location', value: 'Express Avenue'),
                                ExitFieldWidgets(title: 'Entry Time', value: '08-05-2024 14:40:22'),
                                ExitFieldWidgets(title: 'Exit Time', value: '08-05-2024 16:40:22'),
                                ExitFieldWidgets(title: 'Amount', value: '${rupeeSymbol}60')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const Spacer(),
                Row(
                  children: [
                    SaveClearWidget(title: 'Save', onPressed: () {
                      _clearData();
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
    );
  }
  _clearData()
  {
    checkStatus = true;
    _idNumber.clear();
    _idFocusNode.requestFocus();
    _idController.clear();
    setState(() {});
  }
}

class ExitFieldWidgets extends StatelessWidget {
  final String title;
  final String value;
  const ExitFieldWidgets({
    super.key, required this.title, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(title,style: TextStyle(color: appThemeColor,
            fontWeight: FontWeight.w600
          ))),
          Text(' :  ',style: TextStyle(color: appThemeColor,
              fontWeight: FontWeight.w600
          )),
          Expanded(child: Text(value,style: const TextStyle(
              fontWeight: FontWeight.w600
          )))
        ],
      ),
    );
  }
}
