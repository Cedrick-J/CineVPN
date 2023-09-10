import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'dart:developer' as developer;

class VpnEngine {
  late OpenVPN _engine;
  VpnStatus? status;
  VPNStage? _stage;
  bool _granted = false;

  final VpnEngineSpeedAndPing _vpnSpeed =
      VpnEngineSpeedAndPing(uploaded: '0', downloaded: '0', speed: '0');

  late Function _onStateUpdate;

  void initialise({required Function updateState}) {
    // Edit the onUpdate setup
    _onStateUpdate = updateState;
    _engine = OpenVPN(
      onVpnStatusChanged: (data) {
        _onStateUpdate(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        _onStateUpdate(() {
          _stage = data;
        });
      },
    );

    _engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "CineVPN by HaberTech",
      lastStage: (stage) {
        _onStateUpdate(() {
          _stage = stage;
        });
      },
      lastStatus: (status) {
        _onStateUpdate(() {
          status = status;
        });
      },
    );
  }

//Launch the VPN Connection
  Future<void> connectTo(
      {required String vpnConfiguration,
      required String vpnConfigurationName,
      required String vpnUsername,
      required String vpnPassword}) async {
    // Get Android VPN permission
    _engine.requestPermissionAndroid().then((value) => _granted = value);
    // Now connect to the VPN
    _engine.connect(
      vpnConfiguration,
      vpnConfigurationName,
      username: vpnUsername,
      password: vpnPassword,
      certIsRequired: true,
    );
    // if (!mounted) return;
  }

//Disconnect the VPN Connection
  Future<void> disconnect() async {
    _engine.disconnect();
  }

  bool isConnected() {
    bool isConnected =
        _stage.toString() == VPNStage.connected.toString() ? true : false;
    return isConnected;
  }

// Speed and ping calculator
  VpnEngineSpeedAndPing get currentSpeedAndPing {
    final VpnStatus currentStatus = status!;
    if (currentStatus.connectedOn == null ||
        currentStatus.byteIn == '0' ||
        currentStatus.byteOut == '0') {
      // VPN is not connected
      return _vpnSpeed;
    } else {
      // Return the stuff
      return VpnEngineSpeedAndPing(
          // Status =  {'connected_on': 2023-09-02 18:47:09.241289, 'duration': 00:00:52, 'byte_in': ↓56.8 kB - 2.1 kB/s, 'byte_out': ↑38.0 kB - 607 B/s, 'packets_in': ↓56.8 kB - 2.1 kB/s, 'packets_out': ↑38.0 kB - 607 B/s}
          // Substring Bytes in by '-'
          uploaded: currentStatus.byteOut!.split('-')[0],
          downloaded: currentStatus.byteIn!.split('-')[0],
          speed: currentStatus.byteIn!.split('-')[1]);
    }
  }

// VPN Status is human readable format
  String _currentVpnStatus() {
    developer.log(_stage.toString());
    // // Add null check
    if (_stage == null) {
      return "Disconnected";
    } else {
      // return _stage.toString().substring(10);
      return _stage.toString().replaceAll('VPNStage.', '');
    }
  }

  // Getter to check for android VPN permission
  bool get androidVpnPermissionGranted => _granted;
  // Getter to check for VPN connection status
  // get isConnected => isConnected();
  // Getter to check for VPN connection status
  String get currentVpnStatus => _currentVpnStatus();
}

class VpnEngineSpeedAndPing {
  final String uploaded;
  final String downloaded;
  final String speed;

  VpnEngineSpeedAndPing({
    required this.uploaded,
    required this.downloaded,
    required this.speed,
  });
}
