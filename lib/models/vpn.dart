class Vpn {
  late final String hostName;
  late final String iP;
  late final String ping;
  late final int speed;
  late final String countryLong;
  late final String countryShort;
  late final int numVpnSessions;
  late final String openVPNConfigDataBase64;

  Vpn({
    required this.hostName,
    required this.iP,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.openVPNConfigDataBase64,
  });

  Vpn.fromJson(Map<String, dynamic> json) {
    hostName = json['HostName'] ?? '';
    iP = json['IP'] ?? '';
    ping = json['Ping'].toString();
    speed = json['Speed'] ?? 0;
    countryLong = json['CountryLong'] ?? '';
    countryShort = json['CountryShort'] ?? '';
    numVpnSessions = json['NumVpnSessions'] ?? 0;

    openVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HostName'] = hostName;
    data['IP'] = iP;
    data['Ping'] = ping;
    data['Speed'] = speed;
    data['CountryLong'] = countryLong;
    data['CountryShort'] = countryShort;
    data['NumVpnSessions'] = numVpnSessions;
    data['OpenVPN_ConfigData_Base64'] = openVPNConfigDataBase64;
    return data;
  }
}
