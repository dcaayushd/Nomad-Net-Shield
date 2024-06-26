import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Vpn.fromJson({}).obs;

  final vpnState = VpnEngine.vpnDisconnected.obs;


  void connectToVpn() {
    ///Stop right here if user not select a vpn
    if (vpn.value.openVPNConfigDataBase64.isEmpty) return;

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data =
          const Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
      final config = const Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
        country: vpn.value.countryLong,
        username: 'vpn',
        password: 'vpn',
        config: config,
      );

      ///Start if stage is disconnected
      VpnEngine.startVpn(vpnConfig);

    } else {
      ///Stop if stage is "not" disconnected

      VpnEngine.stopVpn();
    }
  }

  // VPN Button Color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  // VPN Button Text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Connecting...';
    }
  }
}
