import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;
import 'package:cinevpn/sdk/load_internet_requests.dart';

final List<VpnGateVPNServer> servers = [];

Future<List<VpnGateVPNServer>> getVPNServers() async {
  final stopwatch = Stopwatch()..start();
  final HaberHttpFetchResponse response = await HaberHttpFetch(
          url: Uri.parse("https://www.vpngate.net/api/iphone/"),
          cacheKey: 'vpnServers')
      .fetchData();
  if (response.wasSuccessful) {
    response.loadedFromCache
        ? developer.log('Loaded from cache')
        : developer.log('Loaded from server');
    final List<String> lines = const LineSplitter().convert(response.data);
    for (var line in lines) {
      final List<String> fields = line.split(',');
      if (line.startsWith('*') || line.startsWith('#') || fields.length < 15) {
        continue; // Skip this line
      }

      String hostName = fields[0];
      String ip = fields[1];
      int score = int.parse(fields[2]);
      int ping = fields[3] != '-'
          ? int.parse(fields[3])
          : 50; // Get ping if it's not "-"
      double speed = double.parse(fields[4]);
      String countryLong = fields[5];
      String countryShort = fields[6];
      int numVpnSessions = int.parse(fields[7]);
      String uptime = fields[8];
      int totalUsers = int.parse(fields[9]);
      double totalTraffic = double.parse(fields[10]);
      String logType = fields[11];
      String operator = fields[12];
      String message = fields[13];
      String openVpnBase64Config = fields[14];

      // Find if supoorts UDP or TCP
      final List<String> configLines =
          utf8.decode(base64.decode(openVpnBase64Config)).split('\n');
      final bool supportsUdp =
          configLines.any((line) => line.startsWith('proto udp'));

      // Do something with the parsed values
      final vpnServer = VpnGateVPNServer(
        hostName: hostName,
        ip: ip,
        score: score,
        ping: ping,
        speed: speed,
        countryLong: countryLong,
        countryShort: countryShort,
        numVpnSessions: numVpnSessions,
        uptime: uptime,
        totalUsers: totalUsers,
        totalTraffic: totalTraffic,
        logType: logType,
        operator: operator,
        message: message,
        openVpnBase64Config: openVpnBase64Config,
        supportsUdp: supportsUdp,
      );
      servers.add(vpnServer);

      // Sort server by those that supoort UDP first and then by ping and then by country name
      servers.sort((a, b) {
        if (a.supportsUdp && !b.supportsUdp) {
          return -1;
        } else if (!a.supportsUdp && b.supportsUdp) {
          return 1;
        } else if (a.supportsUdp && b.supportsUdp ||
            !a.supportsUdp && !b.supportsUdp) {
          if (a.supportsUdp && b.supportsUdp) {
            return a.ping.compareTo(b.ping);
          } else {
            return a.ping.compareTo(b.ping);
          }
        } else {
          return a.countryLong.compareTo(b.countryLong);
        }
      });
    }
  }
  if (response.loadedFromCache == true) {
    developer.log(response.error!);
    developer.log(response.httpErrorCode != null
        ? response.httpErrorCode.toString()
        : 'No error code');
  }
  stopwatch.stop();
  // Print the milliseconds elapsed.
  developer.log('getVPNServers executed in ${stopwatch.elapsed}');
  return servers;
}

class VpnGateVPNServer {
  final String hostName;
  final String ip;
  final int score;
  final int ping;
  final double speed;
  final String countryLong;
  final String countryShort;
  final int numVpnSessions;
  final String uptime;
  final int totalUsers;
  final double totalTraffic;
  final String logType;
  final String operator;
  final String message;
  final String openVpnBase64Config;
  final bool supportsUdp;
  // Random either true or false
  final bool isFree = math.Random().nextBool();
  // Random number between 3 and 11
  final int noOfLocations = math.Random().nextInt(11 - 3) + 3;
  // // Late Flag image
  String flagImageSrc = 'assets/images/country_flags/countrylong.png';

  VpnGateVPNServer({
    required this.hostName,
    required this.ip,
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
    required this.openVpnBase64Config,
    required this.supportsUdp,
  });

  factory VpnGateVPNServer.fromJson(Map<String, dynamic> json) {
    return VpnGateVPNServer(
      hostName: json['host_name'],
      ip: json['ip'],
      score: json['score'],
      ping: json['ping'],
      speed: json['speed'],
      countryLong: json['country_long'],
      countryShort: json['country_short'],
      numVpnSessions: json['num_vpn_sessions'],
      uptime: json['uptime'],
      totalUsers: json['total_users'],
      totalTraffic: json['total_traffic'],
      logType: json['log_type'],
      operator: json['operator'],
      message: json['message'],
      openVpnBase64Config: json['openvpn_config_data'],
      supportsUdp: json['supports_udp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host_name': hostName,
      'ip': ip,
      'score': score,
      'ping': ping,
      'speed': speed,
      'country_long': countryLong,
      'country_short': countryShort,
      'num_vpn_sessions': numVpnSessions,
      'uptime': uptime,
      'total_users': totalUsers,
      'total_traffic': totalTraffic,
      'log_type': logType,
      'operator': operator,
      'message': message,
      'openvpn_config_data': openVpnBase64Config,
    };
  }

  @override
  String toString() {
    return 'VpnGateVPNServer{hostName: $hostName, ip: $ip, score: $score, ping: $ping, speed: $speed, countryLong: $countryLong, countryShort: $countryShort, numVpnSessions: $numVpnSessions, uptime: $uptime, totalUsers: $totalUsers, totalTraffic: $totalTraffic, logType: $logType, operator: $operator, message: $message, openVpnBase64Config: $openVpnBase64Config, supportsUdp: $supportsUdp, isFree: $isFree, noOfLocations: $noOfLocations, flagImageSrc: $flagImageSrc}';
  }
}
