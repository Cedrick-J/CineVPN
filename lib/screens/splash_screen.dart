import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinevpn/screens/home_screen.dart';

import 'package:cinevpn/sdk/habersdk.dart';
import 'package:cinevpn/sdk/appconfig.dart' show config;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void moveToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void initialiseApp() async {
    bool success;
    final prefs = await SharedPreferences.getInstance();
    // Check if has internet
    try {
      await InternetAddress.lookup('google.com');
      success = true;
    } catch (e) {
      success = false;
    }
    if ((success) // Has Internet
            ||
            (prefs.getString('vpnServers') != null &&
                prefs.getString('appConfig') != null) // Has stored Data
        ) {
      final HaberApp app = HaberApp(config: config);
      await app.initialise();
      if (context.mounted) {
        await checkForUpdate(app, context, moveToHome);
      }
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('No Internet Connection'),
              content:
                  Text('Please connect to the internet and restart the app.'),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    initialiseApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light, // For iOS: (dark icons)
            statusBarIconBrightness:
                Brightness.dark, // For Android: (dark icons)
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: size.height * 0.15,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/splash-image.jpeg',
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35),
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CINE',
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 35,
                        fontFamily: 'Merriweather',
                        fontWeight: FontWeight.w900,
                        color: Color(0xff2572FE),
                      ),
                    ),
                    Text(
                      ' VPN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2572FE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> checkForUpdate(
    HaberApp app, BuildContext context, Function moveToHome) {
  if (app.isUpdated) {
    Future.delayed(
        const Duration(seconds: 3), () => app.isUpdated ? moveToHome() : null);
  } else {
    // Show user update dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                app.updateIsMajor ? 'Major Update Needed' : 'Update Available'),
            content: Text(app.updateIsMajor
                ? app.appConfig[app.platform]['MajorUpdateNotice']
                : app.appConfig[app.platform]['MinorUpdateNotice']),
            actions: [
              TextButton(
                  onPressed: () {
                    app.updateIsMajor ? null : Navigator.pop(context);
                    moveToHome();
                  },
                  child: Text(app.updateIsMajor ? 'Exit' : 'Later')),
              TextButton(
                  onPressed: () {
                    // Open app store
                    launchUrl(Uri.parse(
                        app.appConfig[app.platform]['MinorUpdateUrl']));
                    Navigator.pop(context);
                    moveToHome();
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
  return Future.value();
}
