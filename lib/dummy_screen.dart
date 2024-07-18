import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mgm_parking_app/sevices/print_services/sunmi.dart';
import 'package:image/image.dart' as img;

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  String imageString = 'assets/images/offline_image.jpg';

  Future<Uint8List> loadAssetAsBytes(String path) async {
    ByteData byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> loadAssetAndResize(String path, int width, int height) async {
    // Load image from assets
    ByteData byteData = await rootBundle.load(path);
    Uint8List uint8list = byteData.buffer.asUint8List();

    // Decode image to Image object from image package
    img.Image? baseSizeImage = img.decodeImage(uint8list);

    // Resize the image
    img.Image resizedImage = img.copyResize(baseSizeImage!, width: width, height: height);

    // Encode the image back to Uint8List
    Uint8List resizedUint8List = Uint8List.fromList(img.encodePng(resizedImage));
    return resizedUint8List;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: Column(
          children: [
            FutureBuilder<Uint8List>(
              future: loadAssetAsBytes(imageString),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Image.memory(snapshot.data!);
                }
              },
            ),
            ElevatedButton(
              onPressed: ()async{
                print('onPressed called');

                Uint8List s = await loadAssetAndResize(imageString,100,100);
                // Uint8List s = await loadAssetAsBytes(imageString);
                Sunmi printer = Sunmi();
                printer.dummyPrint(img: s);

              },
              child: Text('Print Image'),
            ),
          ],
        ),
      ),
    ));
  }
}
