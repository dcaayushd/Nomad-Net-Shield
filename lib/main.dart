import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:nomadnetshield/firebase_options.dart';
import 'package:nomadnetshield/helpers/ad_helper.dart';
import 'package:nomadnetshield/helpers/config.dart';

import 'helpers/pref.dart';
import 'screens/splash_screen.dart';

// GLobal object for accessing device screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Enter Full Screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  // Firebase Initialization
  await Firebase.initializeApp();
  // Remote Config Initialization
  await Config.initConfig();
  // Hive Initialization
  await Pref.initializeHive();
  // Ads Initialization
  await AdHelper.initAds();
  // For setting orientation in portrait only
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (v) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nomad Net Shield',
      home: const SplashScreen(),
      // Theme
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          color: Color(0XFF021B3A),
          centerTitle: true,
          elevation: 3,
        ),
      ),
      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF0D0F14),
          centerTitle: true,
          elevation: 3,
        ),
      ),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white70 : Colors.black54;
  Color get bottomNav =>
      Pref.isDarkMode ? Colors.white12 : const Color(0XFF021B3A);
}
