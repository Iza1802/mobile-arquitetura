import 'package:dio/dio.dart';

import '../../core/errors/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await remote.login(
        username: username,
        password: password,
      );
      return model.toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        throw Failure('Usuário ou senha inválidos');
      }
      throw Failure('Falha ao conectar com o servidor');
    } catch (_) {
      throw Failure('Usuário ou senha inválidos');
    }
  }

  @override
  Future<UserProfile> getCurrentUser(String accessToken) async {
    final model = await remote.getCurrentUser(accessToken);
    return model.toEntity();
  }
}
