// lib/core/network/connectivity_checker.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityChecker {
  ConnectivityChecker._();

  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }
}