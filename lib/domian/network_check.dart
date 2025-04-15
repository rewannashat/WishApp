import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  static final _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
