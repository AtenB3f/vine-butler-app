import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/domain/model/property_image.dart';

extension PropertyImageRowMapper on PropertyImageTableData {
  PropertyImage toDomain() {
    return PropertyImage(
      id: id,
      fileName: fileName,
      order: order,
      createdAt: createdAt,
    );
  }
}

extension PropertyImageDomainMapper on PropertyImage {
  PropertyImageTableCompanion toCompanion(String propertyId) {
    return PropertyImageTableCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      fileName: Value(fileName),
      order: Value(order),
      createdAt: Value(createdAt),
    );
  }
}
