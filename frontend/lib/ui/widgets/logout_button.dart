import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_with_me/domain/providers/search_provider.dart';
import 'package:go_with_me/domain/services/app_services.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Выход'),
            content: Text('Вы уверены, что хотите выйти?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Нет'),
              ),
              TextButton(
                onPressed: () async {
                  await apiClient.clearTokens();
                  ref.read(searchProvider).resetAll();
                  sharedPreferences.clearProfile();
                  if (context.mounted) context.go('/auth');
                },
                child: Text('Да'),
              ),
            ],
          ),
        );
      },
      child: Text(
        "Выйти",
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.red, fontSize: 20),
      ),
    );
  }
}
