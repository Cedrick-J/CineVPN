import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WireGuard Example App'),
        ),
        body: const WireguardApp(),
      ),
    ),
  );
}

class WireguardApp extends StatefulWidget {
  const WireguardApp({super.key});

  @override
  State<WireguardApp> createState() => _WireguardAppState();
}

class _WireguardAppState extends State<WireguardApp> {
  final wireguard = WireGuardFlutter.instance;

  late String name;

  @override
  void initState() {
    super.initState();
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('status changed: $event'),
        ));
      }
    });
    name = 'my_wg_vpn';
  }

  Future<void> initialize() async {
    try {
      await wireguard.initialize(interfaceName: name);
      debugPrint("initialize success $name");
    } catch (error, stack) {
      debugPrint("failed to initialize: $error\n$stack");
    }
  }

  void startVpn() async {
    try {
      await wireguard.startVpn(
        serverAddress: '167.235.55.239:51820',
        wgQuickConfig: conf,
        providerBundleIdentifier: 'com.billion.wireguardvpn.WGExtension',
      );
    } catch (error, stack) {
      debugPrint("failed to start $error\n$stack");
    }
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  void getStatus() async {
    debugPrint("getting stage");
    final stage = await wireguard.stage();
    debugPrint("stage: $stage");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('stage: $stage'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TextButton(
            onPressed: initialize,
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all<Size>(const Size(100, 50)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blueAccent),
                overlayColor: WidgetStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1))),
            child: const Text(
              'initialize',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: startVpn,
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all<Size>(const Size(100, 50)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blueAccent),
                overlayColor: WidgetStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1))),
            child: const Text(
              'Connect',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: disconnect,
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all<Size>(const Size(100, 50)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blueAccent),
                overlayColor: WidgetStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1))),
            child: const Text(
              'Disconnect',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: getStatus,
            style: ButtonStyle(
                minimumSize:
                    WidgetStateProperty.all<Size>(const Size(100, 50)),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blueAccent),
                overlayColor: WidgetStateProperty.all<Color>(
                    Colors.white.withOpacity(0.1))),
            child: const Text(
              'Get status',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

const String conf = '''

[Interface]
PrivateKey = qOp4IomBn+WDQ/4ik31sJIZQ5P4r16KdVT8aPNkFx2U=
Address = 172.16.0.2/32, 2606:4700:110:8d85:d3e0:4530:9cf2:d4e5/128
# DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001 #Cloudflare
DNS = 94.140.14.14, 94.140.15.15, 2a10:50c0::ad1:ff, 2a10:50c0::ad2:ff #
MTU = 1280
[Peer]
PublicKey = bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = engage.cloudflareclient.com:2408

''';