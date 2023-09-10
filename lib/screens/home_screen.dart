import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:share_plus/share_plus.dart' as share_plus;

import 'package:cinevpn/logic/vpnengine.dart';
import 'package:cinevpn/logic/vpnservers.dart';
import 'package:cinevpn/screens/change_language.dart';
import 'package:cinevpn/screens/server_location.dart';
import 'package:cinevpn/logic/default_vpn_server.dart';

const kBgColor = Color(0xff246CE2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final VpnEngine vpnEngine = VpnEngine();
  VpnGateVPNServer _vpnServer = defaultServer;
  @override
  void initState() {
    super.initState();
    vpnEngine.initialise(updateState: (Function updateState) {
      setState(() {
        updateState();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: myAppBar(),
      backgroundColor: kBgColor,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.4,
              child: Column(
                children: [
                  /// header action icons
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: InkWell(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: const Icon(
                              Icons.segment,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.electric_bolt,
                              color: Colors.orangeAccent,
                              size: 22,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'CineVPN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: kBgColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(size.height),
                            onTap: () {
                              // Connected or disconnect engine according to current state
                              vpnEngine.isConnected()
                                  ? vpnEngine.disconnect()
                                  : vpnEngine.connectTo(
                                      vpnConfiguration: utf8.decode(
                                          base64.decode(
                                              _vpnServer.openVpnBase64Config)),
                                      vpnConfigurationName:
                                          _vpnServer.countryLong,
                                      vpnUsername: defaultVpnUsername,
                                      vpnPassword: defaultVpnPassword);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  width: size.height * 0.12,
                                  height: size.height * 0.12,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.power_settings_new,
                                          size: size.height * 0.035,
                                          color: kBgColor,
                                        ),
                                        Text(
                                          vpnEngine.isConnected()
                                              ? 'Disconnect'
                                              : 'Tap to Connect',
                                          style: TextStyle(
                                            fontSize: size.height * 0.013,
                                            fontWeight: FontWeight.w500,
                                            color: kBgColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 120,
                                //  width: 120 vpnEngine.isConnected()
                                //     ? 90
                                //     : size.height * 0.14,
                                height: size.height * 0.030,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  vpnEngine.currentVpnStatus,
                                  style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color: kBgColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.012,
                              ),
                              _countDownWidget(size),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Platform.isIOS ? size.height * 0.51 : size.height * 0.565,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
              ),
              child: Column(
                children: [
                  /// horizontal line
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xffB4B4C7),
                        borderRadius: BorderRadius.circular(3)),
                    height: size.height * 0.005,
                    width: 35,
                  ),

                  /// Connection Information
                  ConnectionInformation(
                      size: size, vpnServer: _vpnServer, vpnEngine: vpnEngine),
                  // Connection information
                  Material(
                    color: kBgColor,
                    child: InkWell(
                      onTap: () async {
                        final screenReturnData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ServerLocation()));
                        screenReturnData.runtimeType == VpnGateVPNServer
                            ? setState(() => _vpnServer = screenReturnData)
                            : null;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Change Location',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 25,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 25,
                                color: kBgColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countDownWidget(Size size) {
    developer.log(vpnEngine.status?.toJson().toString() ?? 'null');
    return Text(
      // '$hours : $minutes : $seconds',
      vpnEngine.status != null
          ? vpnEngine.status!.duration.toString().split('.').last.toUpperCase()
          : '00:00:00',
      style: TextStyle(color: Colors.white, fontSize: size.height * 0.03),
    );
  }
}

class ConnectionInformation extends StatelessWidget {
  const ConnectionInformation({
    super.key,
    required this.size,
    required VpnGateVPNServer vpnServer,
    required this.vpnEngine,
  }) : _vpnServer = vpnServer;

  final Size size;
  final VpnGateVPNServer _vpnServer;
  final VpnEngine vpnEngine;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        padding: const EdgeInsets.fromLTRB(30, 30, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.height * 0.07,
                          height: size.height * 0.07,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage(_vpnServer.flagImageSrc),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              _vpnServer.countryShort,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 22,
                              width: 90,
                              decoration: BoxDecoration(
                                color: const Color(0xffFEF7F0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // According to _vpnServer.isFree
                              child: Text(
                                _vpnServer.isFree ? 'Free' : 'Premium',
                                style: TextStyle(
                                    color: _vpnServer.isFree
                                        ? Colors.orange
                                        : Colors.blueAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          _vpnServer.countryLong,
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.height * 0.07,
                          height: size.height * 0.07,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.equalizer_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vpnEngine.currentSpeedAndPing.speed,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            // const Text(
                            //   ' ms',
                            //   style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w500),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'SPEED',
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.height * 0.07,
                            height: size.height * 0.07,
                            decoration: const BoxDecoration(
                              color: Color(0xff20C4F8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                vpnEngine.currentSpeedAndPing.downloaded,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              // const Text(
                              //   ' mbps',
                              //   style: TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w500),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'DOWNLOAD',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.height * 0.07,
                            height: size.height * 0.07,
                            decoration: const BoxDecoration(
                              color: Color(0xff8220F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                vpnEngine.currentSpeedAndPing.uploaded,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              // const Text(
                              //   ' mbps',
                              //   style: TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w500),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'UPLOAD',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSize myAppBar() {
  return PreferredSize(
    preferredSize: Size.zero,
    child: AppBar(
      elevation: 0,
      backgroundColor: kBgColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kBgColor,
        statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
        statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
      ),
    ),
  );
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.electric_bolt,
                  color: Colors.orangeAccent,
                  size: 26,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'CineVPN',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kBgColor,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangeLanguage()));
            },
            leading: const Icon(
              Icons.translate,
              size: 18,
            ),
            title: const Text(
              'Change Language',
              style: TextStyle(fontSize: 14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.rate_review,
              size: 18,
            ),
            title: Text(
              'Rate US',
              style: TextStyle(fontSize: 14),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          ListTile(
            onTap: () => share_plus.Share.share(
                "Check out this App. Let's you access the internet as you wish.\nhttps://apps.habertech.info/2023/09/cinevpn.html",
                subject: "Cine VPN best internet access"),
            leading: const Icon(
              Icons.share,
              size: 18,
            ),
            title: const Text(
              'Share App',
              style: TextStyle(fontSize: 14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          ListTile(
            onTap: () => url_launcher.launchUrl(
                Uri.parse('https://apps.habertech.info/2023/09/cinevpn.html')),
            leading: const Icon(
              Icons.info,
              size: 18,
            ),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          // About Section
          ListTile(
            title: Row(
              children: [
                const Text('  Built by ', style: TextStyle(fontSize: 14)),
                GestureDetector(
                  onTap: () => url_launcher.launchUrl(
                      Uri.parse('https://www.instagram.com/cedrick__j')),
                  child: const Text(
                    'Cedrick J ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBgColor,
                    ),
                  ),
                ),
                const Text('for ', style: TextStyle(fontSize: 14)),
                GestureDetector(
                  onTap: () => url_launcher
                      .launchUrl(Uri.parse('https://www.habertech.info')),
                  child: const Text(
                    'HaberTech ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kBgColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // My About Section
        ],
      ),
    );
  }
}

const String defaultVpnUsername = "vpn";
const String defaultVpnPassword = "vpn";
