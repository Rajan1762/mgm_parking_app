import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  ScannerScreen({super.key});
  final MobileScannerController _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      torchEnabled: true
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 800,
          width: MediaQuery.of(context).size.width,
          child: AiBarcodeScanner(
            hideGalleryButton: true,
            controller: _scannerController,
            onDetect: (BarcodeCapture capture) {
              print('capture = $capture');
              // scannedValue.clear();
              // scannedValue.write(capture.barcodes.first.rawValue);
              if (kDebugMode) {
                // print("Barcode scanned: ${scannedValue.toString()}");
              }
              _scannerController.stop();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}