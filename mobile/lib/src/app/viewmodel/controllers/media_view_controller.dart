// External packages
import 'package:core/core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class MediaViewController {
  final ConnectionChecker _connectionChecker;

  MediaViewController({
    required ConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  final _hasInternet = signal(true);

  bool get hasInternet => _hasInternet();

  Future<void> checkInternet() async {
    _hasInternet.value = await _connectionChecker.isConnected;
  }
}
