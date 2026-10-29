import 'package:flutter/foundation.dart';
import 'package:vine_butler/domain/model/user_role.dart';
import 'package:vine_butler/domain/repository/user_role_repository.dart';

/// 사용자 권한 구현체
/// (로그인 연동 전까지 debug 빌드는 master)
class UserRoleRepositoryImpl implements UserRoleRepository {
  const UserRoleRepositoryImpl();

  @override
  Future<UserRole> currentRole() async => kDebugMode ? UserRole.master : UserRole.none;
}
