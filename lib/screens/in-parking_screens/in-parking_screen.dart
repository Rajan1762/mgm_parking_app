import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mgm_parking_app/sevices/network_services/in_parking_services.dart';
import 'package:mgm_parking_app/utils/custom_widgets/notification_widgets.dart';

import '../../model/in_parking_models/in_parking_vehicle_model.dart';
import '../../utils/colors.dart';
import '../home_screens/full_screen_loading.dart';

class InParkingScreen extends StatefulWidget {
  const InParkingScreen({super.key});

  @override
  State<InParkingScreen> createState() => _InParkingScreenState();
}

class _InParkingScreenState extends State<InParkingScreen> {
  bool _isLoading = true;
  List<InParkingVehicleModel>? inParkingVehicleModelList;
  bool _initialLoading = true;

  _getInParkingVehicleList(BuildContext context) async
  {
    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
    try{
      inParkingVehicleModelList = await getInParkingVehicleList(fromDate: currentDate, toDate: currentDate);
    }catch(e){
      print('e = $e');
      if(context.mounted)
        {
          showErrorAlertDialog(context: context, message: e.toString());
        }
    }
    setState(()=>_isLoading=false);
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_initialLoading)
      {
        _getInParkingVehicleList(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        body: inParkingVehicleModelList==null ? const FullScreenLoading() : Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true, // Ensures the ListView takes only the space it needs
              itemCount: inParkingVehicleModelList?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.directions_bike,
                      color: appThemeColor,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${inParkingVehicleModelList?[index].vehicleNo}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Time : ${DateFormat('hh:mma').format(DateTime.parse(inParkingVehicleModelList?[index].date ?? ''))}',
                            style: const TextStyle(
                              // fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text('In-Parking',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Text(
                        //     'Time : $formattedTime',
                        //     style: const TextStyle(
                        //       // fontSize: 18,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  ),
                );
              },
            ),
          ),
        )
    ));
  }
}
