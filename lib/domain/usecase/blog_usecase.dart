import 'package:vine_butler/domain/exception/permission_denied_exception.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/user_role.dart';
import 'package:vine_butler/domain/repository/blog_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/repository/user_role_repository.dart';

class BlogUseCase {
  const BlogUseCase(this._blogRepository, this._propertyRepository, this._userRoleRepository);

  final BlogRepository _blogRepository;
  final PropertyRepository _propertyRepository;
  final UserRoleRepository _userRoleRepository;

  Future<bool> isAuthorized() async => await _userRoleRepository.currentRole() == UserRole.master;

  /// 매물의 저장된 블로그 포스트 조회
  ///
  /// - `BlogPost`: 현재 매물 정보로 작성된 포스트
  /// - `null`: 저장된 글이 없거나 작성 후 매물이 수정되어 새로 필요한 경우
  Future<BlogPost?> fetch(String propertyId) async {
    final property = await _propertyRepository.getById(propertyId);
    final post = property?.blogPost;

    if (post == null || post.propertyUpdatedAt != property?.updatedAt) { return null; }

    return post;
  }

  Future<BlogPost?> write(String propertyId) async {
    if (!await isAuthorized()) { throw const PermissionDeniedException(); }

    final property = await _propertyRepository.getById(propertyId);

    if (property == null) { return null; }

    final post = (await _blogRepository.write(property)).copyWith(propertyUpdatedAt: property.updatedAt);

    await save(propertyId, post);
    return post;
  }

  Future<void> save(String propertyId, BlogPost post) async {
    if (!await isAuthorized()) { throw const PermissionDeniedException(); }

    await _propertyRepository.saveBlogPost(propertyId, post);
  }
}
