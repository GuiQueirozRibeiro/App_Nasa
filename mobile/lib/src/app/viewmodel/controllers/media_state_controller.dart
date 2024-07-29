// External packages
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class MediaStateController extends ChangeNotifier {
  final ConnectionChecker _connectionChecker;

  MediaStateController({
    required ConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  bool _isLoading = false;
  bool _hasInternet = true;

  bool get isLoading => _isLoading;
  bool get hasInternet => _hasInternet;

  void checkInternet() async {
    _hasInternet = await _connectionChecker.isConnected;
    notifyListeners();
  }

  void updateLoadingStatus() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
