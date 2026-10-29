import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_post.freezed.dart';

/// 매물 블로그 포스트
///
/// - `propertyUpdatedAt`: 이 글을 만들 때 매물의 `updatedAt` (매물과 다르면 이후 매물이 수정된 것)
@freezed
abstract class BlogPost with _$BlogPost {
  const factory BlogPost({
    @Default('') String title,
    required String body,
    @Default(false) bool isTruncated,
    DateTime? propertyUpdatedAt,
  }) = _BlogPost;
}
