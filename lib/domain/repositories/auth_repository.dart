import '../entities/auth_user.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String username,
    required String password,
  });

  Future<UserProfile> getCurrentUser(String accessToken);
}
