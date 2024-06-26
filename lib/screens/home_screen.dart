import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:nomadnetshield/screens/location_screen.dart';
import 'package:nomadnetshield/widgets/count_down_timer.dart';
import 'package:nomadnetshield/widgets/home_card.dart';
import '../controllers/home_controller.dart';
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
  final _controller = Get.put(HomeController());
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen(
      (event) {
        _controller.vpnState.value = event;
      },
    );

    initVpn();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          Obx(
            () => _vpnButton(),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : _controller.vpn.value.countryLong,
                  subtitle: 'FREE',
                  icon: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                          ),
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? const Icon(
                            Icons.vpn_lock,
                            color: Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                ),
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? '0 ms'
                      : '${_controller.vpn.value.ping} ms',
                  subtitle: 'PING',
                  icon: const CircleAvatar(
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
          ),
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeCard(
                  title: snapshot.data?.byteIn ?? '0 kbps',
                  subtitle: 'DOWNLOAD',
                  icon: const CircleAvatar(
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
                  title: snapshot.data?.byteOut ?? '0 kbps',
                  subtitle: 'UPLOAD',
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
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
          ),
        ],
      ),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_controller.vpnState.value == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      _controller.startTimer.value = !_controller.startTimer.value;

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
                _connectClick();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.getButtonColor.withOpacity(.1),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.3),
                  ),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.power,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _controller.getButtonText,
                          style: const TextStyle(
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
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', '').toUpperCase(),
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ),
          // Countdown Timer
          Obx(
            () => CountDownTimer(startTimer: _controller.startTimer.value),
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
//                 _controller.vpnState.value == VpnEngine.vpnDisconnected
//                     ? 'Connect VPN'
//                     : _controller.vpnState.value.replaceAll("_", " ").toUpperCase(),
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