import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

void showApiError(DioException error) {
  final statusCode = error.response?.statusCode;

  final message = 'errors.${statusCode ?? 'default'}'.tr();

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
