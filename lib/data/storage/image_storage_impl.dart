import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:vine_butler/domain/repository/image_storage.dart';

class ImageStorageImpl implements ImageStorage {
  ImageStorageImpl(this._directory, [this._uuid = const Uuid()]);

  final Directory _directory;
  final Uuid _uuid;

  @override
  Future<String> save(String sourcePath) async {
    final name = sourcePath.split(RegExp(r'[/\\]')).last;
    final dotIndex = name.lastIndexOf('.');
    final extension = dotIndex > 0 ? name.substring(dotIndex).toLowerCase() : '';
    final fileName = '${_uuid.v4()}$extension';

    await _directory.create(recursive: true);
    await File(sourcePath).copy(path(fileName));
    return fileName;
  }

  @override
  Future<void> delete(String fileName) async {
    final file = File(path(fileName));

    if (await file.exists()) { await file.delete(); }
  }

  @override
  String path(String fileName) => '${_directory.path}${Platform.pathSeparator}$fileName';
}
