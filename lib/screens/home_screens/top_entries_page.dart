import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mgm_parking_app/utils/colors.dart';

import '../../sevices/network_services/exit_screen_services.dart';
import '../../sevices/network_services/home_screen_services.dart';
import '../../utils/common_values.dart';
import 'full_screen_loading.dart';
class TopEntriesPage extends StatefulWidget {
  final bool entryStatus;
  const TopEntriesPage({super.key, required this.entryStatus});

  @override
  State<TopEntriesPage> createState() => _TopEntriesPageState();
}

class _TopEntriesPageState extends State<TopEntriesPage> {
  bool _isLoading = true;
  _loadData() async
  {
    // setState(() =>_isLoading=true);
    if(entryExitStatus)
    {
      topEntryValue = await fetchTop10EntriesData();
    }else{
      topExitValue = await fetchTop10ExitData();
    }
    setState(() =>_isLoading=false);
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.entryStatus ? 'Entry Vehicle List' : 'Exit Vehicle List', style: GoogleFonts.oswald(
          textStyle: TextStyle(color: appThemeColor,fontSize: 26),
        ),),
          iconTheme: IconThemeData(
            color: appThemeColor, // Change the back arrow color here
          ),
        ),
        body: _isLoading ? const FullScreenLoading() : Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true, // Ensures the ListView takes only the space it needs
              itemCount: widget.entryStatus
                  ? topEntryValue?.length
                  : topExitValue?.length,
              itemBuilder: (BuildContext context, int index) {
                // String? dateTimeString = widget.entryStatus ? topEntryValue![index]['date'] : topExitValue?[index]['date'];
                // // String dateTimeString = '2024-07-06T12:26:17.58';
                // DateTime dateTime = DateTime.parse(dateTimeString!);
                //
                // // Format the date and time
                // String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
                // String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.directions_bike
                      // widget.entryStatus
                      //     ? Icons.directions_bike
                      //     : Icons.exit_to_app
                      ,
                      color: appThemeColor,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.entryStatus ? topEntryValue![index]['vehicleNo'] : topExitValue?[index]['vehicleNo']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Text(
                        //     'Date : $formattedDate',
                        //     style: const TextStyle(
                        //       // fontSize: 18,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.entryStatus
                                ? "Entry Vehicle"
                                : "Exit Vehicle",
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
        ),
      ),
    );


    //   SafeArea(child: Scaffold(
    //   body: Center(
    //     child: ListView.builder(
    //       shrinkWrap: true,  // Ensures the ListView takes only the space it needs
    //       itemCount: widget.entryStatus ? topEntryValue?.length : topExitValue?.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return ListTile(
    //           title: Text('${widget.entryStatus ? topEntryValue![index]['vehicleNo'] : topExitValue?[index]['vehicleNo']}'),
    //         );
    //       },
    //     ),
    //   ),
    // ));
  }
}

