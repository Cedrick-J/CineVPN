import 'package:cinevpn/logic/vpnengine.dart';
import 'package:cinevpn/logic/vpnservers.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.fromLTRB(50, 30, 30, 0),
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