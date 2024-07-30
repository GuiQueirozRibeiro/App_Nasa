// External packages
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

// Web application imports
import 'package:web/src/app/viewmodel/providers/media_provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/assets/i18n'];

    return ChangeNotifierProvider(
      create: (_) => Modular.get<MediaProvider>(),
      child: MaterialApp.router(
        theme: CoreTheme.lightTheme,
        darkTheme: CoreTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          LocalJsonLocalization.delegate
        ],
        supportedLocales: const [
          Locale('de', 'DE'),
          Locale('en', 'US'),
          Locale('es', 'ES'),
          Locale('pt', 'BR'),
        ],
        routerConfig: Modular.routerConfig,
      ),
    );
  }
}
