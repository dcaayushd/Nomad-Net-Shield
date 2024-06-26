import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:nomadnetshield/screens/location_screen.dart';
import 'package:nomadnetshield/widgets/count_down_timer.dart';
import 'package:nomadnetshield/widgets/home_card.dart';
import '../main.dart';

import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _vpnState = VpnEngine.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;
  final RxBool _startTimer = false.obs;
  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      setState(() => _vpnState = event);
    });

    initVpn();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
        country: 'Thailand',
        username: 'vpn',
        password: 'vpn'));

    SchedulerBinding.instance.addPostFrameCallback(
        (t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(
          CupertinoIcons.home,
          color: Colors.white,
        ),
        title: const Text(
          'Nomad Net Shield',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.brightness,
              color: Colors.white,
              size: 26,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 8),
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.info_circle,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _changeLocation(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // VPN Button
          _vpnButton(),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                title: 'Country',
                subtitle: 'FREE',
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: Icon(
                    Icons.vpn_lock,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              HomeCard(
                title: '0 ms',
                subtitle: 'PING',
                icon: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 30,
                  child: Icon(
                    Icons.bar_chart,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                title: '0 kbps',
                subtitle: 'DOWNLOAD',
                icon: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 30,
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              HomeCard(
                title: '0 kbps',
                subtitle: 'UPLOAD',
                icon: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 30,
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_vpnState == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  // VPN Button
  Widget _vpnButton() => Column(
        children: [
          // Button
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _startTimer.value = !_startTimer.value;
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(.1),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.3),
                  ),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.power,
                          size: 28,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap to Connect',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Connection Status Label
          Container(
            margin: EdgeInsets.only(
              top: mq.height * .015,
              bottom: mq.height * .02,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Not Connected',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ),
          // Countdown Timer
          Obx(
            () => CountDownTimer(startTimer: _startTimer.value),
          ),
        ],
      );
}

Widget _changeLocation() => SafeArea(
      child: Semantics(
        child: InkWell(
          onTap: () => Get.to(
            () => const LocationScreen(),
          ),
          child: Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
            height: 60,
            child: const Row(
              children: [
                Icon(
                  CupertinoIcons.globe,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Change Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Colors.blue,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


// !Future work
// Center(
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 backgroundColor: Theme.of(context).primaryColor,
//               ),
//               onPressed: _connectClick,
//               child: Text(
//                 _vpnState == VpnEngine.vpnDisconnected
//                     ? 'Connect VPN'
//                     : _vpnState.replaceAll("_", " ").toUpperCase(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           StreamBuilder<VpnStatus?>(
//             initialData: VpnStatus(),
//             stream: VpnEngine.vpnStatusSnapshot(),
//             builder: (context, snapshot) => Text(
//               "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
//               textAlign: TextAlign.center,
//             ),
//           ),

//           //sample vpn list
//           Column(
//             children: _listVpn
//                 .map(
//                   (e) => ListTile(
//                     title: Text(e.country),
//                     leading: SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: Center(
//                           child: _selectedVpn == e
//                               ? const CircleAvatar(
//                                   backgroundColor: Colors.green)
//                               : const CircleAvatar(
//                                   backgroundColor: Colors.grey)),
//                     ),
//                     onTap: () {
//                       log("${e.country} is selected");
//                       setState(() => _selectedVpn = e);
//                     },
//                   ),
//                 )
//                 .toList(),
//           )