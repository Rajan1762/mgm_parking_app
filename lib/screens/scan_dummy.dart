// import 'package:flutter/material.dart';
// import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
//
// class ScanDummy extends StatefulWidget {
//   const ScanDummy({super.key});
//
//   @override
//   State<ScanDummy> createState() => _ScanDummyState();
// }
//
// class _ScanDummyState extends State<ScanDummy> with WidgetsBindingObserver {
//
// scanQRCode(){
//   SizedBox(
//     width: 100,
//     height: 100,
//     child: QRCodeDartScanView(
//       scanInvertedQRCode: true, // enable scan invert qr code ( default = false)
//
//       typeScan: TypeScan.live, // if TypeScan.takePicture will try decode when click to take a picture(default TypeScan.live)
//       // intervalScan: const Duration(seconds:1)
//       // onResultInterceptor: (old,new){
//       //  do any rule to controll onCapture.
//       // }
//       // takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
//       //    if(loading) return CircularProgressIndicator();
//       //    return ElevatedButton(
//       //       onPressed:controller.takePictureAndDecode,
//       //       child:Text('Take a picture'),
//       //    );
//       // }
//       // resolutionPreset: = QrCodeDartScanResolutionPreset.high,
//       // formats: [ // You can restrict specific formats.
//       //  BarcodeFormat.qrCode,
//       //  BarcodeFormat.aztec,
//       //  BarcodeFormat.dataMatrix,
//       //  BarcodeFormat.pdf417,
//       //  BarcodeFormat.code39,
//       //  BarcodeFormat.code93,
//       //  BarcodeFormat.code128,
//       //  BarcodeFormat.ean8,
//       //  BarcodeFormat.ean13,
//       // ],
//       onCapture: (Result result) {
//         print('result - $result');
//         // do anything with result
//         // result.text
//         // result.rawBytes
//         // result.resultPoints
//         // result.format
//         // result.numBits
//         // result.resultMetadata
//         // result.time
//       },
//     ),
//   );
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mobile Scanner Example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(onPressed: (){
//               scanQRCode();
//             },child: Text('Scan QR Code')),
//             SizedBox(
//               width: 150,
//               height: 150,
//               child: QRCodeDartScanView(
//                 scanInvertedQRCode: true, // enable scan invert qr code ( default = false)
//
//                 typeScan: TypeScan.takePicture, // if TypeScan.takePicture will try decode when click to take a picture(default TypeScan.live)
//                 intervalScan: const Duration(seconds:10),
//                 // onResultInterceptor: (old,new){
//                 //  do any rule to controll onCapture.
//                 // }
//                 // takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
//                 //    if(loading) return CircularProgressIndicator();
//                 //    return ElevatedButton(
//                 //       onPressed:controller.takePictureAndDecode,
//                 //       child:Text('Take a picture'),
//                 //    );
//                 // }
//                 // resolutionPreset: = QrCodeDartScanResolutionPreset.high,
//                 formats: [ // You can restrict specific formats.
//                  BarcodeFormat.qrCode,
//                  BarcodeFormat.aztec,
//                  BarcodeFormat.dataMatrix,
//                  BarcodeFormat.pdf417,
//                  BarcodeFormat.code39,
//                  BarcodeFormat.code93,
//                  BarcodeFormat.code128,
//                  BarcodeFormat.ean8,
//                  BarcodeFormat.ean13,
//                 ],
//                 onCapture: (Result result) {
//                   print('result - $result');
//                   showDialog(context: context, builder: (context){
//                     return AlertDialog(
//                       title: Text('Result = $result'),
//                     );
//                   });
//                   // do anything with result
//                   // result.text
//                   // result.rawBytes
//                   // result.resultPoints
//                   // result.format
//                   // result.numBits
//                   // result.resultMetadata
//                   // result.time
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
