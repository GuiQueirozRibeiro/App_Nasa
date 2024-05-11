import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../init_dependencies.dart';
import '../../app/presentation/bloc/media_bloc.dart';
import '../../app/presentation/controllers/media_state_controller.dart';

class AppConfig {
  static final List<SingleChildWidget> appProviders = [
    BlocProvider(create: (_) => serviceLocator<MediaBloc>()),
    ChangeNotifierProvider<MediaStateController>(
      create: (_) => serviceLocator<MediaStateController>(),
    ),
  ];

  static final Iterable<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    LocalJsonLocalization.delegate
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'BR'),
  ];
}
