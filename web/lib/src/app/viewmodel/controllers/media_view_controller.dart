// External packages
import 'package:signals_flutter/signals_flutter.dart';

class MediaViewController {
  final _hasInternet = signal(true);

  bool get hasInternet => _hasInternet();

  Future<void> checkInternet() async {}
}
