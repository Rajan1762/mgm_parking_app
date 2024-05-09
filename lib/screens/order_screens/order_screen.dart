import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../sevices/provider_services/floorTableProviderService.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // bool _floorTableTypeStatus = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<FloorTableProviderService>(
      builder: (providerContext, floorTableListProvider, Widget? child) { 
        return Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Radio<FloorTableTypeEnum>(
                      value: FloorTableTypeEnum.availableTables,
                      groupValue: floorTableListProvider.floorTableTypeEnum,
                      activeColor: appThemeColor,
                      onChanged: (FloorTableTypeEnum? value) {
                        floorTableListProvider.floorTableTypeEnum = value;
                      },
                    ),
                  ),
                  const Text(
                    'Available Tables',
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Radio<FloorTableTypeEnum>(
                      value: FloorTableTypeEnum.bookedTable,
                      groupValue: floorTableListProvider.floorTableTypeEnum,
                      activeColor: appThemeColor,
                      onChanged: (FloorTableTypeEnum? value) {
                        floorTableListProvider.floorTableTypeEnum = value;
                      },
                    ),
                  ),
                  const Text(
                    'Booked Table',
                    style: TextStyle(fontSize: 13),
                  )
                ],
              )
            ]),
            // Expanded(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: floorTableListProvider.orderFloorTableList.length,
            //     itemBuilder: (context, floorIndex) {
            //       print('floorTableListProvider.orderFloorTableList.length = ${floorTableListProvider.orderFloorTableList.length}');
            //       print('floorIndex value ==== ${floorTableListProvider.orderFloorTableList[floorIndex]}\n${floorTableListProvider.orderFloorTableList}');
            //       return Container(
            //         padding: const EdgeInsets.all(10),
            //         margin:
            //         const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //         decoration: const BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.all(Radius.circular(5)),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey,
            //               blurRadius: 5.0,
            //             ),
            //           ],
            //         ),
            //         height: floorTableListProvider.orderFloorTableList[floorIndex].length <= 3
            //             ? MediaQuery.of(context).size.height * 0.28
            //             : floorTableListProvider.orderFloorTableList[floorIndex].length <= 6
            //             ? MediaQuery.of(context).size.height * 0.44
            //             : floorTableListProvider.orderFloorTableList[floorIndex].length <= 9
            //             ? MediaQuery.of(context).size.height * 0.61
            //             : floorTableListProvider.orderFloorTableList[floorIndex].length <= 12
            //             ? MediaQuery.of(context).size.height * 0.80
            //             : floorTableListProvider.orderFloorTableList[floorIndex].length <= 15
            //             ? MediaQuery.of(context).size.height * 1.0
            //             : MediaQuery.of(context).size.height * 1.20,
            //         child: Column(
            //           children: [
            //             Text(
            //               "Floor : ${floorTableListProvider.orderFloorTableList[floorIndex].first.floorName}",
            //               style: const TextStyle(
            //                   fontSize: 16, fontWeight: FontWeight.w600),
            //             ),
            //             const Padding(
            //               padding: EdgeInsets.all(10.0),
            //               child: Divider(thickness: 2),
            //             ),
            //             Expanded(
            //               child: GridView.builder(
            //                   itemCount: floorTableListProvider.orderFloorTableList[floorIndex].length,
            //                   scrollDirection: Axis.vertical,
            //                   physics: floorTableListProvider.orderFloorTableList[floorIndex].length <= 15
            //                       ? const NeverScrollableScrollPhysics()
            //                       : null,
            //                   gridDelegate:
            //                   const SliverGridDelegateWithFixedCrossAxisCount(
            //                       crossAxisSpacing: 10,
            //                       mainAxisSpacing: 10,
            //                       crossAxisCount: 3,
            //                       childAspectRatio: 0.84),
            //                   itemBuilder: (_, tableIndex) {
            //                     print('[floorIndex][tableIndex] = ${floorTableListProvider.orderFloorTableList[floorIndex][tableIndex]}');
            //                     return GestureDetector(
            //                       // onTap: floorTableListProvider.listOfFloorTableList[floorIndex]
            //                       // [tableIndex]
            //                       //     .isAvailable ==
            //                       //     'D'
            //                       //     ? null
            //                       //     : () {
            //                       //   _incrementDecrementAnimation(
            //                       //       MediaQuery.of(context).size.height *
            //                       //           0.40);
            //                       // },
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: floorTableListProvider.floorTableTypeEnum == FloorTableTypeEnum.bookedTable
            //                               ? Colors.red
            //                               : Colors.grey,
            //                           borderRadius: const BorderRadius.all(
            //                               Radius.circular(5)),
            //                           boxShadow: const [
            //                             BoxShadow(
            //                               color: Colors.grey,
            //                               blurRadius: 3.0,
            //                             ),
            //                           ],
            //                         ),
            //                         child: Column(
            //                           children: [
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 5),
            //                               child: Text(
            //                                 floorTableListProvider.orderFloorTableList[floorIndex]
            //                                 [tableIndex]
            //                                     .tableName,
            //                                 style: TextStyle(
            //                                     color: tableIndex % 4 == 0
            //                                         ? Colors.white
            //                                         : Colors.black),
            //                               ),
            //                             ),
            //                             const Padding(
            //                               padding: EdgeInsets.symmetric(
            //                                   vertical: 5, horizontal: 2),
            //                               child: Image(
            //                                   image: AssetImage(tableAssetImage),
            //                                   fit: BoxFit.contain),
            //                             ),
            //                             Row(
            //                               mainAxisAlignment: MainAxisAlignment.end,
            //                               children: [
            //                                 Container(
            //                                   height: 22,
            //                                   width: 22,
            //                                   margin:
            //                                   const EdgeInsets.only(right: 10),
            //                                   decoration: const BoxDecoration(
            //                                       color: Colors.red,
            //                                       borderRadius: BorderRadius.all(
            //                                           Radius.circular(11))),
            //                                   child: Center(
            //                                     child: Text(
            //                                       floorTableListProvider.orderFloorTableList[floorIndex]
            //                                       [tableIndex]
            //                                           .noOfChars,
            //                                       style: const TextStyle(
            //                                           color: Colors.white,
            //                                           fontWeight: FontWeight.w600),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             )
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   }),
            //             ),
            //           ],
            //         ),
            //       );
            //     }),
            // ),
          ],
        ); },
    );
  }
}
