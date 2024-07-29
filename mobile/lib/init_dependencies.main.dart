part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // App Directory
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final mediaDirectory = Directory(
    path.join(appDocumentDirectory.path, 'media'),
  );
  if (!await mediaDirectory.exists()) {
    await mediaDirectory.create(recursive: true);
  }
  serviceLocator.registerLazySingleton(() => mediaDirectory);

  // Local Database
  Hive.init(mediaDirectory.path);
  await Hive.openBox('media');
  serviceLocator.registerLazySingleton(() => Hive.box('media'));

  // Core
  serviceLocator.registerLazySingleton<IHttp>(() => HttpDio());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator<InternetConnection>(),
    ),
  );

  // Datasource
  serviceLocator
    ..registerFactory<MediaRemoteDataSource>(
      () => MediaRemoteDataSourceImpl(
        serviceLocator<IHttp>(),
      ),
    )
    ..registerFactory<MediaLocalDataSource>(
      () => MediaLocalDataSourceImpl(
        serviceLocator<Box>(),
        serviceLocator<IHttp>(),
      ),
    )
    // Repository
    ..registerFactory<MediaRepository>(
      () => MediaRepositoryImpl(
        serviceLocator<MediaRemoteDataSource>(),
        serviceLocator<MediaLocalDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetMedia(
        serviceLocator<MediaRepository>(),
      ),
    )
    ..registerFactory(
      () => GetMoreMedia(
        serviceLocator<MediaRepository>(),
      ),
    )
    ..registerFactory(
      () => SearchMedia(
        serviceLocator<MediaRepository>(),
      ),
    );

  // Controller
  serviceLocator.registerLazySingleton(
    () => MediaStateController(
      connectionChecker: serviceLocator<ConnectionChecker>(),
    ),
  );

  // Bloc
  serviceLocator.registerLazySingleton(
    () => MediaBloc(
      getMedia: serviceLocator<GetMedia>(),
      getMoreMedia: serviceLocator<GetMoreMedia>(),
      searchMedia: serviceLocator<SearchMedia>(),
    ),
  );
}
