import 'package:go_with_me/domain/services/app_services.dart';

import '../api/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<void> login(String username, String password) async {
    final response = await apiClient.dio.post(
      '/auth/login',
      queryParameters: {'username': username, 'password': password},
    );

    final data = response.data;
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];

    await apiClient.saveTokens(accessToken, refreshToken);
  }

  Future<void> register(String username, String password) async {
    final response = await apiClient.dio.post(
      '/auth/register',
      queryParameters: {'username': username, 'password': password},
    );

    final data = response.data;
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];

    await apiClient.saveTokens(accessToken, refreshToken);
    await profileRepository.createProfile();
  }
}
