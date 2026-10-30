import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/tables/property_table.dart';

/// 매물별 최신 블로그 포스트 (매물:포스트 = 1:1)
///
/// - `propertyUpdatedAt`: 글을 만들 때 매물의 `updatedAt`로 매물의 수정 여부 판단
/// - `updatedAt`: 글을 저장한 시각
class PropertyBlogPostTable extends Table {
  @override
  String get tableName => 'property_blog_posts';

  TextColumn get propertyId => text().references(PropertyTable, #id)();
  TextColumn get title => text()();
  TextColumn get body => text()();
  DateTimeColumn get propertyUpdatedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {propertyId};
}
