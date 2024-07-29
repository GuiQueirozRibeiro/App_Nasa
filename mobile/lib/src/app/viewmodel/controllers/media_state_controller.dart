// External packages
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class MediaViewController {
  final ConnectionChecker _connectionChecker;

  MediaViewController({
    required ConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasInternet = ValueNotifier<bool>(true);

  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<bool> get hasInternet => _hasInternet;

  Future<void> checkInternet() async {
    _hasInternet.value = await _connectionChecker.isConnected;
  }

  void updateLoadingStatus() {
    _isLoading.value = !_isLoading.value;
  }
}
