import 'package:flutter/foundation.dart';

import '../../core/errors/failure.dart';
import '../../core/session/session_controller.dart';
import '../../domain/repositories/auth_repository.dart';
import 'profile_state.dart';

class ProfileViewModel {
  final AuthRepository repository;
  final ValueNotifier<ProfileState> state = ValueNotifier(const ProfileState());

  ProfileViewModel(this.repository);

  Future<void> load() async {
    final token = SessionController.instance.token;
    if (token == null || token.isEmpty) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: 'Sessão expirada. Faça login novamente.',
      );
      return;
    }

    state.value = state.value.copyWith(isLoading: true);
    try {
      final profile = await repository.getCurrentUser(token);
      state.value = state.value.copyWith(isLoading: false, profile: profile);
    } on Failure catch (f) {
      state.value = state.value.copyWith(isLoading: false, error: f.message);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }
}
