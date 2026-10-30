import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/domain/model/blog_post.dart';

extension BlogPostRowMapper on PropertyBlogPostTableData {
  BlogPost toDomain() {
    return BlogPost(title: title, body: body, propertyUpdatedAt: propertyUpdatedAt);
  }
}

extension BlogPostDomainMapper on BlogPost {
  PropertyBlogPostTableCompanion toCompanion(String propertyId, {required DateTime propertyUpdatedAt, required DateTime updatedAt}) {
    return PropertyBlogPostTableCompanion(
      propertyId: Value(propertyId),
      title: Value(title),
      body: Value(body),
      propertyUpdatedAt: Value(propertyUpdatedAt),
      updatedAt: Value(updatedAt),
    );
  }
}
