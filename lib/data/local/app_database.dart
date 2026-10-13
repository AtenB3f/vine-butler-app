import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:vine_butler/data/local/tables/property_image_table.dart';
import 'package:vine_butler/data/local/tables/property_table.dart';
import 'package:vine_butler/domain/property_type.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PropertyTable, PropertyImageTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'vine_butler'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
      );
}
