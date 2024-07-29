// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Web application imports
import 'package:web/src/app_module.dart';
import 'package:web/src/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreConfig.initialize();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
