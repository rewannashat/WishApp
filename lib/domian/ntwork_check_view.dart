import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'network_check.dart';


class NetworkWrapper extends StatefulWidget {
  final Widget child;
  const NetworkWrapper({super.key, required this.child});

  @override
  State<NetworkWrapper> createState() => _NetworkWrapperState();
}

class _NetworkWrapperState extends State<NetworkWrapper> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    NetworkChecker.onConnectivityChanged.listen((status) {
      setState(() {
        isOnline = status != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnection() async {
    final connected = await NetworkChecker.isConnected();
    setState(() {
      isOnline = connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isOnline ? widget.child : const NoInternetWidget();
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/internet.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection\nPlease check your connection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
