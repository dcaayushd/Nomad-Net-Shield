import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdHelper {
  static Future<void> initAds() async{
    await MobileAds.instance.initialize();
  }
}
