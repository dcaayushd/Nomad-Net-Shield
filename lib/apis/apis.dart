import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:nomadnetshield/helpers/pref.dart';
import 'package:nomadnetshield/models/vpn.dart';

import '../models/ip_details.dart';

class APIs {
  static Future<List<Vpn>> getVpnServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
      final csvString = res.body.split('#')[1].replaceAll('*', '');
      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
      final header = list[0];
      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        if (list[i].isNotEmpty) {
          for (int j = 0; j < header.length; ++j) {
            tempJson.addAll(
              {header[j].toString(): list[i][j]},
            );
          }
        }
        // log(jsonEncode(tempJson));
        vpnList.add(Vpn.fromJson(tempJson));
      }
    } catch (e) {
      log('\ngetVPNServers: $e');
    }
    vpnList.shuffle();
    if (vpnList.isNotEmpty) Pref.vpnList = vpnList;
    return vpnList;
  }

  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final res = await get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      log(data.toString());
      ipData.value = IPDetails.fromJson(data);
    } catch (e) {
      log('\ngetIPDetail : $e');
    }
  }
}
