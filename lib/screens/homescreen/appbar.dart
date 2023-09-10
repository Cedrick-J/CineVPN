import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const _kBgColor = Color(0xff246CE2);

PreferredSize myAppBar() {
  return PreferredSize(
    preferredSize: Size.zero,
    child: AppBar(
      elevation: 0,
      backgroundColor: _kBgColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: _kBgColor,
        statusBarBrightness: Brightness.dark, // For iOS: (dark icons)
        statusBarIconBrightness: Brightness.light, // For Android: (dark icons)
      ),
    ),
  );
}