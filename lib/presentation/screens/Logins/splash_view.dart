import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BottomNav/bottomnavbar_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A2E)],
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
