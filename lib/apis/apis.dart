import 'dart:developer';

import 'package:http/http.dart';

class APIs {
  static Future<void> getVpnServer() async {
    final res = await get(Uri.parse('http://www.vpngate.net/api/iphone/'));
    log(res.body);
  }
}
