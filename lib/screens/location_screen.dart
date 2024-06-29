import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import 'package:nomadnetshield/controllers/location_controller.dart';
import 'package:nomadnetshield/controllers/native_ad_controller.dart';
import 'package:nomadnetshield/helpers/ad_helper.dart';
// import 'package:nomadnetshield/helpers/config.dart';
import 'package:nomadnetshield/widgets/vpn_card.dart';
import '../main.dart';
// import '../widgets/watch_ad_dialog.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});
  final _controller = LocationController();
  final _adController = NativeAdController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            'VPN Locations (${_controller.vpnList.length})',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        bottomNavigationBar:
            // Config.hideAds ? null :
            _adController.ad != null && _adController.adLoaded.isTrue
                ? SafeArea(
                    child: SizedBox(
                      height: 85,
                      child: AdWidget(ad: _adController.ad!),
                    ),
                  )
                : null,

        // Refresh Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
            right: 10,
          ),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).bottomNav,
            onPressed: () {
              _controller.getVpnData();
            },
            child: const Icon(
              CupertinoIcons.refresh,
              color: Colors.white,
            ),
          ),
        ),

        body: _controller.isLoading.value
            ? _loadingWidget(context)
            : _controller.vpnList.isEmpty
                ? _noVPNFound(context)
                : _vpnData(),
      ),
    );
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
        itemBuilder: (ctx, i) => VpnCard(
          vpn: _controller.vpnList[i],
        ),
      );

  _loadingWidget(BuildContext context) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //lottie animation
            LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: mq.width * .7,
            ),

            //text
            Text(
              'Loading VPNs...',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).lightText,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );

  _noVPNFound(BuildContext context) => Center(
        child: Text(
          'VPNs Not Found!',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
