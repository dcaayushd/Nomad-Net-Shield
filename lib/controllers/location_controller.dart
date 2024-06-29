import 'package:get/get.dart';
// import 'package:nomadnetshield/helpers/config.dart';
import 'package:nomadnetshield/helpers/pref.dart';

import '../apis/apis.dart';
// import '../helpers/ad_helper.dart';
import '../models/vpn.dart';
// import '../widgets/watch_ad_dialog.dart';

class LocationController extends GetxController {
  List<Vpn> vpnList = Pref.vpnList;

  final RxBool isLoading = false.obs;

  Future<void> getVpnData() async {
    // // Ad Dialog
    // if (Config.hideAds) {
    //   isLoading.value = true;
    //   vpnList.clear();
    //   vpnList = await APIs.getVpnServers();
    //   isLoading.value = false;
    //   return;
    // }
    // Get.dialog(
    //   WatchAdDialog(
    // onComplete:
    // () async {
    //// Watch an ad to gain reward
    // AdHelper.showRewardedAd(
    // onComplete: () async {
    isLoading.value = true;
    vpnList.clear();
    vpnList = await APIs.getVpnServers();
    isLoading.value = false;
    // },
    // );
    // },
    //   ),
    // );
    // };
  }
}
