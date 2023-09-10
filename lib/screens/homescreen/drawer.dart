import 'package:flutter/material.dart';
import 'package:cinevpn/screens/change_language.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

const _kBgColor = Color(0xff246CE2);

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
                    color: _kBgColor,
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
          ListTile(
            onTap: () => url_launcher.launchUrl(
                Uri.parse('https://apps.habertech.info/2023/09/cinevpn.html')),
            leading: const Icon(
              Icons.rate_review,
              size: 18,
            ),
            title: const Text(
              'Rate US',
              style: TextStyle(fontSize: 14),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.share,
              size: 18,
            ),
            title: Text(
              'Share App',
              style: TextStyle(fontSize: 14),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.info,
              size: 18,
            ),
            title: Text(
              'About',
              style: TextStyle(fontSize: 14),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

void openShareView() {
  url_launcher.launchUrl(Uri.parse(''));
}
