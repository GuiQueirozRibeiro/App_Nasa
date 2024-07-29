// Dart native imports
import 'dart:io';

// External packages
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CoreConfig {
  const CoreConfig._();

  static Future<Box> initialize() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final mediaDirectory = Directory(
      path.join(appDocumentDirectory.path, 'media'),
    );

    if (!await mediaDirectory.exists()) {
      await mediaDirectory.create(recursive: true);
    }

    // Initialize Hive
    Hive.init(mediaDirectory.path);
    return await Hive.openBox('media');
  }
}
