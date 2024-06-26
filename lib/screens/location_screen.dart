import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nomadnetshield/apis/apis.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getVpnServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'VPN LOCATIONS',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
