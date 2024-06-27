import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'helpers/pref.dart';
import 'screens/splash_screen.dart';

// GLobal object for accessing device screen size
late Size mq;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Enter Full Screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    await Pref.initializeHive();

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
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 3,
        ),
      ),
    );
  }
}
