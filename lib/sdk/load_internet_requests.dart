import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HaberHttpFetchResponse {
  late String data;
  late bool wasSuccessful;
  late bool loadedFromCache;
  late String? error;
  late String? httpErrorCode;

  HaberHttpFetchResponse();

  final String httpError = 'HTTP_ERROR';
  final String noInternetConnection = 'NO_INTERNET_CONNECTION';
  final String noInternetNoCache = 'NO_INTERNET_NO_CACHE';
}

class HaberHttpFetch {
  final Uri url;
  final String cacheKey;
  final bool shouldCache;

  final HaberHttpFetchResponse _response = HaberHttpFetchResponse();

  HaberHttpFetch(
      {required this.url, required this.cacheKey, this.shouldCache = true});

  Future<HaberHttpFetchResponse> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _response.loadedFromCache = false;
    _response.httpErrorCode = 200.toString();
    // Check for internet connectivity
    try {
      final result = await InternetAddress.lookup(url.host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Make HTTP request
        final response = await http.get(url);
        if (response.statusCode == 200) {
          // request was successful
          _response.wasSuccessful = true;
          _response.data = response.body;
          // Process data
          // ...
          // Cache data
          if (shouldCache) {
            await prefs.setString(cacheKey, response.body);
          }
        } else {
          // Handle HTTP error
          // ...
          await _loadCachedData(prefs);
          // Return HTTP error
          _response.error = _response.httpError;
          _response.httpErrorCode = response.statusCode.toString();
        }
      } else {
        // Handle no internet connection
        // ...
        await _loadCachedData(prefs);
        // Return no internet error
        _response.error = _response.noInternetConnection;
      }
    } catch (error) {
      // Handle socket exception
      // ...
      await _loadCachedData(prefs);
      _response.wasSuccessful = true;
      // Return error
      _response.error = error.toString();
    }

    // Return response
    return _response;
  }

  Future<void> _loadCachedData(SharedPreferences prefs) async {
    final cacheData = prefs.getString(cacheKey);
    if (cacheData != null) {
      // Load data from cache
      _response.wasSuccessful = true;
      _response.loadedFromCache = true;
      _response.data = cacheData;
      // Process data
      // ...
    } else {
      // Handle no cache data
      // ...
      _response.wasSuccessful = false;
      // Return no internet no cache error
      _response.error = _response.noInternetNoCache;
    }
  }
}
