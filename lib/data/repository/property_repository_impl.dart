import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/data/mapper/blog_post_mapper.dart';
import 'package:vine_butler/data/mapper/property_image_mapper.dart';
import 'package:vine_butler/data/mapper/property_mapper.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
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

      if (image != null) { (images[property.id] ??= []).add(image.toDomain()); }
    }
    return [
      for (final row in propertyRows.values) row.toDomain(images: images[row.id] ?? const []),
    ];
  }

  @override
  Stream<List<Property>> watchList() {
    final query = _propertiesWithImages()
      ..where(_db.propertyTable.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(_db.propertyTable.updatedAt),
        OrderingTerm.asc(_db.propertyImageTable.order),
      ]);

    return query.watch().map(_toProperties);
  }

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) {
    final transactionType = condition.transactionType;
    final price = condition.price;
    final keyword = condition.keyword.trim();
    final query = _db.select(_db.propertyTable)..where((t) => t.deletedAt.isNull());

    if (transactionType != null) { query.where((t) => t.transactionType.equalsValue(transactionType)); }
    if (condition.propertyTypes.isNotEmpty) { query.where((t) => t.propertyType.isInValues(condition.propertyTypes)); }

    if (keyword.isNotEmpty) {
      const escape = r'\';
      final escaped = keyword.replaceAll(escape, '$escape$escape').replaceAll('%', '$escape%').replaceAll('_', '${escape}_');
      final pattern = '%$escaped%';

      query.where(
        (t) =>
            t.roadAddress.like(pattern, escapeChar: escape) |
            t.lotAddress.like(pattern, escapeChar: escape) |
            t.detailAddress.like(pattern, escapeChar: escape),
      );
    }
    query.orderBy([
      if (price != null) (t) => OrderingTerm.asc((t.price - Variable(price)).abs()),
      (t) => OrderingTerm.desc(t.updatedAt),
      (t) => OrderingTerm.asc(t.id),
    ]);

    return query.watch().asyncMap(_withImages);
  }

  Future<List<Property>> _withImages(List<PropertyTableData> rows) async {
    final imageRows = await (_db.select(_db.propertyImageTable)
          ..where((t) => t.propertyId.isIn(rows.map((row) => row.id)))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
    final images = <String, List<PropertyImage>>{};

    for (final image in imageRows) {
      (images[image.propertyId] ??= []).add(image.toDomain());
    }
    return [
      for (final row in rows) row.toDomain(images: images[row.id] ?? const []),
    ];
  }

  @override
  Future<Property?> getById(String id) async {
    final query = _propertiesWithImages()
      ..where(_db.propertyTable.id.equals(id) & _db.propertyTable.deletedAt.isNull())
      ..orderBy([OrderingTerm.asc(_db.propertyImageTable.order)]);

    final property = _toProperties(await query.get()).firstOrNull;

    if (property == null) { return null; }

    final postRow = await (_db.select(_db.propertyBlogPostTable)..where((t) => t.propertyId.equals(id))).getSingleOrNull();

    return property.copyWith(blogPost: postRow?.toDomain());
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

  /// 매물의 블로그 포스트 저장
  /// 
  /// 매물의 `updatedAt`은 바꾸지 않음
  @override
  Future<void> saveBlogPost(String propertyId, BlogPost post) async {
    final propertyUpdatedAt = post.propertyUpdatedAt ??
        (await (_db.select(_db.propertyTable)..where((t) => t.id.equals(propertyId))).getSingle()).updatedAt;
    final companion = post.toCompanion(propertyId, propertyUpdatedAt: propertyUpdatedAt, updatedAt: DateTime.now());

    await _db.into(_db.propertyBlogPostTable).insertOnConflictUpdate(companion);
  }
}
