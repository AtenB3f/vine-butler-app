import 'package:drift/drift.dart';
import 'package:vine_butler/domain/property_type.dart';

class PropertyTable extends Table {
  @override
  String get tableName => 'properties';

  TextColumn get id => text()();
  TextColumn get ownerName => text()();
  TextColumn get ownerPhone => text()();
  TextColumn get transactionType => textEnum<PropertyTransactionType>()();
  TextColumn get propertyType => textEnum<PropertyType>()();
  IntColumn get price => integer()();
  IntColumn get monthlyRent => integer().nullable()();
  TextColumn get zipCode => text()();
  TextColumn get roadAddress => text()();
  TextColumn get lotAddress => text()();
  TextColumn get sido => text()();
  TextColumn get sigungu => text()();
  TextColumn get dongMyeon => text()();
  TextColumn get buildingName => text().nullable()();
  TextColumn get detailAddress => text().withDefault(const Constant(''))();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  BoolColumn get isSuretyInsuranceAvailable => boolean().nullable()();
  BoolColumn get hasLoan => boolean().nullable()();
  BoolColumn get isParkingAvailable => boolean().nullable()();
  DateTimeColumn get moveInDate => dateTime().nullable()();
  BoolColumn get isFlexibleMoveInDate => boolean().withDefault(const Constant(false))();
  IntColumn get roomCount => integer().nullable()();
  TextColumn get furnitureOptions => text().map(const StringListConverter()).withDefault(const Constant(''))();
  TextColumn get memo => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) => fromDb.isEmpty ? const [] : fromDb.split('\u0001');

  @override
  String toSql(List<String> value) => value.join('\u0001');
}
