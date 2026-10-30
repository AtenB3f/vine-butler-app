import 'dart:async';

import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/model/blog_post.dart';

class FakePropertyRepository implements PropertyRepository {
  Property? property;
  final List<Property> saved = [];
  final List<String> deletedIds = [];
  final List<PropertySearchCondition> requests = [];
  StreamController<List<Property>> controller = StreamController<List<Property>>();
  bool shouldFailSave = false;
  bool shouldFailDelete = false;

  @override
  Future<Property?> getById(String id) async => property?.id == id ? property : null;

  @override
  Future<void> save(Property property) async {
    if (shouldFailSave) { throw Exception('save failed'); }

    saved.add(property);
    this.property = property;
  }

  @override
  Stream<List<Property>> watchList() => controller.stream;

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) {
    requests.add(condition);
    controller = StreamController<List<Property>>();
    return controller.stream;
  }

  @override
  Future<void> delete(String id) async {
    if (shouldFailDelete) { throw Exception('delete failed'); }

    deletedIds.add(id);
  }

  @override
  Future<void> saveBlogPost(String propertyId, BlogPost post) async {}
}
