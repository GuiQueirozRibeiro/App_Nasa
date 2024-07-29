// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Mobile application imports
import 'package:mobile/src/app/view/pages/detail_page.dart';
import 'package:mobile/src/app/view/pages/home_page.dart';
import 'package:mobile/src/app/viewmodel/controllers/media_view_controller.dart';
import 'package:mobile/src/app/viewmodel/providers/media_provider.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Register all dependencies
    bindCoreDependencies(i);
    bindMediaDependencies(i);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (_) => const HomePage());
    r.child('/detail', child: (_) => DetailPage(media: r.args.data));
  }

  void bindCoreDependencies(Injector i) {
    // Http Service
    i.addLazySingleton<IHttp>(() => HttpDio());

    // Connectivity
    i.add(Connectivity.new);
    i.add<ConnectionChecker>(ConnectionCheckerImpl.new);
  }

  void bindMediaDependencies(Injector i) {
    // Datasource
    i.add<MediaLocalDataSource>(MediaLocalDataSourceImpl.new);
    i.add<MediaRemoteDataSource>(MediaRemoteDataSourceImpl.new);

    // Repository
    i.add<MediaRepository>(MediaRepositoryImpl.new);

    // Usecases
    i.add(GetMedia.new);
    i.add(GetMoreMedia.new);
    i.add(SearchMedia.new);

    // Providers
    i.addLazySingleton(MediaProvider.new);

    // Controllers
    i.addLazySingleton(MediaViewController.new);
  }
}
