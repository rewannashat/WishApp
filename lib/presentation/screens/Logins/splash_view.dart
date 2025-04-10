import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNav/bottomnavbar_view.dart';
import 'deviceData_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation in reverse for pulse effect

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _checkForPlaylist();
  }

  Future<void> _checkForPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistName = prefs.getString('playlist_name');
    final playlistUrl = prefs.getString('playlist_url');

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (playlistName != null && playlistUrl != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DeviceDataView()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller when not in use
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1d1d1d), Color(0xff171717), Color(0xFF2e3949)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/Asset.png',
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
