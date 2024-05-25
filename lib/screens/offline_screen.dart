import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../utils/common_values.dart';
import '../utils/constants.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (!result.contains(ConnectivityResult.none)) {
        if (networkDownCount == 1) {
          networkDownCount = 0;
          // networkUpCount=0;
          Navigator.of(context).pop();
        }
      }
    });
    return const SafeArea(
        child: Scaffold(
      body: Center(
        child: Image(image: AssetImage(kOfflineImage)),
      ),
    ));
  }
}
