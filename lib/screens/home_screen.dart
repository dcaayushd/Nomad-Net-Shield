// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import '../helpers/pref.dart';
// import '../screens/location_screen.dart';
// import '../screens/network_test_screen.dart';
// import '../widgets/count_down_timer.dart';
// import '../widgets/home_card.dart';
// import '../controllers/home_controller.dart';
// import '../main.dart';
// import '../models/vpn_status.dart';
// import '../services/vpn_engine.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final _controller = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     ///Add listener to update vpn state
//     VpnEngine.vpnStageSnapshot().listen(
//       (event) {
//         _controller.vpnState.value = event;
//       },
//     );
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Nomad Net Shield',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Get.changeThemeMode(
//                 Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark,
//               );
//               Pref.isDarkMode = !Pref.isDarkMode;
//             },
//             icon: Icon(
//               Pref.isDarkMode ? CupertinoIcons.brightness : CupertinoIcons.moon,
//               color: Colors.white,
//               size: 26,
//             ),
//           ),
//           IconButton(
//             padding: const EdgeInsets.only(right: 8),
//             onPressed: () => Get.to(
//               () => const NetworkTestScreen(),
//             ),
//             icon: const Icon(
//               CupertinoIcons.info_circle,
//               color: Colors.white,
//               size: 26,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _changeLocation(context),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // VPN Button
//           Obx(
//             () => _vpnButton(),
//           ),
//           Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 HomeCard(
//                   title: _controller.vpn.value.countryLong.isEmpty
//                       ? 'Country'
//                       : _controller.vpn.value.countryLong,
//                   subtitle: 'FREE',
//                   icon: CircleAvatar(
//                     backgroundColor: const Color(0XFF021B3A),
//                     radius: 30,
//                     backgroundImage: _controller.vpn.value.countryLong.isEmpty
//                         ? null
//                         : AssetImage(
//                             'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
//                           ),
//                     child: _controller.vpn.value.countryLong.isEmpty
//                         ? const Icon(
//                             Icons.vpn_lock,
//                             color: Colors.white,
//                             size: 30,
//                           )
//                         : null,
//                   ),
//                 ),
//                 HomeCard(
//                   title: _controller.vpn.value.countryLong.isEmpty
//                       ? '0 ms'
//                       : '${_controller.vpn.value.ping} ms',
//                   subtitle: 'PING',
//                   icon: const CircleAvatar(
//                     backgroundColor: Colors.orange,
//                     radius: 30,
//                     child: Icon(
//                       Icons.bar_chart,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           StreamBuilder<VpnStatus?>(
//             initialData: VpnStatus(),
//             stream: VpnEngine.vpnStatusSnapshot(),
//             builder: (context, snapshot) => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 HomeCard(
//                   title: snapshot.data?.byteIn ?? '0 kbps',
//                   subtitle: 'DOWNLOAD',
//                   icon: const CircleAvatar(
//                     backgroundColor: Colors.green,
//                     radius: 30,
//                     child: Icon(
//                       Icons.arrow_downward,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//                 HomeCard(
//                   title: snapshot.data?.byteOut ?? '0 kbps',
//                   subtitle: 'UPLOAD',
//                   icon: const CircleAvatar(
//                     backgroundColor: Color(0XFF021B3A),
//                     radius: 30,
//                     child: Icon(
//                       Icons.arrow_upward,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // VPN Button
//   Widget _vpnButton() => Column(
//         children: [
//           // Button
//           Semantics(
//             button: true,
//             child: InkWell(
//               onTap: () {
//                 _controller.connectToVpn();
//               },
//               borderRadius: BorderRadius.circular(100),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _controller.getButtonColor.withOpacity(.1),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _controller.getButtonColor.withOpacity(.3),
//                   ),
//                   child: Container(
//                     width: mq.height * .14,
//                     height: mq.height * .14,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _controller.getButtonColor,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           CupertinoIcons.power,
//                           size: 28,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           _controller.getButtonText,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12.5,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Connection Status Label
//           Container(
//             margin: EdgeInsets.only(
//               top: mq.height * .015,
//               bottom: mq.height * .02,
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 6,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0XFF021B3A),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Text(
//               _controller.vpnState.value == VpnEngine.vpnDisconnected
//                   ? 'Not Connected'
//                   : _controller.vpnState.replaceAll('_', '').toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 12.5,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           // Countdown Timer
//           Obx(
//             () => CountDownTimer(
//               startTimer: _controller.vpnState.value == VpnEngine.vpnConnected,
//             ),
//           ),
//         ],
//       );
// }

// Widget _changeLocation(BuildContext context) => SafeArea(
//       child: Semantics(
//         child: InkWell(
//           onTap: () => Get.to(
//             () => LocationScreen(),
//           ),
//           child: Container(
//             color: Theme.of(context).bottomNav,
//             padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
//             height: 60,
//             child: Row(
//               children: [
//                 const Icon(
//                   CupertinoIcons.globe,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   'Change Location',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const Spacer(),
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.keyboard_arrow_right_rounded,
//                     color: Pref.isDarkMode
//                         ? const Color(0xFF0D0F14)
//                         : const Color(0XFF021B3A),
//                     size: 26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/location_screen.dart';
import '../screens/network_test_screen.dart';
import '../utils.dart';
import '../controllers/home_controller.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import '../widgets/home_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen(
      (event) {
        _controller.vpnState.value = event;
      },
    );

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              upperCurvedContainer(context),
              circularButtonWidget(context, screenWidth),
            ],
          ),
          SizedBox(height: screenWidth * 0.40),
          Obx(() => connectedStatusText()),
          const SizedBox(height: 20),
          Obx(() => locationCard(
              'Current Location',
              Colors.transparent,
              'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
              _controller.vpn.value.countryLong)),
          const SizedBox(height: 20),
          locationCard('Select Location', Colors.indigo[100],
              'assets/flags/default.png', 'Tap to change'),
          const SizedBox(height: 20),
          // _vpnStatusCards(),
        ],
      ),
    );
  }

  Widget upperCurvedContainer(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        height: 320,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: curveGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _topRow(),
            const Text('Nomad Net Shield', style: vpnStyle),
            _bottomRow(),
          ],
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 12),
              Text(
                'Go Premium',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () => Get.to(() => const NetworkTestScreen()),
          icon: const Icon(CupertinoIcons.info_circle, color: Colors.white, size: 26),
        ),
      ],
    );
  }

  Widget _bottomRow() {
    return StreamBuilder<VpnStatus?>(
      initialData: VpnStatus(),
      stream: VpnEngine.vpnStatusSnapshot(),
      builder: (context, snapshot) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Upload\n${snapshot.data?.byteOut ?? '0 kbps'}',
            style: txtSpeedStyle,
          ),
          Text(
            'Download\n${snapshot.data?.byteIn ?? '0 kbps'}',
            style: txtSpeedStyle,
          ),
        ],
      ),
    );
  }

  Widget circularButtonWidget(BuildContext context, width) {
    return Positioned(
      bottom: -width * 0.36,
      child: Obx(
        () => GestureDetector(
          onTap: () => _controller.connectToVpn(),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: width * 0.51,
                width: width * 0.51,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: curveGradient,
                ),
                child: Center(
                  child: Container(
                    height: width * 0.4,
                    width: width * 0.4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor,
                    ),
                    child: Center(
                      child: Container(
                        height: width * 0.3,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _controller.getButtonColor == Colors.green
                              ? greenGradient
                              : redGradient,
                          boxShadow: [
                            BoxShadow(
                              color: _controller.getButtonColor.withOpacity(.2),
                              spreadRadius: 15,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _controller.getButtonColor == Colors.green
                                ? Icons.wifi_lock
                                : Icons.power_settings_new,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 30,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration:
                      const BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                      ),
                      radius: 40,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget connectedStatusText() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Status: ',
          style: connectedStyle,
          children: [
            TextSpan(
              text:
                  ' ${_controller.vpnState.value == VpnEngine.vpnDisconnected ? 'Disconnected' : _controller.vpnState.replaceAll('_', ' ')}\n',
              style: _controller.vpnState.value == VpnEngine.vpnConnected
                  ? connectedGreenStyle
                  : disconnectedRedStyle,
            ),
            TextSpan(
              text: _controller.vpnState.value == VpnEngine.vpnConnected
                  ? '00:22:45'
                  : '',
              style: connectedSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget locationCard(title, cardBgColor, flag, country) {
    return GestureDetector(
      onTap: () => Get.to(() => LocationScreen()),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: locationTitleStyle),
            const SizedBox(height: 14.0),
            Container(
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBgColor,
                border: Border.all(
                  color: const Color(0XFF9BB1BD),
                  style: BorderStyle.solid,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    backgroundImage: AssetImage(flag),
                  ),
                  title: Text(
                    country,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    size: 28,
                    color: Colors.white70,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _vpnStatusCards() {
    return StreamBuilder<VpnStatus?>(
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
              backgroundColor: Color(0XFF021B3A),
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
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



