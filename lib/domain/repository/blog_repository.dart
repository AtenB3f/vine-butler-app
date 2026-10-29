import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';

abstract class BlogRepository {
  Future<BlogPost> write(Property property);
}
