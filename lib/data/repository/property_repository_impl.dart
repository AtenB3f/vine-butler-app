import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/mapper/property_image_mapper.dart';
import 'package:vine_butler/data/mapper/property_mapper.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  PropertyRepositoryImpl(this._db);

  final AppDatabase _db;

  JoinedSelectStatement<HasResultSet, dynamic> _propertiesWithImages() {
    return _db.select(_db.propertyTable).join([
      leftOuterJoin(
        _db.propertyImageTable,
        _db.propertyImageTable.propertyId.equalsExp(_db.propertyTable.id),
      ),
    ]);
  }

  List<Property> _toProperties(List<TypedResult> rows) {
    final propertyRows = <String, PropertyTableData>{};
    final images = <String, List<PropertyImage>>{};
    for (final row in rows) {
      final property = row.readTable(_db.propertyTable);
      propertyRows.putIfAbsent(property.id, () => property);
      final image = row.readTableOrNull(_db.propertyImageTable);
      if (image != null) {
        (images[property.id] ??= []).add(image.toDomain());
      }
    }
    return [
      for (final row in propertyRows.values) row.toDomain(images: images[row.id] ?? const []),
    ];
  }

  @override
  Stream<List<Property>> watchAll() {
    final query = _propertiesWithImages()
      ..where(_db.propertyTable.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(_db.propertyTable.updatedAt),
        OrderingTerm.asc(_db.propertyImageTable.order),
      ]);
    return query.watch().map(_toProperties);
  }

  @override
  Future<Property?> getById(String id) async {
    final query = _propertiesWithImages()
      ..where(_db.propertyTable.id.equals(id) & _db.propertyTable.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.propertyImageTable.order)]);
    return _toProperties(await query.get()).firstOrNull;
  }

  @override
  Future<void> save(Property property) {
    final updated = property.copyWith(updatedAt: DateTime.now());
    return _db.transaction(() async {
      await _db.into(_db.propertyTable).insertOnConflictUpdate(updated.toCompanion());
      await (_db.delete(_db.propertyImageTable)..where((t) => t.propertyId.equals(updated.id))).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.propertyImageTable,
          [for (final image in updated.images) image.toCompanion(updated.id)],
        );
      });
    });
  }

  @override
  Future<void> delete(String id) {
    final now = DateTime.now();
    return (_db.update(_db.propertyTable)..where((t) => t.id.equals(id))).write(
      PropertyTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
