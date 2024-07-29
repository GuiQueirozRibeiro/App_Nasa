// External packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

// Mobile application imports
import 'package:mobile/init_dependencies.dart';
import 'package:mobile/src/app/viewmodel/bloc/media_bloc.dart';
import 'package:mobile/src/app/viewmodel/controllers/media_state_controller.dart';
import 'package:mobile/src/app/view/pages/home_page.dart';

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

    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<MediaBloc>()),
        ChangeNotifierProvider<MediaStateController>(
          create: (_) => serviceLocator<MediaStateController>(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade700,
          ),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          LocalJsonLocalization.delegate
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
          Locale('pt', 'BR'),
        ],
        home: const HomePage(),
      ),
    );
  }
}
