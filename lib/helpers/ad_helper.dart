import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nomadnetshield/controllers/native_ad_controller.dart';
import 'dart:developer';

import 'package:nomadnetshield/helpers/my_dialogs.dart';

class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  /// Loads an interstitial ad.
  static void showInterstitialAd({required VoidCallback onComplete}) {
    MyDialogs.showProgress();
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            onComplete();
          });
          Get.back();
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }
  /// Loads an Native ad.
  static NativeAd loadNativeAd({required NativeAdController adController}) {
    return NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          adController.adLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          log('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    )..load();
  }

  static void showRewardedAd({required VoidCallback onComplete}) {
    MyDialogs.showProgress();
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
       
          Get.back();
          // ad listener
          ad.show(onUserEarnedReward: (
            AdWithoutView ad,
            RewardItem rewardItem,
          ) {
            onComplete;
          });
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }
}
