import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vine_butler/data/local/tables/property_blog_post_table.dart';
import 'package:vine_butler/data/local/tables/property_image_table.dart';
import 'package:vine_butler/data/local/tables/property_table.dart';
import 'package:vine_butler/domain/property_type.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [PropertyTable, PropertyImageTable, PropertyBlogPostTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ??
              driftDatabase(
                name: 'vine_butler',
                native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
              ),
        );

  /// DB 스키마 버전 (출시 후 테이블을 바꾸면 올리고 `onUpgrade`에 마이그레이션 추가)
  ///
  /// - `1`: 매물, 매물 사진 테이블
  /// - `2`: 매물 블로그 포스트 테이블 추가
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) { await m.createTable(propertyBlogPostTable); }
        },
        beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
      );
}
