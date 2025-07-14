import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_with_me/domain/services/shared_preferences_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  final prefs = SharedPreferencesService();
                  prefs.clearProfile();
                  prefs.clearToken();
                  context.go('/auth');
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
