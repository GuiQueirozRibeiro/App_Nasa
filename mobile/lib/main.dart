// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Mobile application imports
import 'package:mobile/src/app_module.dart';
import 'package:mobile/src/app_widget.dart';

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
