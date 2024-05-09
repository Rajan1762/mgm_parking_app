import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mgm_parking_app/screens/report_screen/view_image_screen.dart';
import '../../model/report_model.dart';

class CategoryDetailScreen extends StatefulWidget {
  final ReportModel _reportModel;

  const CategoryDetailScreen(
      {super.key, required ReportModel reportModel}) : _reportModel = reportModel;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Details"),
      ),
      body:Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ViewImageScreen(imageData: widget._reportModel.image_data)));
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Image.memory(base64Decode('${widget._reportModel.image_data}'),fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                      child: Column(
                        children: [
                          ReportDetailScreenFieldWidget(title: 'Location', value: widget._reportModel.location ?? '',),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'driverName : ${widget._reportModel.driverName ?? ''}',
                            style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'driverMobile : ${widget._reportModel.driverMobile ?? ''}',
                            style: TextStyle(color: Colors.grey.shade700,fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

    ));
  }
}

class ReportDetailScreenFieldWidget extends StatelessWidget {
  final String title;
  final String value;

  const ReportDetailScreenFieldWidget({
    super.key, required this.title, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       Expanded(child: Text(title)),
        const Text(' - '),
        Expanded(child: Text(value,textAlign: TextAlign.end))
      ],
    );
  }
}
