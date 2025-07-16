import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

const Map<int, String> defaultErrorMessages = {
  400: 'Некорректные данные. Проверьте введённую информацию.',
  401: 'Авторизация не удалась. Попробуйте войти снова.',
  403: 'У вас нет доступа к этому ресурсу.',
  404: 'Данные не найдены.',
  409: 'Этот пользователь уже существует.',
  500: 'Произошла внутренняя ошибка сервера. Попробуйте позже.',
  502: 'Проблемы с сервером. Повторите позже.',
  503: 'Сервер временно недоступен.',
};

void showApiError(BuildContext context, DioException error) {
  final statusCode = error.response?.statusCode;
  final responseData = error.response?.data;

  // Попытка вытащить сообщение от сервера
  String? serverMessage;
  if (responseData is Map<String, dynamic>) {
    serverMessage = responseData['details']?.toString();
  }

  final message =
      serverMessage ??
      defaultErrorMessages[statusCode] ??
      'Произошла ошибка. Повторите попытку.';

  final messenger = rootScaffoldMessengerKey.currentState;
  messenger?.clearSnackBars();
  messenger?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 4),
    ),
  );
}
