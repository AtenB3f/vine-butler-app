import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';

abstract class PropertyRepository {
  Stream<List<Property>> watchList();

  Stream<List<Property>> watchFilter(PropertySearchCondition condition);

  Future<Property?> getById(String id);

  Future<void> save(Property property);

  Future<void> delete(String id);
}
