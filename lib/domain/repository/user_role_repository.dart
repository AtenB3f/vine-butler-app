import 'package:vine_butler/domain/model/user_role.dart';

abstract class UserRoleRepository {
  Future<UserRole> currentRole();
}
