import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nomadnetshield/controllers/native_ad_controller.dart';
import 'package:nomadnetshield/helpers/config.dart';
import 'dart:developer';

import 'package:nomadnetshield/helpers/my_dialogs.dart';

class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  // static InterstitialAd? _interstitialAd;
  // static bool _interstitialAdLoaded = false;

  // static NativeAd? _nativeAd;
  // static bool _nativeAdLoaded = false;

  /// Loads an interstitial ad.
  static void showInterstitialAd({required VoidCallback onComplete}) {
    log('Interstitial Ad Id: ${Config.interstitialAd}');
    if (Config.hideAds) {
      onComplete();
      return;
    }

    MyDialogs.showProgress();
    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
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
  static NativeAd? loadNativeAd({required NativeAdController adController}) {
    log('Native Ad Id: ${Config.nativeAd}');
    if (Config.hideAds) {
      return null;
    }
    return NativeAd(
      adUnitId: Config.nativeAd,
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

  /// Loads an Rewarded ad.
  static void showRewardedAd({required VoidCallback onComplete}) {
    log('Rewarded Ad Id: ${Config.rewardedAd}');
    if (Config.hideAds) {
      onComplete();
      return;
    }
    MyDialogs.showProgress();
    RewardedAd.load(
      adUnitId: Config.rewardedAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          Get.back();
          // rewarded ad listener
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
          // onComplete();
        },
      ),
    );
  }
}
