import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mgm_parking_app/screens/report_screen/category_detail_screen.dart';
import 'package:mgm_parking_app/utils/custom_widgets/loading_widgets.dart';
import '../../model/report_model.dart';
import '../../sevices/network_services/home_screen_services.dart';
import '../../utils/colors.dart';
import '../../utils/common_functions.dart';
import '../../utils/common_values.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int touchedIndex = -1;
  final bool isShowingMainData = true;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  List<ReportModel>? reportList;
  bool _isLoading = false;

  Future<void> _getReportData() async {
    reportList = await getReportData(
        fromDate: reportDateFormat(_fromDate),
        toDate: reportDateFormat(_toDate));
  }

  Future<void> _selectDate(
      {required BuildContext context, required bool fromDateStatus}) async {
    // var currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDateStatus ? _fromDate : _toDate,
        firstDate: fromDateStatus ? DateTime(1900) : _fromDate,
        lastDate: fromDateStatus ? _toDate : DateTime(2101),
        barrierColor: appThemeColor);
    if (picked != null) {
      setState(() {
        if (fromDateStatus) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Today is $currentDate'),
                const SizedBox(height: 10),
                DateRangeWidget(
                    title: 'From Date',
                    value: '$_fromDate',
                    onPressed: () {
                      _selectDate(context: context, fromDateStatus: true);
                    }),
                DateRangeWidget(
                    title: 'To Date',
                    value: '$_toDate',
                    onPressed: () {
                      _selectDate(context: context, fromDateStatus: false);
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30)),
                        // backgroundColor: MaterialStateProperty.all<Color>(appThemeColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        await _getReportData();
                        setState(() => _isLoading = false);
                        if(context.mounted && reportList==null){
                          showCustomSnackBar(context: context, message: 'Records not Available for this DateRange');
                        }
                      },
                      child:  Text(
                        'Get Report',
                        style: TextStyle(color: appThemeColor),
                      )),
                ),
                Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Total Entry Count : ${reportList?.length ?? 0}',
                          style: TextStyle(fontSize: 18,color: Colors.grey.shade700),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: reportList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryDetailScreen(reportModel: reportList![index])));
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                              ),
                              margin: const EdgeInsets.only(top: 6,bottom: 6),
                              color: appThemeColor,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ReportCardFieldWidget(
                                              title: 'Owner Number',
                                              value:
                                                  '${reportList?[index].ownerMobile}'),
                                          ReportCardFieldWidget(
                                              title: 'Location',
                                              value: '${reportList?[index].location}'),
                                          ReportCardFieldWidget(
                                              title: 'Driver Name',
                                              value: '${reportList?[index].driverName}'),
                                          ReportCardFieldWidget(
                                              title: 'Driver Number',
                                              value: '${reportList?[index].driverMobile}'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: reportList?[index].image_data != null ?
                                      Image.memory(base64Decode('${reportList?[index].image_data}'),fit: BoxFit.fill) :
                                      const Image(image: AssetImage('assets/images/loading_image.png'),fit: BoxFit.fill),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            ),
          ),
        ),
        FullScreenLoadingWidget(isLoading: _isLoading)
      ],
    );
  }

  void showCustomSnackBar({required BuildContext context,required String message}) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            showTitle: true,
            badgePositionPercentageOffset: 10,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class ReportCardFieldWidget extends StatelessWidget {
  final String title;
  final String value;

  const ReportCardFieldWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Text(title,style: TextStyle(color: Colors.grey.shade900,fontWeight: FontWeight.bold))),
          const Text('  :  ',style: TextStyle(color: Colors.white)),
          Expanded(child: Text(value,style: const TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}

class DateRangeWidget extends StatelessWidget {
  final String title;
  final String value;
  final Function() onPressed;

  const DateRangeWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              ' : ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onPressed, // _selectDate(context),
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration:  BoxDecoration(
                      color: appThemeColor,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(value.split(' ')[0],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_drop_down,
                          color: Colors.white)
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSquare;

  const Indicator(
      {super.key,
      required this.text,
      required this.color,
      required this.isSquare});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          color: color,
          child: const Text(''),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
