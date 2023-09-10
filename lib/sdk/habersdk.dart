import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:cinevpn/sdk/load_internet_requests.dart';

class AppConfig {}

class HaberApp {
  final Map config;
  late Map _appConfig;
  bool _isInitialised = false;
  bool _isUpdated = false;
  bool _updateIsMajor = false;

  String get platform => _getPlatformName();

// CONSTRUCTOR - Parse app config for the App
  HaberApp({required this.config});

// Get platform kind
  String _getPlatformName() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else {
      return 'Android';
    }
  }

// Get app config file form server
  Future<void> _getAppConfig() async {
    final HaberHttpFetchResponse response = await HaberHttpFetch(
            url: Uri.parse(
                "https://gist.githubusercontent.com/Cedrick-J/5453d54d1bc1355739f0fe5b3d55e0a5/raw/${config['packagename']}.json"),
            cacheKey: 'appConfig')
        .fetchData();
    if (response.wasSuccessful) {
      _appConfig = json.decode(response.data);
      response.loadedFromCache
          ? developer.log('Loaded from cache')
          : developer.log('Loaded from server');
    }
    if (response.loadedFromCache == true) {
      developer.log(response.error!);
    }
  }

// Check for Updates.
  Future<void> checkForUpdate() {
    if (config['version'] < _appConfig[platform]['MajorUpdate']) {
      //Major update available. Update immediately
      _isUpdated = false;
      _updateIsMajor = true;
    } else if (config['version'] < _appConfig[platform]['MinorUpdate']) {
      //Minor update available. Inform user
      _isUpdated = false;
      _updateIsMajor = false;
    } else {
      // App is updated
      _isUpdated = true;
      _updateIsMajor = false;
    }
    return Future.value();
  }

// Iniatilise App and run all checks.
  Future<bool> initialise() async {
    if (_isInitialised) {
      return Future.value(true);
    } else {
      await _getAppConfig();
      await checkForUpdate();
      _isInitialised = true;
      return true;
    }
  }

// Getters for the App properties.
  Map get appConfig => _appConfig;
  bool get isInitialised => _isInitialised;
  bool get isUpdated => _isUpdated;
  bool get updateIsMajor => _updateIsMajor;
}
