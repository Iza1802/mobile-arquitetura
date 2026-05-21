import 'package:flutter/foundation.dart';

import '../../core/errors/failure.dart';
import '../../core/session/session_controller.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel {
  final AuthRepository repository;
  final ValueNotifier<AuthState> state = ValueNotifier(const AuthState());

  AuthViewModel(this.repository);

  Future<void> login(String username, String password) async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final user = await repository.login(
        username: username,
        password: password,
      );
      SessionController.instance.login(user);
      state.value = state.value.copyWith(isLoading: false, user: user);
    } on Failure catch (f) {
      state.value = state.value.copyWith(isLoading: false, error: f.message);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }
}
