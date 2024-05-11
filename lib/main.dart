import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:nasa/init_dependencies.dart';
import 'package:nasa/src/core/config/app_config.dart';
import 'package:provider/provider.dart';

import 'src/app/presentation/pages/home_page.dart';
import 'src/core/config/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/assets/i18n'];
    SizeConfig().init(context);

    return MultiProvider(
      providers: AppConfig.appProviders,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade700,
          ),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppConfig.localizationsDelegates,
        supportedLocales: AppConfig.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
