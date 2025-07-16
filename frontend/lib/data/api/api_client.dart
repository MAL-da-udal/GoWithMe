import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontend/data/enums/get_storage_key.dart';
import 'package:frontend/data/functions/show_api_error.dart';

final baseUrl = "http://mhdserver.ru:8080";

class ApiClient {
  final GetStorage storage = GetStorage();
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept'] = "application/json";
          options.followRedirects = true;
          String? token = storage.read(GetStorageKey.accessToken.value);
          options.headers['Authorization'] = "Bearer $token";
          return handler.next(options);
        },

        onError: (e, handler) async {
          final suppressNotification =
              e.requestOptions.extra['suppressErrorNotification'] == true;

          if (e.response?.statusCode == 401) {
            final newAccessToken = await refreshToken();
            if (newAccessToken != null) {
              await storage.write(
                GetStorageKey.accessToken.value,
                newAccessToken,
              );
              dio.options.headers['Authorization'] = "Bearer $newAccessToken";
              return handler.resolve(await dio.fetch(e.requestOptions));
            } else {
              storage.erase();
            }
          }
          if (!suppressNotification) {
            showApiError(e);
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = await storage.read(GetStorageKey.refreshToken.value);
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'];
      await storage.write(GetStorageKey.accessToken.value, newAccessToken);
      return newAccessToken;
    } catch (e) {
      await clearTokens();
      return null;
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await storage.write(GetStorageKey.accessToken.value, accessToken);
    await storage.write(GetStorageKey.refreshToken.value, refreshToken);
  }

  Future<void> clearTokens() async {
    await storage.erase();
  }
}
