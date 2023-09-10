package com.example.cinevpn

import io.flutter.embedding.android.FlutterActivity

// VPN PLUGIN
import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin;
import android.content.Intent;


class MainActivity: FlutterActivity() {

    // Flutter OpenVPNFlutterPlugin
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK)
        super.onActivityResult(requestCode, resultCode, data)
    }
    // Flutter OpenVPNFlutterPlugin

}

