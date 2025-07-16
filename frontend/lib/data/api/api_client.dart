import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_with_me/data/enums/get_storage_key.dart';
import 'package:go_with_me/data/models/error_messages.dart';
import 'package:go_with_me/main.dart';

class ApiClient {
  final GetStorage storage = GetStorage();
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/',
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
            }
          }
          if (!suppressNotification) {
            final statusCode = e.response?.statusCode;
            final data = e.response?.data;
        

            String? serverMessage;

            if (data is Map<String, dynamic>) {
              serverMessage = data['details'] ?? data['detail'];
            }

            final fallback = 'Произошла ошибка. Попробуйте позже.';
            final message =
                serverMessage?.toString() ??
                defaultErrorMessages[statusCode] ??
                fallback;

            final messenger = rootScaffoldMessengerKey.currentState;
            messenger?.clearSnackBars();
            messenger?.showSnackBar(
              SnackBar(
                content: Text(
                  "❌ $message",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
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
