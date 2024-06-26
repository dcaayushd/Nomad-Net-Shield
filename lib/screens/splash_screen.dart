import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import '../main.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // Navigate to home
      Get.off(() => HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initializing MediaQuery for getting device screen size
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // App Logo
          Positioned(
            left: mq.width * .3,
            top: mq.height * .35,
            width: mq.width * .4,
            child: Image.asset('assets/images/logo.png'),
          ),
          // Label
          Positioned(
            bottom: mq.height * .05,
            width: mq.width,
            child: const Text(
              'MADE BY AAYUSH WITH ♡',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  letterSpacing: 1,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
