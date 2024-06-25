import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:nomadnetshield/main.dart';

import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _vpnState = VpnEngine.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

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
        leading: Icon(CupertinoIcons.home),
        title: Text('Nomad Net Shield'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.brightness,
              size: 26,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 8),
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.info_circle,
              size: 26,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: mq.height * .02),

          // VPN Button
          _vpnButton(),

          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                _vpnState == VpnEngine.vpnDisconnected
                    ? 'Connect VPN'
                    : _vpnState.replaceAll("_", " ").toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _connectClick,
            ),
          ),
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Text(
              "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
              textAlign: TextAlign.center,
            ),
          ),

          //sample vpn list
          Column(
            children: _listVpn
                .map(
                  (e) => ListTile(
                    title: Text(e.country),
                    leading: SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                          child: _selectedVpn == e
                              ? CircleAvatar(backgroundColor: Colors.green)
                              : CircleAvatar(backgroundColor: Colors.grey)),
                    ),
                    onTap: () {
                      log("${e.country} is selected");
                      setState(() => _selectedVpn = e);
                    },
                  ),
                )
                .toList(),
          )
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
              onTap: () {},
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(.1),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.3),
                  ),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Column(
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
            margin: EdgeInsets.only(top: mq.height * .015),
            padding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Disconnect',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
