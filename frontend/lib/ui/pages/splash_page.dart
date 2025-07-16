import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_with_me/data/enums/get_storage_key.dart';
import 'package:go_with_me/domain/services/app_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final refreshToken = await apiClient.storage.read(
      GetStorageKey.refreshToken.value,
    );
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final newAccessToken = await apiClient.refreshToken();

      if (newAccessToken != null) {
        await apiClient.saveTokens(newAccessToken, refreshToken);

        if (mounted) context.go('/home');

        return;
      }
    }

    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
