import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'src/app/data/datasources/media_local_data_source.dart';
import 'src/app/data/datasources/media_remote_data_source.dart';
import 'src/app/data/repositories/media_repository_impl.dart';
import 'src/app/domain/repositories/media_repository.dart';
import 'src/app/domain/usecases/get_media.dart';
import 'src/app/domain/usecases/get_more_media.dart';
import 'src/app/domain/usecases/search_media.dart';
import 'src/app/presentation/bloc/media_bloc.dart';
import 'src/app/presentation/controllers/media_state_controller.dart';
import 'src/core/network/connection_checker.dart';
import 'src/core/secrets/app_secrets.dart';
import 'src/core/utils/http_dio.dart';

part 'init_dependencies.main.dart';
