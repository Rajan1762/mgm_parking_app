import 'package:flutter/material.dart';
import 'package:mgm_parking_app/utils/colors.dart';

import '../../utils/common_values.dart';
class TopEntriesPage extends StatefulWidget {
  final bool entryStatus;
  const TopEntriesPage({super.key, required this.entryStatus});

  @override
  State<TopEntriesPage> createState() => _TopEntriesPageState();
}

class _TopEntriesPageState extends State<TopEntriesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true, // Ensures the ListView takes only the space it needs
              itemCount: widget.entryStatus
                  ? topEntryValue?.length
                  : topExitValue?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(
                      widget.entryStatus
                          ? Icons.directions_car
                          : Icons.exit_to_app,
                      color: appThemeColor,
                    ),
                    title: Text(
                      '${widget.entryStatus ? topEntryValue![index]['vehicleNo'] : topExitValue?[index]['vehicleNo']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.entryStatus
                          ? "Entry Vehicle"
                          : "Exit Vehicle",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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

