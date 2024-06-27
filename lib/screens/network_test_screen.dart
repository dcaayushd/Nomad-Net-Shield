import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

import '../models/network_data.dart';
import '../widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Info'),
      ),

      //refresh button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
          right: 10,
        ),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).bottomNav,
          onPressed: () {},
          child: const Icon(
            CupertinoIcons.refresh,
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: mq.width * .04,
          right: mq.width * .04,
          top: mq.height * .01,
          bottom: mq.height * .1,
        ),
        children: [
          NetworkCard(
            // IP
            data: NetworkData(
              title: 'IP Address',
              subtitle: 'NotAvailable',
              icon: const Icon(
                CupertinoIcons.location_solid,
                color: Colors.blue,
              ),
            ),
          ),

          // Isp
          NetworkCard(
            data: NetworkData(
              title: 'Internet Provider',
              subtitle: 'Unknown',
              icon: const Icon(
                Icons.business,
                color: Colors.orange,
              ),
            ),
          ),

          // Location
          NetworkCard(
            data: NetworkData(
              title: 'Location',
              subtitle: 'Fetching ...',
              icon: const Icon(
                CupertinoIcons.location,
                color: Colors.pink,
              ),
            ),
          ),

          // Pin code
          NetworkCard(
            data: NetworkData(
              title: 'Pin-code',
              subtitle: '- - - -',
              icon: const Icon(
                CupertinoIcons.location_solid,
                color: Colors.cyan,
              ),
            ),
          ),

          // Timezone
          NetworkCard(
            data: NetworkData(
              title: 'Timezone',
              subtitle: 'Unknown',
              icon: const Icon(CupertinoIcons.time, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
