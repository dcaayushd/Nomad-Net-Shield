import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nomadnetshield/apis/apis.dart';
import 'package:nomadnetshield/controllers/location_controller.dart';

import '../main.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _controller = LocationController();
  @override
  void initState() {
    super.initState();
    _controller.getVpnData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(
              'VPN Locations (${_controller.vpnList.length})',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: _controller.isLoading.value
              ? _loadingWidget()
              : _controller.vpnList.isEmpty
                  ? _noVPNFound()
                  : _vpnData(),
        ));
  }

  _vpnData() => ListView.builder(
        itemCount: _controller.vpnList.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: mq.height * .015,
          bottom: mq.height * .1,
          left: mq.width * .04,
          right: mq.width * .04,
        ),
        itemBuilder: (ctx, i) => Text(_controller.vpnList[i].hostName),
      );

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //lottie animation
            LottieBuilder.asset('assets/lottie/loading.json',
                width: mq.width * .7),

            //text
            const Text(
              'Loading VPNs... 😌',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => const Center(
        child: Text(
          'VPNs Not Found! 😔',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
