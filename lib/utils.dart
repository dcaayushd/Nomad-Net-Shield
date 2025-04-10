import 'package:flutter/material.dart';

const bgColor = Color(0XFF021B3A);

const curveGradient = RadialGradient(
  colors: <Color>[
    Color(0XFF313F70),
    Color(0XFF203063),
  ],
  focalRadius: 16,
);

const vpnStyle = TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontSize: 34,
);

const txtSpeedStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 15,
  color: Color(0XFF6B81BD),
);

const greenGradient = LinearGradient(
  colors: <Color>[
    Color(0XFF00D58D),
    Color(0XFF00C2A0),
  ],
);
const redGradient = LinearGradient(
  colors: <Color>[
    Color.fromARGB(255, 231, 29, 29),
    Color(0XFF00C2A0),
  ],
);

const connectedStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  height: 1.6,
  color: Colors.white,
);
const connectedGreenStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Colors.greenAccent,
);
const disconnectedRedStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: Colors.redAccent,
);
const connectedSubtitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
const locationTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0XFF9BB1BD),
);
