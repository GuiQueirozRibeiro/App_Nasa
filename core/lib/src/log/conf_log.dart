// External packages
import 'package:flutter/material.dart';

class ConfLog {
  final String message;
  final IconData icon;
  final Color color;
  final String title;

  const ConfLog.d({required this.message})
      : icon = Icons.code,
        color = Colors.blue,
        title = 'Debug';

  const ConfLog.e({required this.message})
      : icon = Icons.block,
        color = Colors.red,
        title = 'Error';

  const ConfLog.i({required this.message})
      : icon = Icons.info,
        color = Colors.green,
        title = 'Info';

  const ConfLog.t({required this.message})
      : icon = Icons.abc,
        color = Colors.purple,
        title = 'Verbose';

  const ConfLog.w({required this.message})
      : icon = Icons.warning,
        color = Colors.amber,
        title = 'Warning';

  const ConfLog.f({required this.message})
      : icon = Icons.warning,
        color = Colors.orange,
        title = 'What a Terrible Failure';
}
