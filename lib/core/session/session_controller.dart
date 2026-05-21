import '../../domain/entities/auth_user.dart';

class SessionController {
  SessionController._();
  static final SessionController instance = SessionController._();

  AuthUser? _user;

  AuthUser? get user => _user;
  String? get token => _user?.accessToken;
  bool get isLoggedIn => _user != null;

  void login(AuthUser user) {
    _user = user;
  }

  void logout() {
    _user = null;
  }
}
