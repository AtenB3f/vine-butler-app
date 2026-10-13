import 'package:vine_butler/domain/model/property.dart';

abstract class PropertyRepository {
  Stream<List<Property>> watchAll();

  Future<Property?> getById(String id);

  Future<void> save(Property property);

  Future<void> delete(String id);
}
