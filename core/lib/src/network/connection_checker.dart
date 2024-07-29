// External packages
import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final Connectivity _connectivity;
  ConnectionCheckerImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      return true;
    } else {
      return false;
    }
  }
}
