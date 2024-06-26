class Vpn {
  Vpn({
    required this.hostName,
    required this.iP,
    required this.score,
    required this.ping,
    required this.speed,
    required this.countryLong,
    required this.countryShort,
    required this.numVpnSessions,
    required this.uptime,
    required this.totalUsers,
    required this.totalTraffic,
    required this.logType,
    required this.operator,
    required this.message,
    required this.openVPNConfigDataBase64,
  });
  late final String hostName;
  late final String iP;
  late final int score;
  late final String ping;
  late final int speed;
  late final String countryLong;
  late final String countryShort;
  late final int numVpnSessions;
  late final int uptime;
  late final int totalUsers;
  late final int totalTraffic;
  late final String logType;
  late final String operator;
  late final String message;
  late final String openVPNConfigDataBase64;

  Vpn.fromJson(Map<String, dynamic> json) {
    hostName = json['HostName'] ?? '';
    iP = json['IP'] ?? '';
    score = json['Score']?? 0;
    ping = json['Ping'].toString();
    speed = json['Speed']?? 0;
    countryLong = json['CountryLong']?? '';
    countryShort = json['CountryShort']?? '';
    numVpnSessions = json['NumVpnSessions']?? '';
    uptime = json['Uptime']?? '';
    totalUsers = json['TotalUsers']?? '';
    totalTraffic = json['TotalTraffic']?? '';
    logType = json['LogType']?? '';
    operator = json['Operator']?? '';
    message = json['Message']?? '';
    openVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64']?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['HostName'] = hostName;
    _data['IP'] = iP;
    _data['Score'] = score;
    _data['Ping'] = ping;
    _data['Speed'] = speed;
    _data['CountryLong'] = countryLong;
    _data['CountryShort'] = countryShort;
    _data['NumVpnSessions'] = numVpnSessions;
    _data['Uptime'] = uptime;
    _data['TotalUsers'] = totalUsers;
    _data['TotalTraffic'] = totalTraffic;
    _data['LogType'] = logType;
    _data['Operator'] = operator;
    _data['Message'] = message;
    _data['OpenVPN_ConfigData_Base64'] = openVPNConfigDataBase64;
    return _data;
  }
}
