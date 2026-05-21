import 'package:dio/dio.dart';

import '../../core/errors/failure.dart';
import '../models/auth_user_model.dart';
import '../models/user_profile_model.dart';

class AuthRemoteDatasource {
  final Dio client;
  AuthRemoteDatasource(this.client);

  final String _base = "https://dummyjson.com/auth";

  Future<AuthUserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      "$_base/login",
      data: {
        "username": username,
        "password": password,
        "expiresInMins": 30,
      },
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
    );
    return AuthUserModel.fromJson(response.data);
  }

  Future<UserProfileModel> getCurrentUser(String accessToken) async {
    try {
      final response = await client.get(
        "$_base/me",
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw Failure('Token inválido ou expirado');
      }
      throw Failure('Falha ao carregar o perfil');
    }
  }
}
