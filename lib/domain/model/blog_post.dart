import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_post.freezed.dart';

@freezed
abstract class BlogPost with _$BlogPost {
  const factory BlogPost({
    @Default('') String title,
    required String body,
    @Default(false) bool isTruncated,
  }) = _BlogPost;
}
