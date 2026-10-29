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

  Future<BlogPost?> write(String propertyId) async {
    if (!await isAuthorized()) { throw const PermissionDeniedException(); }

    final property = await _propertyRepository.getById(propertyId);

    if (property == null) { return null; }

    return _blogRepository.write(property);
  }
}
