import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/tables/property_table.dart';

@TableIndex(name: 'property_images_property_id', columns: {#propertyId})
class PropertyImageTable extends Table {
  @override
  String get tableName => 'property_images';

  TextColumn get id => text()();
  TextColumn get propertyId => text().references(PropertyTable, #id)();
  TextColumn get fileName => text()();
  IntColumn get order => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
