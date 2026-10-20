abstract class ImageStorage {
  Future<String> save(String sourcePath);

  Future<void> delete(String fileName);

  String path(String fileName);
}
