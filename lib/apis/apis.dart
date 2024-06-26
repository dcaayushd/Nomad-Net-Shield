import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:http/http.dart';
import 'package:nomadnetshield/models/vpn.dart';

class APIs {
  static Future<void> getVpnServer() async {
    final List<Vpn> vpnList = [];

   try{
     final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
    final csvString = res.body.split('#')[1].replaceAll('*', '');
    List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
    final header = list[0];
    for (int i = 1; i < header.length; ++i) {
      Map<String, dynamic> tempJson = {};
      for (int j = 0; j < header.length; ++j) {
        tempJson.addAll(
          {header[j].toString(): list[i][j]},
        );
      }
      // log(jsonEncode(tempJson));
      vpnList.add(Vpn.fromJson(tempJson));
    }
    log(vpnList.first.hostName);
   }
catch(e){
    log('\ngetVPNServers: $e');
   }
    //  log(res.body);
  }
}
