import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/user_role.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  UserRole? build() {
    return null; // 默认未登录/未选择角色
  }

  void setRole(UserRole role) {
    state = role;
  }

  void logout() {
    state = null;
  }
}
