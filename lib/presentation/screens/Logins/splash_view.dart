import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'deviceData_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DeviceDataView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1d1d1d),Color(0xff171717), Color(0xFF2e3949)],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/Asset.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
