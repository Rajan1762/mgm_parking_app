import 'dart:convert';

import 'package:flutter/material.dart';

import '../../utils/custom_widgets/common_widget.dart';

class ViewImageScreen extends StatefulWidget {
  final String? imageData;

  const ViewImageScreen({super.key, required this.imageData});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: InteractiveViewer(
                constrained: false,
                maxScale: 5,
                minScale: 0.1,
                boundaryMargin: const EdgeInsets.all(20),
                child: widget.imageData != null
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.memory(base64Decode('${widget.imageData}'),fit: BoxFit.fill),
                      )
                    : const DefaultAssetImage())));
  }
}
